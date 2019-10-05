import XCTest
@testable import ExhibitionApp

class WorkTests: XCTestCase {
    
    let jsonData = """
    {
        "id": "XXXXXX",
        "title": "Syaro",
        "resource": "Syaro.arobject",
        "authors": [
            "Someone"
        ],
        "images": [
            "turtlerock.jpg",
            "turtlerock.jpg"
        ],
        "caption": "これはキャプションです．",
        "is_locked": false
    }
    """.data(using: .utf8)!
    
    let invalidJsonData = """
    {
        "id": "XXXXXX",
        "title": "Syaro"
    }
    """.data(using: .utf8)!

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testDecoding() {
        let decoder = JSONDecoder()
        
        XCTAssertNoThrow(try decoder.decode(Work.self, from: jsonData))
        let work = try! decoder.decode(Work.self, from: jsonData)
        
        XCTAssertEqual(work.id, "XXXXXX")
        XCTAssertEqual(work.title, "Syaro")
        XCTAssertEqual(work.resource, "Syaro.arobject")
        
        XCTAssertThrowsError(try decoder.decode(Work.self, from: invalidJsonData))
    }
    
    func testEncoding() {
        let decoder = JSONDecoder()
        
        XCTAssertNoThrow(try decoder.decode(Work.self, from: jsonData))
        let work = try! decoder.decode(Work.self, from: jsonData)
        
        let encoder = JSONEncoder()
        
        XCTAssertNoThrow(try encoder.encode(work))
        let data = try! encoder.encode(work)
        
        XCTAssertNoThrow(try decoder.decode(Work.self, from: data))
        let workToCompare = try! decoder.decode(Work.self, from: data)
        
        XCTAssertEqual(work.id, workToCompare.id)
        XCTAssertEqual(work.title, workToCompare.title)
        XCTAssertEqual(work.resource, workToCompare.resource)
    }
    
    func testEuatableProtocol() {
        let decoder = JSONDecoder()
        
        XCTAssertNoThrow(try decoder.decode(Work.self, from: jsonData))
        let work = try! decoder.decode(Work.self, from: jsonData)
        
        let id = "XXXXXX"
        let workToCompare = Work(id: id, title: "", resource: "", authors: [], images: [], caption: "", isLocked: false)
        XCTAssertEqual(work, workToCompare)
    }
}
