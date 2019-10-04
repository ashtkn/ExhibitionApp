import Foundation

struct WorkCollectionViewModel {
    let works: [Work]
    
    init() {
        self.works = DataStore.shared.works
    }
}
