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
                viewModel.vote(for: handNode.handType)
                handNode.rotateOnetimes()
                
                let markNodeGroupId = "markNode"
                let markNodePosition = SCNVector3(0, 0.2, 0)
                let markNode: TextLabelNode
                switch(handNode.handType){
                case 0:
                    markNode = TextLabelNode(groupId: markNodeGroupId, text: "♡", textColor: .init(red: 240/255, green: 102/255, blue: 102/255, alpha: 1), width: 0.03, depth: 50.0, origin: markNodePosition)
                case 1:
                    markNode = TextLabelNode(groupId: markNodeGroupId, text: "★", textColor: .init(red: 255/255, green: 185/255, blue: 21/255, alpha: 1), width: 0.03, depth: 50.0, origin: markNodePosition)
                case 2:
                    markNode = TextLabelNode(groupId: markNodeGroupId, text: "♪", textColor: .init(red: 0, green: 138/255, blue: 93/255, alpha: 1), width: 0.03, depth: 50.0, origin: markNodePosition)
                default:
                    markNode = TextLabelNode(groupId: markNodeGroupId, text: "◆", textColor: .init(red: 0, green: 130/255, blue: 180/255, alpha: 1), width: 0.03, depth: 50.0, origin: markNodePosition)
                }
                markNode.eulerAngles.x = .random(in: 0..<360)
                markNode.eulerAngles.y = .random(in: 0..<360)
                markNode.eulerAngles.z = .random(in: 0..<360)
                
                let scale1 = SCNAction.scale(by: 1.2, duration: 0.2)
                let scale2 = SCNAction.scale(to: 1.0, duration: 0.1)
                scale2.timingMode = .easeOut
                //let sleep = SCNAction.wait(duration: 0.2)

                let rotateAnimation = SCNAction.rotateBy(x: 0, y: 10 * .pi, z: 0, duration: 5.0)
                rotateAnimation.timingMode = .easeInEaseOut
                rotateAnimation.timingMode = .easeIn

                let fadeOutAnimation =  SCNAction.fadeOut(duration: 8.0)

                let moveAnimation = SCNAction.moveBy(x: 0, y: 2, z: 0, duration: 5.0)
                moveAnimation.timingMode = .easeIn
                let group = SCNAction.group([rotateAnimation, fadeOutAnimation, moveAnimation])

                //アニメーションが終わったらノードを削除
                markNode.runAction(SCNAction.sequence([scale1, scale2, group]), completionHandler: {() -> Void in
                    markNode.removeFromParentNode()
                })

                addedNodes[markNodeGroupId] =  markNode
                handNode.addChildNode(markNode)

            case .none:
                fatalError()
                
            default:
                break
                //let point = SCNVector3.init(hitTestResult.worldCoordinates.x, hitTestResult.worldCoordinates.y, hitTestResult.worldCoordinates.z)
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
        // light settings
        // 若干描画が重くなるので必要なさそうなら切って！
        // Create a ambient light
        let ambientLight = SCNNode()
        ambientLight.light = SCNLight()
        ambientLight.light?.shadowMode = .deferred
        ambientLight.light?.color = UIColor.white
        ambientLight.light?.type = SCNLight.LightType.ambient
        ambientLight.position = SCNVector3(x: 0,y: 5,z: 0)
        // Create a directional light node with shadow
        let myNode = SCNNode()
        myNode.light = SCNLight()
        myNode.light?.type = SCNLight.LightType.directional
        myNode.light?.color = UIColor.white
        myNode.light?.castsShadow = true
        myNode.light?.automaticallyAdjustsShadowProjection = true
        myNode.light?.shadowSampleCount = 64
        myNode.light?.shadowRadius = 16
        myNode.light?.shadowMode = .deferred
        myNode.light?.shadowMapSize = CGSize(width: 2048, height: 2048)
        myNode.light?.shadowColor = UIColor.black.withAlphaComponent(0.75)
        myNode.position = SCNVector3(x: 0,y: 5,z: 0)
        myNode.eulerAngles = SCNVector3(-Float.pi / 2, 0, 0)
        // Add the lights to the container
        node.addChildNode(ambientLight)
        node.addChildNode(myNode)
        // End
        
        // Set ConceptNodes
        let conceptNodeGroupId = "conceptLabelNode"
        let conceptNodePosition = SCNVector3(-0.5, 1.6, -3)
        
        let conceptNode = TextLabelNode(groupId: conceptNodeGroupId, text: "ああ言えばこう言う", textColor: .init(red: 0, green: 130/255, blue: 180/255, alpha: 1), width: 5.0, depth: 50.0, origin: conceptNodePosition)
        let moveAnimation = SCNAction.moveBy(x: 2, y: -1, z: 0, duration: 5.0)
        moveAnimation.timingMode = .easeIn
        let animation = SCNAction.repeatForever(SCNAction.sequence([moveAnimation, moveAnimation
            .reversed()]))
        conceptNode.runAction(animation)

        addedNodes[conceptNodeGroupId] = conceptNode
        node.addChildNode(conceptNode)
        
        let conceptNode2GroupId = "concept2LabelNode"
        let conceptNode2Position = SCNVector3(0.5, 1.6, -3)
        let conceptNode2 = TextLabelNode(groupId: conceptNode2GroupId, text: "こう言えばどう言う", textColor: .init(red: 0, green: 130/255, blue: 180/255, alpha: 1), width: 5.0, depth: 50.0, origin: conceptNode2Position)
        let moveAnimation2 = SCNAction.moveBy(x: -2, y: 1, z: 0, duration: 5.0)
        moveAnimation2.timingMode = .easeIn
        let animation2 = SCNAction.repeatForever(SCNAction.sequence([moveAnimation2, moveAnimation2.reversed()]))
        conceptNode2.runAction(animation2)
        addedNodes[conceptNodeGroupId] = conceptNode2
        node.addChildNode(conceptNode2)
        
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
//        for (index, imageName) in work.images.enumerated() {
//            let keywordNodeGroupId = "KeywordNode_\(index)"
//            guard let image = DataStore.shared.getImage(name: imageName) else { continue }
//            let paperType = (index + 1) % 5
//            let keywordNode = KeywordsNode(groupId: keywordNodeGroupId, keyword: image, paperType: paperType)
//            let eulerAngles = SCNVector3(.random(in: 0..<360), .random(in: 0..<360), .random(in: 0..<360))
//            keywordNode.eulerAngles = eulerAngles
//
//            addedNodes[keywordNodeGroupId] = keywordNode
//            node.addChildNode(keywordNode)
//        }
        
    }
}
