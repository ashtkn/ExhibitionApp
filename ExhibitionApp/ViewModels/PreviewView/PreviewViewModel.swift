import UIKit

struct PreviewViewModel {
    let snapshotImage: UIImage
    let detectingWork: Work?
    let stashedCameraViewModel: CameraViewModel
    
    init(snapshot image: UIImage, detecting work: Work?, stash cameraViewModel: CameraViewModel) {
        self.snapshotImage = image
        self.detectingWork = work
        
        var stashedCameraViewModel = cameraViewModel
        stashedCameraViewModel.detectingWork = nil // Clear detecting work
        self.stashedCameraViewModel = stashedCameraViewModel
    }
}
