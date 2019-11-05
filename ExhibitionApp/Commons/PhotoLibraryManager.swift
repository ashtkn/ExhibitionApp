import UIKit

final class PhotoLibraryManager: NSObject {
    
    static let `default` = PhotoLibraryManager()
    private override init() {
        super.init()
    }
    
    private var handler: ((Bool) -> Void)?
    
    func save(image: UIImage, completion handler: ((_ success: Bool) -> Void)?) {
        self.handler = handler
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(didImageSavingFinished(image:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    func save(video path: String, completion handler: ((_ success: Bool) -> Void)?) {
        self.handler = handler
        UISaveVideoAtPathToSavedPhotosAlbum(path, self, #selector(didVideoSavingFinished(video:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    @objc private func didImageSavingFinished(image: UIImage, didFinishSavingWithError error: NSError!, contextInfo: UnsafeMutableRawPointer) {
        if let _ = error {
            handler?(false)
        } else {
            handler?(true)
        }
    }
    
    @objc private func didVideoSavingFinished(video videoPath: String, didFinishSavingWithError error: NSError!, contextInfo: UnsafeMutableRawPointer) {
        if let _ = error {
            handler?(false)
        } else {
            handler?(true)
        }
    }
}
