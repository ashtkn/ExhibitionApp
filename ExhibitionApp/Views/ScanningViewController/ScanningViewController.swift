import UIKit
import SceneKit
import SnapKit
import ARKit

final class ScanningViewController: UIViewController {
    
    // MARK: Outlets
    
    @IBOutlet private weak var sceneView: ARSCNView! {
        didSet {
            self.sceneView.delegate = self
        }
    }
    
    @IBOutlet private weak var takeSnapshotButton: UIButton!
    
    @IBOutlet private weak var cancelButton: UIButton! {
        didSet {
            self.cancelButton.setImage(AssetsManager.default.getImage(icon: .close), for: .normal)
        }
    }
    
    // MARK: ViewModel
    
    private var viewModel = ScanningViewModel()
    
    // MARK: Lifecycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }
    
    private var configuration: ARConfiguration {
        let configuration = ARWorldTrackingConfiguration()
        configuration.detectionObjects = viewModel.detectionObjects
        configuration.detectionImages = viewModel.detectionImages
        configuration.maximumNumberOfTrackedImages = 1
        
        return configuration
    }
    
    // MARK: Actions
    
    @IBAction private func didTakeSnapshotButtonTapped(_ sender: UITapGestureRecognizer) {
        let snapshotImage = sceneView.snapshot()
        let sharingViewModel = SharingViewModel(snapshot: snapshotImage, detecting: viewModel.detectingWork, stash: viewModel)
        
        let sharingViewController = SharingViewController.init()
        sharingViewController.configure(sharingViewModel)
        
        DispatchQueue.main.async { [unowned self] in
            self.navigationController?.show(sharingViewController, sender: nil)
        }
    }
    
    @IBAction private func didTakeSnaoshotButtonLongPressed(_ sender: UILongPressGestureRecognizer) {
        switch(sender.state) {
        case .began:
            print("began")
        case .ended:
            print("ended")
        case .possible, .changed, .cancelled, .failed:
            break
        @unknown default:
            fatalError()
        }
    }
    
    @IBAction private func didCancelButtonTapped(_ sender: Any) {
        DispatchQueue.main.async { [unowned self] in
            self.navigationController?.dismiss(animated: true, completion: nil)
        }
    }
}

// MARK: - ARSCNViewDelegatea

extension ScanningViewController: ARSCNViewDelegate {
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        let name = anchor.name ?? ""
        let works = viewModel.works
        if let detectingWorkIndex = works.firstIndex(where: { $0.has(resource: name) }) {
            let detectingWork = works[detectingWorkIndex]
            viewModel.setDetectingWork(detectingWork)
            addNode(to: node, for: anchor, work: detectingWork)
        }
    }
    
    func session(_ session: ARSession, didFailWithError error: Error) {}
    func sessionWasInterrupted(_ session: ARSession) {}
    func sessionInterruptionEnded(_ session: ARSession) {}
}

extension ScanningViewController {
    private func addNode(to node: SCNNode, for anchor: ARAnchor, work: Work) {
        // TODO: objects in the world
        let labelNode = LabelNode(text: work.title, width: 0.2, textColor: .blue, panelColor: .white, textThickness: 0.1, panelThickness: 0.2)
        node.addChildNode(labelNode)
    }
}
