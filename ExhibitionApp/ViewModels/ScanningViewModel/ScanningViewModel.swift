import UIKit
import ARKit

struct ScanningViewModel {
    let detectionObjects: Set<ARReferenceObject>
    let detectionImages: Set<ARReferenceImage>
    var detectingWork: Work?
    
    init(objects detectionObjects: Set<ARReferenceObject>, images detectionImages: Set<ARReferenceImage>) {
        self.detectionObjects = detectionObjects
        self.detectionImages = detectionImages
        self.detectingWork = nil
    }
}
