import XCTest
@testable import ExhibitionApp

class WorkTests: XCTestCase {
    
    let jsonData = """
    {
        "id": "XXXXXX",
        "title": "Syaro",
        "resources": [
            {
                "type": "object",
                "filename": "Syaro.arobject"
            },
            {
                "type": "image",
                "filename": "Hachijo.jpg",
                "size": 0.2
            }
        ],
        "authors": [
            "Someone"
        ],
        "images": [
            "turtlerock.jpg"
        ],
        "caption": "これはキャプションです．",
        "url": "https://www.google.co.jp/",
        "is_locked": false,
        "version": 0
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
    }
    
    func testEuatableProtocol() {
        let decoder = JSONDecoder()
        
        XCTAssertNoThrow(try decoder.decode(Work.self, from: jsonData))
        let work = try! decoder.decode(Work.self, from: jsonData)
        let resources = [Resource]()
        
        let id = "XXXXXX"
        let workToCompare = Work(id: id, title: "", authors: [], images: [], caption: "", url: "",  isLocked: false, version: 0, resources: resources)
        XCTAssertEqual(work, workToCompare)
    }
}
