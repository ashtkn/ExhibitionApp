import UIKit

extension UIImage {
    public convenience init(url: String) {
        let url = URL(string: url)
        do {
            let data = try Data(contentsOf: url!)
            self.init(data: data)!
            return
        } catch let err {
            print("Error : \(err.localizedDescription)")
        }
        self.init()
    }
}

extension UIImage {
    
    func resize(to newSize: CGSize) -> UIImage? {
        let widthRatio = newSize.width / self.size.width
        let heightRatio = newSize.height / self.size.height
        let ratio = widthRatio < heightRatio ? widthRatio : heightRatio
        
        let resizedSize = CGSize(width: self.size.width * ratio, height: self.size.height * ratio)
        
        UIGraphicsBeginImageContextWithOptions(resizedSize, false, 0.0)
        self.draw(in: CGRect(origin: .zero, size: resizedSize))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return resizedImage
    }
    
    func scale(to scaleSize: CGFloat) -> UIImage? {
        let newSize = CGSize(width: self.size.width * scaleSize, height: self.size.height * scaleSize)
        return resize(to: newSize)
    }
}

extension CGImagePropertyOrientation {
    init(_ uiOrientation: UIImage.Orientation) {
        switch uiOrientation {
        case .up:
            self = .up
        case .upMirrored:
            self = .upMirrored
        case .down:
            self = .down
        case .downMirrored:
            self = .downMirrored
        case .left:
            self = .left
        case .leftMirrored:
            self = .leftMirrored
        case .right:
            self = .right
        case .rightMirrored:
            self = .rightMirrored
        @unknown default:
            fatalError()
        }
    }
}

extension UIImage.Orientation {
    init(_ cgOrientation: UIImage.Orientation) {
        switch cgOrientation {
        case .up:
            self = .up
        case .upMirrored:
            self = .upMirrored
        case .down:
            self = .down
        case .downMirrored:
            self = .downMirrored
        case .left:
            self = .left
        case .leftMirrored:
            self = .leftMirrored
        case .right:
            self = .right
        case .rightMirrored:
            self = .rightMirrored
        @unknown default:
            fatalError()
        }
    }
}
