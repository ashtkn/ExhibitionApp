import ARKit

final class ImageNode: SCNNode {
    
    init(image: UIImage) {
        super.init()
        
        // TODO: Configure geometry
        let plane = SCNPlane()
        //let plane = SCNPlane(width: <#T##CGFloat#>, height: <#T##CGFloat#>)
        
        plane.materials.append(SCNMaterial())
        plane.materials.first?.diffuse.contents = image
        
        let imageNode = SCNNode(geometry: plane)
        super.addChildNode(imageNode)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
