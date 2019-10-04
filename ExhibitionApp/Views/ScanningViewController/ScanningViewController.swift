import UIKit
import SceneKit
import ARKit

class ScanningViewController: UIViewController {
    
    @IBOutlet weak var sceneView: ARSCNView! {
        didSet {
            self.sceneView.delegate = self
        }
    }
    
    @IBOutlet weak var takeSnapshotButton: UIButton!
    
    // MARK: ViewModel
    var scanningViewModel: ScanningViewModel?
    func configure(_ scanningViewModel: ScanningViewModel) {
        self.scanningViewModel = scanningViewModel
    }
    
    // MARK: Lifecycles
    
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
    
    private var configuration: ARConfiguration {
        let configuration = ARWorldTrackingConfiguration()
        guard let detectionObjects = scanningViewModel?.detectionObjects else { fatalError() }
        configuration.detectionObjects = detectionObjects
        guard let detectionImages = scanningViewModel?.detectionImages else { fatalError() }
        configuration.detectionImages = detectionImages
        
        print("Detection Objects: \(detectionObjects)")
        print("Detection Images: \(detectionImages)")
        
        return configuration
    }
    
    // MARK: Actions
    
    @IBAction func didTakeSnapshotButtonTapped(_ sender: Any) {
        let snapshotImage = sceneView.snapshot()
        guard let currentScanningViewModel = self.scanningViewModel else { fatalError() }
        let currentDetectingWork = currentScanningViewModel.detectingWork
        let sharingViewModel = SharingViewModel(snapshot: snapshotImage, detecting: currentDetectingWork, stash: currentScanningViewModel)
        
        let sharingViewController = SharingViewController.loadViewControllerFromStoryboard()
        sharingViewController.configure(sharingViewModel)
        
        let presentingViewController = self.presentingViewController
        DispatchQueue.main.async {
            self.dismiss(animated: true) {
                presentingViewController?.present(sharingViewController, animated: true, completion: nil)
            }
        }
    }
    
}

// MARK: - ARSCNViewDelegatea

extension ScanningViewController: ARSCNViewDelegate {
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        
        guard let objectAnchor = anchor as? ARObjectAnchor else { return }
        
        // TODO: ARResourceImage
        let expectedResourceName = "\(objectAnchor.name ?? "").arobject"
        
        let works = DataStore.shared.works
        if let detectingWorkIndex = works.firstIndex(where: { $0.resource == expectedResourceName }) {
            // Register the detecting work
            scanningViewModel?.detectingWork = works[detectingWorkIndex]
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
        case "Chino":
            let labelNode = LabelNode(text: "Chino", width: 0.2, textColor: .blue, panelColor: .white, textThickness: 0.1, panelThickness: 0.2)
            node.addChildNode(labelNode)
        default:
            fatalError("Unknown object has been detected.")
        }
    }
    
    func session(_ session: ARSession, didFailWithError error: Error) {}
    func sessionWasInterrupted(_ session: ARSession) {}
    func sessionInterruptionEnded(_ session: ARSession) {}
}
