import Foundation
import Firebase
import CodableFirebase

enum EncodableExtensionError: Error {
    case encodingError
}

extension DocumentReference: DocumentReferenceType {}
extension GeoPoint: GeoPointType {}
extension FieldValue: FieldValueType {}
extension Timestamp: TimestampType {}

extension Encodable {
    func toFirestoreData(excluding excludedKeys: [String] = []) throws -> [String: Any] {
        let encoder = FirestoreEncoder()
        var docData = try! encoder.encode(self)
        for key in excludedKeys {
            docData.removeValue(forKey: key)
        }
        return docData
    }
}

enum DocumentSnapshotExtensionError:Error {
    case decodingError
}

extension DocumentSnapshot {
    private func transformItems(_ items: [Any]) -> [Any] {
        var result = [Any]()
        for item in items {
            if let ts = item as? Timestamp {
                let date = ts.dateValue()
                result.append(Int((date.timeIntervalSince1970 * 1000).rounded()))
            }
            result.append(item)
        }
        return result
    }
    
    private func transformValues(_ documentJson: [String: Any]) -> [String: Any] {
        var documentJson = documentJson
        documentJson.forEach { (key: String, value: Any) in
            switch value {
            case _ as DocumentReference:
                documentJson.removeValue(forKey: key)
                
            case let ts as Timestamp: //convert timestamp to date value
                let date = ts.dateValue()
                let jsonValue = Int((date.timeIntervalSince1970 * 1000).rounded())
                documentJson[key] = jsonValue
                
            case let map as [String: Any]:
                documentJson[key] = transformValues(map)
                
            case let list as [Any]:
                documentJson[key] = transformItems(list)
                
            default:
                break
            }
        }
        
        return documentJson
    }
    
    func decode<T: Decodable>(as objectType: T.Type) throws -> T {
        do {
            guard var documentJson = self.data() else {
                throw DocumentSnapshotExtensionError.decodingError
            }
            
            documentJson = transformValues(documentJson)
            let documentData = try JSONSerialization.data(withJSONObject: documentJson, options: [])
            
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .millisecondsSince1970
            
            let decodedObject = try decoder.decode(objectType, from: documentData)
            return decodedObject
            
        } catch {
            print("failed to decode", error)
            throw error
        }
    }
}
