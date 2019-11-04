import ARKit
import ARVideoKit

final class SceneRecorder {
    
    static var orientation: UIInterfaceOrientationMask {
        return ViewAR.orientation
    }
    
    private let recorder: RecordAR
    
    init(_ sceneView: ARSCNView) {
        recorder = RecordAR(ARSceneKit: sceneView)!
    }
    
    func requestMicrophonePermission() {
        recorder.requestMicrophonePermission()
    }
    
    func prepare(_ configuration: ARConfiguration?) {
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
