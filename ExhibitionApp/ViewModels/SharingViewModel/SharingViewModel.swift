import UIKit

struct SharingViewModel {
    
    enum Media {
        case image(UIImage)
        case video(URL)
    }
    
    let media: Media
    let detectingWork: Work?
    let stashedScanningViewModel: ScanningViewModel
    
    init(media inputMedia: Media, detecting work: Work?, stash scanningViewModel: ScanningViewModel) {
        self.media = inputMedia
        self.detectingWork = work
        
        var stashedScanningViewModel = scanningViewModel
        stashedScanningViewModel.setDetectingWork(nil) // Clear detecting work
        self.stashedScanningViewModel = stashedScanningViewModel
    }
    
}
