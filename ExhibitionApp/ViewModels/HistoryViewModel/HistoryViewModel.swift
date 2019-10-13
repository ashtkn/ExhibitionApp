import UIKit

struct HistoryViewModel {
    let unlockedWorksNumber: Int = DataStore.shared.works.filter { !$0.isLocked }.count
}
