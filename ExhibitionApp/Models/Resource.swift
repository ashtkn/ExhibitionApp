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
}
