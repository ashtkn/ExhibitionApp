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
    
    init(groupId name: String, image: UIImage, width: CGFloat, height: CGFloat, originalPosition: SCNVector3 = .init(), papertype: Int) {
        // Configure current class
        self.originalPosition = originalPosition
        
        // Confugure SuperClass
        super.init()
        
        // モデルを使う場合
        // Configure node
//        let paperScene:SCNScene
//        switch papertype {
//        case 0:
//            paperScene = SCNScene(named: "art.scnassets/paper/paper-1.dae")!
//        case 1:
//            paperScene = SCNScene(named: "art.scnassets/paper/paper-2.dae")!
//        case 2:
//            paperScene = SCNScene(named: "art.scnassets/paper/paper-3.dae")!
//        case 3:
//            paperScene = SCNScene(named: "art.scnassets/paper/paper-4.dae")!
//        case 4:
//            paperScene = SCNScene(named: "art.scnassets/paper/paper-5.dae")!
//        default:
//            paperScene = SCNScene(named: "art.scnassets/paper/paper-1.dae")!
//        }
//        let paperNode = paperScene.rootNode
//
//        paperNode.name = name
//        renameChildNodes(name: name, children: paperNode.childNodes)
//
//        for childNode in shipNode.childNodes {
//            // テクスチャを貼るなら再帰的に子ノードを探索し，テクスチャを貼る対象のノードにテクスチャをはる
//             childNode.geometry?.materials.append(SCNMaterial())
//             childNode.geometry?.materials.first?.diffuse.contents = image
//        }

        let planeNode = SCNNode(geometry: SCNPlane(width: width, height: height))
        
        // Set color or material
        planeNode.geometry?.materials.append(SCNMaterial())
        planeNode.geometry?.materials.first?.diffuse.contents = image
        
        // Set name as group ID for detecting touches
        planeNode.name = name
        super.name = name
        
        // Add children nodes
        super.addChildNode(planeNode)

        // Configure entire transform
        super.position = originalPosition
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
