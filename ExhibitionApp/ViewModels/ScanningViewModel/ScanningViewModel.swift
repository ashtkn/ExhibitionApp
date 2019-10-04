import UIKit
import ARKit

struct ScanningViewModel {
    let detectionObjects: Set<ARReferenceObject>
    let detectionImages: Set<ARReferenceImage>
    let works: [Work]
    var detectingWork: Work?
    
    init() {
        self.detectionObjects = DataStore.shared.getARObjectsSet()
        self.detectionImages = DataStore.shared.getARImagesSet()
        self.works = DataStore.shared.works
        self.detectingWork = nil
    }
}
