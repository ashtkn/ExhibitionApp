import Foundation

struct UserData: Codable {
    let id: Int
    let isFirstLaunch: Bool
    let isLoadingFiles: Bool
}
