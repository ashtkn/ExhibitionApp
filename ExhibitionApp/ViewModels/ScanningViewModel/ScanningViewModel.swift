import UIKit
import ARKit

struct ScanningViewModel {
    let detectionObjects: Set<ARReferenceObject>
    let detectionImages: Set<ARReferenceImage>
    private(set) var detectingWork: Work?
    private let votingQueue = DispatchQueue(label: "VotingThread")
    
    init() {
        self.detectionObjects = DataStore.shared.getARObjectsSet()
        self.detectionImages = DataStore.shared.getARImagesSet()
        self.detectingWork = nil
    }
    
    var allWorks: [Work] {
        return DataStore.shared.allWorks
    }
    
    mutating func setDetectingWork(_ detectingWork: Work?) {
        if let detectingWork = detectingWork {
            if detectingWork.isLocked {
                DataStore.shared.unlock(work: detectingWork)
            }
        }
        self.detectingWork = detectingWork
    }
    
    func vote(for handType: Int) {
        votingQueue.async {
            FirebaseService.shared.vote(for: handType).then({
                print("Voting for \(handType) finished")
            }).catch({ error in
                print(error)
            })
        }
    }
}
