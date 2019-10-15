import UIKit

struct HistoryViewModel {
    
    var dataStoreSubscriptionToken: SubscriptionToken?
    
    var sortedWorks: [Work] {
        return DataStore.shared.works.sorted { _, w1 in
            return w1.isLocked
        }
    }
    
    var unlockedWorksCount: Int {
        return DataStore.shared.works.filter { !$0.isLocked }.count
    }
    
    var headerTitleText: String {
        return "履歴"
    }
    
    var workAcheivementLabelText: String {
        return "スキャンした作品数"
    }
}
