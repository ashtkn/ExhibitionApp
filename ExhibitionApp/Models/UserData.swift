import Foundation

struct UserData: Codable, Equatable, Hashable {
    let id: Int
    let isFirstLaunch: Bool
    let isLoadingFiles: Bool
    
    static func ==(lhs: UserData, rhs: UserData) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
