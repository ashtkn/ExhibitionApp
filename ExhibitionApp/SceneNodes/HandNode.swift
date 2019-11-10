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
    
    func rotateOnetimes() {
        let action = SCNAction.rotateBy(x: 0, y: 2 * .pi, z: 0, duration: 1)
        action.timingMode = .easeInEaseOut
        super.runAction(action)
    }
    
    init(gropuId id: String, handType type: Int, origin originalPosition: SCNVector3 = .init()) {
        // Configure current class
        self.originalPosition = originalPosition
        
        // Confugure SuperClass
        super.init()
        
        // Configure text node
        let handScene: SCNScene
        switch type {
        case 0:
            handScene = SCNScene(named: "art.scnassets/hand/hand-palm.dae")!
        case 1:
            handScene = SCNScene(named: "art.scnassets/hand/hand-fist.dae")!
        case 2:
            handScene = SCNScene(named: "art.scnassets/hand/hand-pointer.dae")!
        default:
            handScene = SCNScene(named: "art.scnassets/hand/hand-palm.dae")!
        }
        let handNode = handScene.rootNode
        
        handNode.name = id
        renameChildNodes(name: id, children: handNode.childNodes)
        
        handNode.scale = SCNVector3(0.03, 0.03, 0.03)
        
        //出現時に回転と拡大のアニメーション
        // 小さくしとく
        handNode.scale = SCNVector3(0.01, 0.01, 0.01)
        let scaleAction = SCNAction.scale(to: 0.03, duration: 0.4)
        let rotateAction = SCNAction.rotateBy(x: 0, y: 2 * .pi, z: 0, duration: 0.4)
        let action = SCNAction.group([scaleAction, rotateAction])
        handNode.runAction(action)
        
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
