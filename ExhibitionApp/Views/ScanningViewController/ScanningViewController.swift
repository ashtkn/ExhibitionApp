import UIKit
import SceneKit
import SnapKit
import ARKit

final class ScanningViewController: UIViewController {
    
    // MARK: Outlets
    
    @IBOutlet private weak var sceneView: ARSCNView!
    @IBOutlet private weak var takeSnapshotButton: UIButton!
    
    @IBOutlet private weak var cancelButton: UIButton! {
        didSet {
            self.cancelButton.setImage(AssetsManager.default.getImage(icon: .close), for: .normal)
        }
    }
    
    // MARK: ViewModel
    
    private var viewModel = ScanningViewModel()
    private var sceneRecorder: SceneRecorder?
    
    private var addedNodes: [String: SCNNode] = [:]
    
    // MARK: Lifecycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView.delegate = self
        sceneRecorder = SceneRecorder(sceneView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: false)
        sceneView.session.run(configuration)
        
        sceneRecorder?.requestMicrophonePermission()
        sceneRecorder?.prepare(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        sceneView.session.pause()
        sceneRecorder?.rest()
    }
    
    private var configuration: ARConfiguration {
        let configuration = ARWorldTrackingConfiguration()
        configuration.detectionObjects = viewModel.detectionObjects
        configuration.detectionImages = viewModel.detectionImages
        configuration.maximumNumberOfTrackedImages = 1
        
        return configuration
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        guard let location = touches.first?.location(in: sceneView) else { return }
        guard let hitTestResult = sceneView.hitTest(location, options: nil).first else { return }
        
        // TODO: process when user touches a node
        print("Hit node: \(hitTestResult.node)")
        print("Parent: \(String(describing: hitTestResult.node.parent))")
        print("Children: \(hitTestResult.node.childNodes)")
        
        guard let groupId = hitTestResult.node.name else { return }
        
        if addedNodes.keys.contains(groupId) {
            let node = addedNodes[groupId]
            switch node {
            case let labelNode as LabelNode:
                
                if labelNode.hasMoved {
                    labelNode.moveToOriginalPosition()
                } else {
                    let newPosition = SCNVector3(0.1, 0.0, 0.0)
                    labelNode.move(to: newPosition)
                }
                
            case .none:
                fatalError()
            default:
                fatalError()
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
    }
    
    // MARK: Actions
    
    @IBAction private func didTakeSnapshotButtonTapped(_ sender: UITapGestureRecognizer) {
        guard let sceneRecorder = sceneRecorder else { fatalError() }
        let photo = sceneRecorder.takePhoto()
        let sharingViewModel = SharingViewModel(media: .image(photo), detecting: viewModel.detectingWork, stash: viewModel)
        
        DispatchQueue.main.async { [unowned self] in
            let sharingViewController = SharingViewController.init()
            sharingViewController.configure(sharingViewModel)
            self.navigationController?.show(sharingViewController, sender: nil)
        }
    }
    
    @IBAction private func didTakeSnapshotButtonLongPressed(_ sender: UILongPressGestureRecognizer) {
        switch(sender.state) {
        case .began:
            startRecording()
        case .ended:
            stopRecording()
        case .possible, .changed, .cancelled, .failed:
            break
        @unknown default:
            fatalError()
        }
    }
    
    private func startRecording() {
        sceneRecorder?.startRecording()
    }
    
    private func stopRecording() {
        sceneRecorder?.stopRecording { [viewModel] url in
            let sharingViewModel = SharingViewModel(media: .video(url), detecting: viewModel.detectingWork, stash: viewModel)
            
            DispatchQueue.main.async { [unowned self] in
                let sharingViewController = SharingViewController.init()
                sharingViewController.configure(sharingViewModel)
                self.navigationController?.show(sharingViewController, sender: nil)
            }
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
        // タッチイベントの区別の粒度によってグループIDをセットすること
        let groupId = "groups_of_label_node"
        let labelNode = LabelNode(groupId: groupId, text: work.title, width: 0.2, textColor: .blue, panelColor: .white, textThickness: 0.1, panelThickness: 0.2)
        
        // TODO: Save reference to the added nodes if necessary
        addedNodes[groupId] = labelNode
        
        // Add the node to root node.
        node.addChildNode(labelNode)
    }
}
