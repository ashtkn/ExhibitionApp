import SceneKit

final class TextLabelNode: SCNNode {
    
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
        
        // Configure text node
        let str = SCNText(string: text, extrusionDepth: 0.01)
        str.font = UIFont(name: "rounded-mplus-1c-medium.ttf", size: 1);
        let textNode = SCNNode(geometry: str)
        
        let (min, max) = textNode.boundingBox
        let w = CGFloat(max.x - min.x)
        let h = CGFloat(max.y - min.y)
        let ratio = width / CGFloat(max.x - min.x)
        textNode.scale = SCNVector3(ratio, ratio, ratio)
        
        // Set color or material
        textNode.geometry?.materials.append(SCNMaterial())
        textNode.geometry?.materials.first?.diffuse.contents = textColor
        
        // Set name as group ID for detecting touches
        textNode.name = name
        super.name = name
        
        // Add children nodes
        super.addChildNode(textNode)
        
        // Configure entire transform
        super.position = (originalPosition.x - Double(w*ratio/2), originalPosition.y, originalPosition.z)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
