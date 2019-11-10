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
    
    @IBOutlet private weak var instructionLabel: UILabel! {
        didSet {
            self.instructionLabel.numberOfLines = 0
            self.instructionLabel.text = "作品や作品の画像をスキャンしてください．長押しで動画を撮影できます．"
            self.instructionLabel.sizeToFit()
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
        guard let groupId = hitTestResult.node.name else { return }
        
        if addedNodes.keys.contains(groupId) {
            let node = addedNodes[groupId]
            switch node {
            case let textLabelNode as TextLabelNode:
                textLabelNode.doAnimation()
                if textLabelNode.hasMoved {
                    textLabelNode.moveToOriginalPosition()
                } else {
                    let newPosition = SCNVector3(0.0, 0.1, 0.0)
                    textLabelNode.move(to: newPosition)
                }
                
            // handNodeをタップしたら回転のアニメーション
            case let handNode as HandNode:
                handNode.rotateOnetimes()
                
            case .none:
                fatalError()
                
            default:
                let point = SCNVector3.init(hitTestResult.worldCoordinates.x,
                hitTestResult.worldCoordinates.y,
                hitTestResult.worldCoordinates.z)
                
                let heartNodeGroupId = "HeartNode"
            
                let heart = SCNText(string: "♡", extrusionDepth: 3)
                heart.chamferRadius = 2.0
                heart.font = UIFont(name: "rounded-mplus-1c-medium", size: 100)
                let heartNode = SCNNode(geometry: heart)

                heartNode.position = point
                
                heartNode.geometry?.materials.append(SCNMaterial())
                heartNode.geometry?.materials.first?.diffuse.contents = UIColor.init(red: 240/255, green: 102/255, blue: 102/255, alpha: 1)
                
                heartNode.scale = SCNVector3(0.05, 0.05, 0.05)
                let scale1 = SCNAction.scale(to: 0.13, duration: 0.2)
                let scale2 = SCNAction.scale(to: 0.1, duration: 0.1)
                scale2.timingMode = .easeOut
                let sleep = SCNAction.wait(duration: 0.1)
                
                let rotateAnimation = SCNAction.rotateBy(x: 0, y: 10 * .pi, z: 0, duration: 5.0)
                rotateAnimation.timingMode = .easeInEaseOut
                rotateAnimation.timingMode = .easeIn
                
                let fadeOutAnimation =  SCNAction.fadeOut(duration: 5.0)
                
                let moveAnimation = SCNAction.moveBy(x: 0, y: 10, z: 0, duration: 5.0)
                moveAnimation.timingMode = .easeIn
                let group = SCNAction.group([rotateAnimation, fadeOutAnimation, moveAnimation])
                
                heartNode.runAction(SCNAction.sequence([scale1, scale2, sleep, group]))
                
                addedNodes[heartNodeGroupId] = heartNode
                sceneView.scene.rootNode.addChildNode(heartNode)
                //TODO: animationが終わったらnodeを削除
                
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
        let allWorks = viewModel.allWorks
        if let detectingWorkIndex = allWorks.firstIndex(where: { $0.has(resource: name) }) {
            let detectingWork = allWorks[detectingWorkIndex]
            viewModel.setDetectingWork(detectingWork)
            DispatchQueue.main.async { [weak self] in
                self?.instructionLabel.isHidden = true
                self?.addNode(to: node, for: anchor, work: detectingWork)
            }
        }
    }
    
    func session(_ session: ARSession, didFailWithError error: Error) {}
    func sessionWasInterrupted(_ session: ARSession) {}
    func sessionInterruptionEnded(_ session: ARSession) {}
}

extension ScanningViewController {
    
    private func addNode(to node: SCNNode, for anchor: ARAnchor, work: Work) {
        
        // Set TitleNodes
        let textLabelNodeGroupId = "TitleTextLabelNode"
        let textLabelNodePosition = SCNVector3(0, 0, 0)
        let textLabelNode = TextLabelNode(groupId: textLabelNodeGroupId, text: work.title, textColor: .init(red: 0, green: 130/255, blue: 180/255, alpha: 1), width: 0.2, depth: 50.0, origin: textLabelNodePosition)
        addedNodes[textLabelNodeGroupId] = textLabelNode
        node.addChildNode(textLabelNode)
        
        // Set HandNodes
        for index in 0..<3 {
            let handNodeGroupId = "HandNode_\(index)"
            let posX = 0.2 * Double(index - 1)
            let posY = -0.4
            let posZ = -0.5

            let handNodePosition = SCNVector3(posX, posY, posZ)
            let handType = (index + 1) % 3
            let handNode = HandNode(gropuId: handNodeGroupId, handType: handType, origin: handNodePosition)
            addedNodes[handNodeGroupId] = handNode
            node.addChildNode(handNode)
        }
        
        // Set ArtistsNode
        for (index, author) in work.authors.enumerated() {
            let posX = 0.12 * (-1 * Double(work.authors.count) / 2 + Double(index))
            let posY = -0.15
            let posZ = -0.3

            let artistInfoNodePosition = SCNVector3(posX, posY, posZ)
            let artistInfoNodeGroupId = "ArtistInfoNode_\(index)"
            let artistInfoNode = ArtistInfoNode(groupId: artistInfoNodeGroupId, author: author, origin: artistInfoNodePosition)
            addedNodes[artistInfoNodeGroupId] = artistInfoNode
            node.addChildNode(artistInfoNode)
        }
        
        // Set KeywordNodes
        for (index, imageName) in work.images.enumerated() {
            let keywordNodeGroupId = "KeywordNode_\(index)"
            guard let image = DataStore.shared.getImage(name: imageName) else { continue }
            let paperType = (index + 1) % 5
            let keywordNode = KeywordsNode(groupId: keywordNodeGroupId, keyword: image, paperType: paperType)
            let eulerAngles = SCNVector3(.random(in: 0..<360), .random(in: 0..<360), .random(in: 0..<360))
            keywordNode.eulerAngles = eulerAngles

            addedNodes[keywordNodeGroupId] = keywordNode
            node.addChildNode(keywordNode)
        }
        
    }
}
