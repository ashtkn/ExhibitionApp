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
    
    init(groupId name: String, text: String, textColor: UIColor, width: CGFloat, depth: CGFloat, originalPosition: SCNVector3 = .init()) {
        // Configure current class
        self.originalPosition = originalPosition
        
        // Confugure SuperClass
        super.init()
        
        // Configure text node
        let str = SCNText(string: text, extrusionDepth: depth)
        str.chamferRadius = 2.0
        str.font = UIFont(name: "rounded-mplus-1c-medium", size: 100)
        
        // Set color or material
        let m1 = SCNMaterial()
        m1.diffuse.contents = UIColor.init(red: 0, green: 130/255, blue: 180/255, alpha: 1)
        let m3 = SCNMaterial()
        m3.diffuse.contents = UIColor.white
        str.materials = [m1, m1, m1, m3, m3]
        
        let textNode = SCNNode(geometry: str)
        
        let (min, max) = textNode.boundingBox
        let w = CGFloat(max.x - min.x)
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
        super.position = SCNVector3(originalPosition.x - Float(w*ratio/2), originalPosition.y, originalPosition.z)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
