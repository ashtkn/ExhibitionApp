import ARKit
import ARVideoKit

final class SceneRecordingUtility {
    
    static var orientation: UIInterfaceOrientationMask {
        return ViewAR.orientation
    }
    
    private let recorder: RecordAR
    
    init(_ sceneView: ARSCNView) {
        recorder = RecordAR(ARSceneKit: sceneView)!
    }
    
    func prepare(configuration: ARConfiguration?) {
        recorder.prepare(configuration)
    }
    
    func rest() {
        recorder.rest()
    }
    
    func takePhoto() -> UIImage {
        return recorder.photo()
    }
    
    func startRecording() {
        recorder.record()
    }
    
    func pauseRecording() {
        recorder.pause()
    }
    
    func stopRecording(finished handler: ((URL) -> Void)?) {
        recorder.stop(handler)
    }
}
