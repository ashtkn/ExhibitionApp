import UIKit
import ARKit

struct CameraViewModel {
    let detectionObjects: Set<ARReferenceObject>
    var detectingWork: Work? = nil
}
