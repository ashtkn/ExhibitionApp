import SceneKit

final class KeywordsNode: SCNNode {
    
    let originalPosition: SCNVector3
    private(set) var hasMoved: Bool = false
    
    func move(to position: SCNVector3) {
        self.hasMoved = true
        super.position = position
    }
    
    func moveToOriginalPosition() {
        self.hasMoved = false
        super.position = originalPosition
    }
    
    init(groupId id: String, keyword image: UIImage, paperType type: Int, origin originalPosition: SCNVector3 = .init()) {
        // Configure current class
        self.originalPosition = originalPosition
        
        // Confugure SuperClass
        super.init()
        
        // モデルを使う場合
        // Configure node
        let paperScene: SCNScene
        switch type {
        case 0:
            paperScene = SCNScene(named: "art.scnassets/paper/paper-1.dae")!
        case 1:
            paperScene = SCNScene(named: "art.scnassets/paper/paper-2.dae")!
        case 2:
            paperScene = SCNScene(named: "art.scnassets/paper/paper-5.dae")!
        case 3:
            paperScene = SCNScene(named: "art.scnassets/paper/paper-6.dae")!
        case 4:
            paperScene = SCNScene(named: "art.scnassets/paper/paper-8.dae")!
        default:
            paperScene = SCNScene(named: "art.scnassets/paper/paper-1.dae")!
        }
        let paperNode = paperScene.rootNode

        paperNode.name = id
        renameChildNodes(name: id, children: paperNode.childNodes)
        paperNode.scale = SCNVector3(0.0003, 0.0003, 0.0003)

        // TODO: これでいいの？
        for childNode in paperNode.childNodes {
             childNode.geometry?.materials.append(SCNMaterial())
             childNode.geometry?.materials.first?.diffuse.contents = image
        }
        
        // Add children nodes
        super.addChildNode(paperNode)

        // Configure entire transform
        super.position = originalPosition
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func renameChildNodes(name: String, children nodes: [SCNNode]) {
        if nodes.count == 0 { return }
        for node in nodes {
            node.name = name
            renameChildNodes(name: name, children: node.childNodes)
        }
    }
}
