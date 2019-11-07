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
    
    init(groupId name: String, text: String, textColor: UIColor, width: CGFloat, originalPosition: SCNVector3 = .init()) {
        // Configure current class
        self.originalPosition = originalPosition
        
        // Confugure SuperClass
        super.init()
        
        // モデルを使う場合
        // Configure node
//        let paperScene = SCNScene(named: "art.scnassets/paper/paper-1.dae")!
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
