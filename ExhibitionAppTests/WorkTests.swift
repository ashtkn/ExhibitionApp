import XCTest
@testable import ExhibitionApp

class WorkTests: XCTestCase {
    
    let jsonData = """
    {
        "id": 1,
        "title": "Turtle Rock 1",
        "resource": "Syaro",
        "authors": [
            "Someone"
        ],
        "headerImagePath": "turtlerock.jpg",
        "galleryImagesPaths": [
            "turtlerock.jpg",
            "turtlerock.jpg"
        ],
        "caption": "これはキャプションです．",
        "isLocked": false
    }
    """.data(using: .utf8)!
    
    let invalidJsonData = """
    {
        "id": 1,
        "title": "Turtle Rock 1"
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
        
        XCTAssertEqual(work.id, 1)
        XCTAssertEqual(work.title, "Turtle Rock 1")
        XCTAssertEqual(work.resource, "Syaro")
        
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
        
        let id = 1
        let workToCompare = Work(id: id, title: "", resource: "", authors: [], headerImagePath: "", galleryImagesPaths: [], caption: "", isLocked: false)
        XCTAssertEqual(work, workToCompare)
    }
}
