import Foundation
import SceneKit

final class ArtistInfoNode: SCNNode {
    
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
    
    init(groupId name: String, text: String, width: CGFloat, textColor: UIColor, panelColor: UIColor, textThickness: CGFloat, panelThickness: CGFloat, originalPosition: SCNVector3 = .init()) {
        // Configure current class
        self.originalPosition = originalPosition
        
        // Confugure SuperClass
        super.init()
        
        // Configure text node
        let str = SCNText(string: text, extrusionDepth: textThickness)
        str.font = UIFont(name: "HiraginoSans-W6", size: 1);
        let textNode = SCNNode(geometry: str)
        
        let (min, max) = textNode.boundingBox
        let w = CGFloat(max.x - min.x)
        let h = CGFloat(max.y - min.y)
        textNode.position = SCNVector3(-(w/2), -(h/2) - 0.9 , 0.001 + textThickness)
        
        // Set color or material
        textNode.geometry?.materials.append(SCNMaterial())
        textNode.geometry?.materials.first?.diffuse.contents = textColor
        
        // Configure panel node
        let panelNode = SCNNode(geometry: SCNBox(width: w * 1.1, height: h * 1.1, length: panelThickness, chamferRadius: 0))
        
        // Set color or material
        panelNode.geometry?.materials.append(SCNMaterial())
        panelNode.geometry?.materials.first?.diffuse.contents = panelColor
        
        // Set name as group ID for detecting touches
        textNode.name = name
        panelNode.name = name
        super.name = name
        
        // Add children nodes
        super.addChildNode(textNode)
        super.addChildNode(panelNode)

        // Configure entire transform
        super.position = originalPosition
        let ratio = width / w
        super.scale = SCNVector3(ratio, ratio, ratio)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
