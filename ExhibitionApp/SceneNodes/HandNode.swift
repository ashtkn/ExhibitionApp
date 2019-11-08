import SceneKit

final class HandNode: SCNNode {
    
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
    
    init(gropuId name: String, width: CGFloat, originalPosition: SCNVector3 = .init(), handtype: Int) {
        // Configure current class
        self.originalPosition = originalPosition
        
        // Confugure SuperClass
        super.init()
        
        // Configure text node
        let handScene:SCNScene
        switch handtype {
        case 0:
            handScene = SCNScene(named: "art.scnassets/hand-palm.dae")!
        case 1:
            handScene = SCNScene(named: "art.scnassets/hand-fist.dae")!
        case 2:
            handScene = SCNScene(named: "art.scnassets/hand-pointer.dae")!
        default:
            handScene = SCNScene(named: "art.scnassets/hand-palm.dae")!
        }
        let handNode = handScene.rootNode
        
        handNode.name = name
        renameChildNodes(name: name, children: handNode.childNodes)
        
        handNode.scale = SCNVector3(0.03, 0.03, 0.03)
        
        // Add children nodes
        super.addChildNode(handNode)

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
