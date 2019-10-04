import UIKit
import ARKit

struct ScanningViewModel {
    let detectionObjects: Set<ARReferenceObject>
    let detectionImages: Set<ARReferenceImage>
    var detectingWork: Work?
    
    init() {
        self.detectionObjects = DataStore.shared.getARObjectsSet()
        self.detectionImages = DataStore.shared.getARImagesSet()
        self.detectingWork = nil
    }
}
