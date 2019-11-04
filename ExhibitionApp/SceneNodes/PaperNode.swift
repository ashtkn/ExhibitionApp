import ARKit

final class PaperNode: SCNNode {
    
    private let originalPosition: SCNVector3
    private var hasMoved: Bool = false
    
    init(position: SCNVector3, rotation: SCNVector4, scale: SCNVector3, texture: UIImage) {
        // Store properties
        self.originalPosition = position
        
        // Initialize node
        super.init()
        
        // TODO: Load paper resource here
        let paperScene = SCNScene(named: "art.scnassets/ship.scn")!
        
        // Set texture
        paperScene.rootNode.geometry?.materials.append(SCNMaterial())
        paperScene.rootNode.geometry?.materials.first?.diffuse.contents = texture
        
        let paperNode = SCNNode()
        paperNode.addChildNode(paperScene.rootNode)
        
        super.addChildNode(paperNode)
        
        // Configure the transform of the node
        super.position = position
        super.rotation = rotation
        super.scale = scale
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
