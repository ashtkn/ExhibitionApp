import SceneKit

final class ShipNode: SCNNode {
    
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
    
    init(gropuId name: String, width: CGFloat, originalPosition: SCNVector3 = .init()) {
        // Configure current class
        let originalPostion = SCNVector3()
        self.originalPosition = originalPostion
        
        // Confugure SuperClass
        super.init()
        
        // Configure text node
        let shipScene = SCNScene(named: "art.scnassets/ship.scn")!
        let shipNode = shipScene.rootNode
        
        shipNode.name = name
        renameChildNodes(name: name, children: shipNode.childNodes)
        
//        for childNode in shipNode.childNodes {
//            // テクスチャを貼るなら再帰的に子ノードを探索し，テクスチャを貼る対象のノードにテクスチャをはる
//            // childNode.geometry?.materials.append(SCNMaterial())
//            // childNode.geometry?.materials.first?.diffuse.contents = image
//        }
        
        let (min, max) = shipNode.boundingBox
        let ratio = width / CGFloat(max.x - min.x)
        shipNode.scale = SCNVector3(ratio, ratio, ratio)
        
        // Add children nodes
        super.addChildNode(shipNode)

        // Configure entire transform
        super.position = originalPosition
    }
    
    private func renameChildNodes(name: String, children nodes: [SCNNode]) {
        if nodes.count == 0 { return }
        for node in nodes {
            node.name = name
            renameChildNodes(name: name, children: node.childNodes)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
