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
    
    init(groupId name: String, text: String, width: CGFloat, textColor: UIColor, panelColor: UIColor, textThickness: CGFloat, panelThickness: CGFloat, originalPosition: SCNVector3 = .init(),
         image: UIimage, pos: SCNVector3) {
        // Configure current class
        self.originalPosition = originalPosition
        
        // Confugure SuperClass
        super.init()
        
        // Configure text node
        
        //
        // text.name
        //
        var str = SCNText(string: text.name, extrusionDepth: textThickness)
        str.font = UIFont(name: "NotoSansCJKjp-Regular", size: 1);
        let nameNode = SCNNode(geometry: str)
        
        var (min, max) = nameNode.boundingBox
        var w = CGFloat(max.x - min.x)
        var h = CGFloat(max.y - min.y)
        var ratio = 1.0 / CGFloat(max.x - min.x)
        nameNode.scale = SCNVector3(ratio/5, ratio/5, ratio/5)
        nameNode.position = SCNVector3(pos.x - Double(w*ratio/10), pos.y + 0.2, pos.z)
        
        // Set color or material
        nameNode.geometry?.materials.append(SCNMaterial())
        nameNode.geometry?.materials.first?.diffuse.contents = textColor

        //
        // text.belonging
        //
        str = SCNText(string: text.belonging, extrusionDepth: textThickness)
        str.font = UIFont(name: "NotoSansCJKjp-Regular", size: 1);
        let belongingNode = SCNNode(geometry: str)
        
        (min, max) = belongingNode.boundingBox
        w = CGFloat(max.x - min.x)
        h = CGFloat(max.y - min.y)
        belongingNode.position = SCNVector3(-(w/2), -(h/2) - 0.5 , 0.001 + textThickness)
        
        //
        // text.greeting
        //
        str = SCNText(string: text.name, extrusionDepth: textThickness)
        str.font = UIFont(name: "NotoSansCJKjp-Regular", size: 1);
        greetingNode = SCNNode(geometry: str)
        
        (min, max) = greetingNode.boundingBox
        w = CGFloat(max.x - min.x)
        h = CGFloat(max.y - min.y)
        greetingNode.position = SCNVector3(-(w/2), -(h/2) - 0.2, 0.001 + textThickness)
        
        // Configure panel node
        let panelNode = SCNNode(geometry: SCNBox(width: w * 1.1, height: h * 1.1, length: panelThickness, chamferRadius: 0))
        
        // Set color or material
        panelNode.geometry?.materials.append(SCNMaterial())
        panelNode.geometry?.materials.first?.diffuse.contents = panelColor
        
        let planeNode = SCNNode(geometry: SCNPlane(width: 0.1, height: 0.1))
        
        // Set color or material
        planeNode.geometry?.materials.append(SCNMaterial())
        planeNode.geometry?.materials.first?.diffuse.contents = image
        
        // Set name as group ID for detecting touches
        nameNode.name = name
        belongingNode.name = name
        greetingNode.name = name
        panelNode.name = name
        planeNode.name = name
        super.name = name
        
        // Add children nodes
        super.addChildNode(nameNode)
        super.addChildNode(belongingNode)
        super.addChildNode(greetingNode)
        super.addChildNode(panelNode)
        super.addChildNode(planeNode)

        // Configure entire transform
        super.position = originalPosition
        ratio = width / w
        super.scale = SCNVector3(ratio, ratio, ratio)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
