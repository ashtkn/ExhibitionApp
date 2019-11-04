import ARKit
import ARVideoKit

final class SceneRecorder {
    
    static var orientation: UIInterfaceOrientationMask {
        return ViewAR.orientation
    }
    
    private let recorder: RecordAR
    private let recordingQueue = DispatchQueue(label: "RecordingThread")
    
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
        recordingQueue.async { [unowned self] in
            self.recorder.record()
        }
    }
    
    func stopRecording(finished handler: ((URL) -> Void)?) {
        recordingQueue.async { [unowned self] in
            self.recorder.stop(handler)
        }
    }
}
