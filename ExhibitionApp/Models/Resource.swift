import Foundation

struct Resource: Codable, Equatable, Hashable {
    let type: String
    let filename: String
    let size: Float?
    
    var file: (base: String, ext: String) {
        let base = String(filename[filename.startIndex..<filename.lastIndex(of: ".")!])
        let ext = filename.components(separatedBy: ".").last!
        return (base, ext)
    }
    
    static func ==(lhs: Resource, rhs: Resource) -> Bool {
        return lhs.type == rhs.type && lhs.filename == rhs.filename
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(type)
        hasher.combine(filename)
    }
}
