import ARKit

final class ProfileNode: SCNNode {
    
    init(groupId: String, image: UIImage, position: SCNVector3, rotation: SCNVector4, scale: SCNVector3) {
        super.init()
        
        // TODO: Load person resource here
        let personScene = SCNScene(named: "art.scnassets/ship.scn")!
        
        // TODO: Configure labelNode here
        let labelNode = SCNNode()
        
        // TODO: Configure size of imageNode here
        let imageNode = ImageNode(image: image)
        
        // Set imageNode as a child of labelNode
        labelNode.addChildNode(imageNode)
        
        let profileNNode = SCNNode()
        profileNNode.addChildNode(personScene.rootNode)
        profileNNode.addChildNode(labelNode)
        
        super.addChildNode(profileNNode)
        
        // Configure the transform of the node
        super.position = position
        super.rotation = rotation
        super.scale = scale
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
