import UIKit

struct LoadingViewModel {
    var errorAlert: (title: String, message: String) {
        return ("エラー", "データのダウンロードに失敗しました")
    }
}
