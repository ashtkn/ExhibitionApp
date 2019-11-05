import SceneKit

final class ImageLabelNode: SCNNode {
    
    let originalPosition: SCNVector3
    let originalRotation: SCNVector4
    private(set) var hasMoved: Bool = false
    
    func move(to position: SCNVector3) {
        self.hasMoved = true
        super.position = position
    }
    
    func moveToOriginalPosition() {
        self.hasMoved = false
        super.position = originalPosition
    }
    
    init(groupId name: String, image: UIImage, width: CGFloat, height: CGFloat, panelThickness: CGFloat) {
        // Configure current class
        let originalPostion = SCNVector3()
        self.originalPosition = originalPostion
        
        let originalRotation = SCNVector4()
        self.originalRotation = originalRotation
        
        // Confugure SuperClass
        super.init()
        
        let panelNode = SCNNode(geometry: SCNBox(width: width, height: height, length: panelThickness, chamferRadius: 0))
        
        // Set color or material
        panelNode.geometry?.materials.append(SCNMaterial())
        panelNode.geometry?.materials.first?.diffuse.contents = image
        
        // Set name as group ID for detecting touches
        panelNode.name = name
        super.name = name
        
        // Add children nodes
        super.addChildNode(panelNode)

        // Configure entire transform
        super.position = originalPosition
        super.rotation = originalRotation
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
