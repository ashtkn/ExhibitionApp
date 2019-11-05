import SceneKit

extension SCNQuaternion {
    var eulerAngles: SCNVector3 {
        let node = SCNNode()
        node.localRotate(by: self)
        return node.eulerAngles
    }
    
    static func euler(_ eulerAngles: SCNVector3) -> SCNQuaternion {
        let node = SCNNode()
        node.eulerAngles = eulerAngles
        return SCNQuaternion(node.rotation.x, node.rotation.y, node.rotation.z, node.rotation.w)
    }
}
