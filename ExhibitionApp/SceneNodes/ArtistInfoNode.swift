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
    
    init(groupId id: String, author: Author, origin originalPosition: SCNVector3 = .init()) {
        
        let width: CGFloat = 0.2
        let textColor: UIColor = .white
        let textThickness: CGFloat = 0.1
        // TODO: プロフィール写真を配置
        let image = DataStore.shared.getProfileImage(name: author.imageName)
        
        self.originalPosition = originalPosition
        
        // Confugure SuperClass
        super.init()
        
        addNameNode(groupId: id, name: author.name, textColor: textColor, extrusionDepth: textThickness, origin: originalPosition)
        addBelongingNode(groupId: id, belonging: author.belonging, extrusionDepth: textThickness, origin: originalPosition)
        addGreetingLabel(groupId: id, name: author.greeting, extrusionDepth: textThickness, origin: originalPosition)
        
        super.name = id
        super.position = originalPosition
        
        // TODO: スケールが正しいかすること
        let (min, max) = super.boundingBox
        let w = CGFloat(max.x - min.x)
        let ratio = width / w
        super.scale = SCNVector3(ratio, ratio, ratio)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ArtistInfoNode {
    
    private func addNameNode(groupId: String, name: String, textColor: UIColor, extrusionDepth textThickness: CGFloat, origin p: SCNVector3) {
        let str = SCNText(string: name, extrusionDepth: textThickness)
        str.font = UIFont(name: "NotoSansCJKjp-Regular", size: 1);
        let nameNode = SCNNode(geometry: str)
        
        let (min, max) = nameNode.boundingBox
        let w = CGFloat(max.x - min.x)
        let ratio = 1.0 / CGFloat(max.x - min.x)
        nameNode.scale = SCNVector3(ratio/5, ratio/5, ratio/5)
        nameNode.position = SCNVector3(p.x - Float(w*ratio/10), p.y + 0.2, p.z + 0.1)
        
        // Set color or material
        nameNode.geometry?.materials.append(SCNMaterial())
        nameNode.geometry?.materials.first?.diffuse.contents = textColor
        
        nameNode.name = groupId
        super.addChildNode(nameNode)
    }
    
    private func addBelongingNode(groupId: String, belonging: String, extrusionDepth textThickness: CGFloat, origin p: SCNVector3) {
        let str = SCNText(string: belonging, extrusionDepth: textThickness)
        str.font = UIFont(name: "NotoSansCJKjp-Regular", size: 100);
        let belongingNode = SCNNode(geometry: str)
        
        let (min, max) = belongingNode.boundingBox
        let w = CGFloat(max.x - min.x)
        let ratio = 1.0 / CGFloat(max.x - min.x)
        belongingNode.scale = SCNVector3(ratio/5, ratio/5, ratio/5)
        belongingNode.position = SCNVector3(p.x - Float(w*ratio/10), p.y + 0.18, p.z + 0.1)
        
        belongingNode.name = groupId
        super.addChildNode(belongingNode)
    }
    
    private func addGreetingLabel(groupId: String, name: String, extrusionDepth textThickness: CGFloat, origin p: SCNVector3) {
        let str = SCNText(string: name, extrusionDepth: textThickness)
        str.font = UIFont(name: "NotoSansCJKjp-Regular", size: 100);
        let greetingNode = SCNNode(geometry: str)
        
        let (min, max) = greetingNode.boundingBox
        let w = CGFloat(max.x - min.x)
        let ratio = 1.0 / CGFloat(max.x - min.x)
        greetingNode.scale = SCNVector3(ratio/5, ratio/5, ratio/5)
        greetingNode.position = SCNVector3(p.x - Float(w*ratio/10), p.y + 0.15, p.z + 0.1)
        
        greetingNode.name = groupId
        super.addChildNode(greetingNode)
    }
    
    private func addPlaneNode(groupId: String, image: UIImage, pos: SCNVector3) {
        let planeNode = SCNNode(geometry: SCNPlane(width: 0.1, height: 0.1))
        
        // Set color or material
        planeNode.geometry?.materials.append(SCNMaterial())
        planeNode.geometry?.materials.first?.diffuse.contents = image
        planeNode.position = SCNVector3(pos.x, pos.y + 0.35, pos.z + 0.1)
        
        planeNode.name = groupId
        super.addChildNode(planeNode)
    }
}

