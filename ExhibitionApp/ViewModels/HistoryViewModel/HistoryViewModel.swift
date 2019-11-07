import UIKit

struct HistoryViewModel {
    
    private var dataStoreSubscriptionToken: SubscriptionToken?
    
    var sortedWorks: [Work] {
        return DataStore.shared.allWorks.sorted { _, w1 in
            return w1.isLocked
        }
    }
    
    private var allWorks: [Work] {
        return DataStore.shared.allWorks
    }
    
    var unlockedWorks: [Work] {
        return DataStore.shared.unlockedWorks
    }
    
    var headerTitleLabelText: String {
        return "履歴"
    }
    
    var scannedWorksCounterTextLabelText: String {
        return "スキャンした作品数"
    }
    
    var scannedWorksCounterNumberLabelText: String {
        return "\(unlockedWorks.count)"
    }
    
    var scannedWorksCounterProgressViewValue: Float {
        return Float(unlockedWorks.count) / Float(allWorks.count)
    }
    
    mutating func setDataStoreSubscription(onUpdate handler: (() -> Void)?) {
        self.dataStoreSubscriptionToken = DataStore.shared.subscribe {
            handler?()
        }
    }
}
