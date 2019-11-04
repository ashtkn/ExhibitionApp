import ARVideoKit

final class SceneRecordingUtility {
    
    static let shared = SceneRecordingUtility()
    private init() {}
    
    var orientation: UIInterfaceOrientationMask {
        return ViewAR.orientation
    }
    
}
