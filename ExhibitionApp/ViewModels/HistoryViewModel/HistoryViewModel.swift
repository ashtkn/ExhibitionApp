import UIKit

struct HistoryViewModel {
    
    private var dataStoreSubscriptionToken: SubscriptionToken?
    
    var sortedWorks: [Work] {
        return DataStore.shared.works.sorted { _, w1 in
            return w1.isLocked
        }
    }
    
    var headerTitleLabelText: String {
        return "履歴"
    }
    
    var scannedWorksCounterTextLabelText: String {
        return "スキャンした作品数"
    }
    
    var scannedWorksCounterNumberLabelText: String {
        let unlockedWorks = DataStore.shared.works.filter { !$0.isLocked }
        return "\(unlockedWorks.count)"
    }
    
    var scannedWorksCounterProgressViewValue: Float {
        let works = DataStore.shared.works
        let unlockedWorks = works.filter { !$0.isLocked }
        return Float(unlockedWorks.count) / Float(works.count)
    }
    
    mutating func setDataStoreSubscription(onUpdate handler: (() -> Void)?) {
        self.dataStoreSubscriptionToken = DataStore.shared.subscribe {
            handler?()
        }
    }
}
