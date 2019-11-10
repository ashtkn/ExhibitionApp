import SceneKit

final class TextLabelNode: SCNNode {
    
    let originalPosition: SCNVector3
    let textColor: UIColor
    private(set) var hasMoved: Bool = false
    
    func move(to position: SCNVector3) {
        self.hasMoved = true
        super.position = position
    }
    
    func moveToOriginalPosition() {
        self.hasMoved = false
        super.position = originalPosition
    }
    
    func doAnimation() {
        let changeColor = SCNAction.customAction(duration: 10) { (node, elapsedTime) -> () in
            let percentage = elapsedTime / 5
            let color = UIColor(red: 1 - percentage, green: percentage, blue: 0, alpha: 1)
            super.geometry?.materials.first?.diffuse.contents = color
        }
        changeColor.timingMode = .easeInEaseOut
        
        let colorAnimation = SCNAction.sequence([ changeColor, changeColor.reversed() ])

        let rotateAnimation = SCNAction.rotateBy(x: 0, y: 2 * .pi, z: 0, duration: 1)
        rotateAnimation.timingMode = .easeInEaseOut
        
        let group = SCNAction.group([colorAnimation, rotateAnimation])
        super.runAction(group)
    }
    
    init(groupId name: String, text: String, textColor: UIColor, width: CGFloat, depth: CGFloat, origin originalPosition: SCNVector3 = .init()) {
        // Configure current class
        self.originalPosition = originalPosition
        self.textColor = textColor
        
        // Confugure SuperClass
        super.init()
        
        // Configure text node
        let str = SCNText(string: text, extrusionDepth: depth)
        str.chamferRadius = 2.0
        str.font = UIFont(name: "rounded-mplus-1c-medium", size: 100)
        
        // Set color or material
        let m1 = SCNMaterial()
        m1.diffuse.contents = textColor
        let m3 = SCNMaterial()
        m3.diffuse.contents = UIColor.white
        str.materials = [m1, m1, m1, m3, m3]
        
        let textNode = SCNNode(geometry: str)
        
        let (min, max) = textNode.boundingBox
        let w = CGFloat(max.x - min.x)
        let ratio = width / CGFloat(max.x - min.x)
        textNode.position = SCNVector3(-w * ratio / 2, 0, 0)
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
        super.position = SCNVector3(originalPosition.x, originalPosition.y, originalPosition.z)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
