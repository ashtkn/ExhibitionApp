import UIKit

struct SharingViewModel {
    let images: [UIImage]
    let detectingWork: Work?
    let stashedScanningViewModel: ScanningViewModel
    
    init(images: [UIImage], detecting work: Work?, stash scanningViewModel: ScanningViewModel) {
        self.images = images
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
