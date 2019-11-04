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
    
    var shareButtonTitle: String {
        return "シェア"
    }
    
    var imageSavingSuccessAlert: (title: String, message: String) {
        let title = "保存完了"
        let message = "画像をカメラロールに保存しました"
        return (title, message)
    }
    
    var imageSavingErrorAlert: (title: String, message: String) {
        let title = "エラー"
        let message = "画像の保存に失敗しました"
        return (title, message)
    }
}
