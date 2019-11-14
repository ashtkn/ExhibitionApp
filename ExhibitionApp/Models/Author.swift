import Foundation

struct Author: Codable, Equatable, Hashable {
    let name: String
    let imageName: String
    let belonging: String
    let greeting: String
    
    static func ==(lhs: Author, rhs: Author) -> Bool {
        return lhs.name == rhs.name
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
    }
}
