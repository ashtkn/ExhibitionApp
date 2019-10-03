import UIKit
import SceneKit
import ARKit

class CameraViewController: UIViewController {

    @IBOutlet private var sceneView: ARSCNView! {
        didSet {
            self.sceneView.delegate = self
        }
    }
    @IBOutlet private weak var takeSnapshotButton: UIButton!
    
    var viewModel: CameraViewModel?
    private var detectingWork: Work?
    
    func configure(_ viewModel: CameraViewModel) {
        self.viewModel = viewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }
    
    @IBAction private func didTakeSnapshotButtonTap(_ sender: Any) {
        let snapshotImage = sceneView.snapshot()
        
        let presentingViewController = self.presentingViewController
        let previewViewController = PreviewViewController.loadViewControllerFromStoryboard()
        
        let viweModel = PreviewViewModel(snapshotImage: snapshotImage, detectingWork: detectingWork)
        previewViewController.configure(viweModel)
        
        DispatchQueue.main.async {
            self.dismiss(animated: true) {
                presentingViewController?.present(previewViewController, animated: true, completion: nil)
            }
        }
    }
    
    private var configuration: ARConfiguration {
        let configuration = ARWorldTrackingConfiguration()
        guard let detectionObjects = viewModel?.detectionObjects else { fatalError() }
        configuration.detectionObjects = detectionObjects
        
        return configuration
    }
}

// MARK: - ARSCNViewDelegatea

extension CameraViewController: ARSCNViewDelegate {
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        
        guard let objectAnchor = anchor as? ARObjectAnchor else { return }
        
        let works = DataStore.shared.works
        if let detectingWorkIndex =  works.firstIndex(where: { $0.resource == objectAnchor.name }) {
            self.detectingWork = works[detectingWorkIndex]
        }
        
        // TODO: Show AR object
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
