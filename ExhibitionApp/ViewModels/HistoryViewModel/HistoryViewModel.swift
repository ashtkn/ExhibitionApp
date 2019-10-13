import UIKit

struct HistoryViewModel {
    
    var dataStoreSubscriptionToken: SubscriptionToken?
    
    var unlockedWorksNumber: Int {
       return DataStore.shared.works.filter { !$0.isLocked }.count
    }
    
    var headerTitleText: String {
        return "履歴"
    }
    
    var workAcheivementLabelText: String {
        return "スキャンした作品数"
    }
}
