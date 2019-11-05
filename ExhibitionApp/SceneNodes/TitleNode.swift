import ARKit

final class TitleNode: SCNNode {
    
    init(groupId: String, text: String, position: SCNVector3, rotation: SCNVector4, scale: SCNVector3) {
        super.init()
        
        let titleNode = LabelNode(groupId: groupId, text: text, width: 0.2, textColor: .black, panelColor: .white, textThickness: 0.1, panelThickness: 0.2)
        
        super.addChildNode(titleNode)
        
        // Configure the transform of the node
        super.position = position
        super.rotation = rotation
        super.scale = scale
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
