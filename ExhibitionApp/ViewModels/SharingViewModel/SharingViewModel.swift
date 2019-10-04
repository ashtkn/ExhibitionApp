import UIKit

struct SharingViewModel {
    let snapshotImage: UIImage
    let detectingWork: Work?
    let stashedScanningViewModel: ScanningViewModel
    
    init(snapshot image: UIImage, detecting work: Work?, stash scanningViewModel: ScanningViewModel) {
        self.snapshotImage = image
        self.detectingWork = work
        
        var stashedScanningViewModel = scanningViewModel
        stashedScanningViewModel.detectingWork = nil // Clear detecting work
        self.stashedScanningViewModel = stashedScanningViewModel
    }
}
