import UIKit
import SceneKit
import ARKit

class CameraViewController: UIViewController {
    
    // MARK: Outlets

    @IBOutlet private var sceneView: ARSCNView! {
        didSet {
            self.sceneView.delegate = self
        }
    }
    @IBOutlet private weak var takeSnapshotButton: UIButton!
    
    // MARK: ViewModel
    
    var cameraViewModel: CameraViewModel?
    func configure(_ cameraViewModel: CameraViewModel) {
        self.cameraViewModel = cameraViewModel
    }
    
    // MARK: Lifecycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cameraViewModel?.detectingWork = nil // Clear the previous detecting work
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }
    
    private var configuration: ARConfiguration {
        let configuration = ARWorldTrackingConfiguration()
        guard let detectionObjects = cameraViewModel?.detectionObjects else { fatalError() }
        configuration.detectionObjects = detectionObjects
        
        return configuration
    }
    
    // MARK: Actions
    
    @IBAction private func didTakeSnapshotButtonTap(_ sender: Any) {
        let snapshotImage = sceneView.snapshot()
        guard let cameraViewModel = cameraViewModel else { fatalError() }
        let previewViewModel = PreviewViewModel(snapshotImage: snapshotImage, detectingWork: cameraViewModel.detectingWork, stashedCameraViewModel: cameraViewModel)
        
        let previewViewController = PreviewViewController.loadViewControllerFromStoryboard()
        previewViewController.configure(previewViewModel)
        
        let presentingViewController = self.presentingViewController
        DispatchQueue.main.async {
            self.dismiss(animated: true) {
                presentingViewController?.present(previewViewController, animated: true, completion: nil)
            }
        }
    }
}

// MARK: - ARSCNViewDelegatea

extension CameraViewController: ARSCNViewDelegate {
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        
        guard let objectAnchor = anchor as? ARObjectAnchor else { return }
        
        // TODO: ARResourceImage
        let expectedResourceName = "\(objectAnchor.name ?? "").arobject"
        
        let works = DataStore.shared.works
        if let detectingWorkIndex =  works.firstIndex(where: { $0.resource == expectedResourceName }) {
            // Register the detecting work
            cameraViewModel?.detectingWork = works[detectingWorkIndex]
            // Show AR Objects
            addNode(to: node, for: objectAnchor)
        }
    }
    
    // TODO: Implement AR Objects
    private func addNode(to node: SCNNode, for objectAnchor: ARObjectAnchor) {
        
        switch objectAnchor.name {
        case "Syaro":
            let labelNode = LabelNode(text: "Syaro", width: 0.2, textColor: .blue, panelColor: .white, textThickness: 0.1, panelThickness: 0.2)
            node.addChildNode(labelNode)
            
        default:
            fatalError("Unknown object has been detected.")
        }
    }

    func session(_ session: ARSession, didFailWithError error: Error) {}
    func sessionWasInterrupted(_ session: ARSession) {}
    func sessionInterruptionEnded(_ session: ARSession) {}
}
