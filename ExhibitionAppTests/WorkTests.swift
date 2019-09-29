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

    override func setUp() {}

    override func tearDown() {}

    func testDecodingFromJsonData() {
        let decoder = JSONDecoder()
        let work = try? decoder.decode(Work.self, from: jsonData)
        
        XCTAssertNotNil(work)
        XCTAssertEqual(work?.id, 1)
        XCTAssertEqual(work?.title, "Turtle Rock 1")
        XCTAssertEqual(work?.resource, "Syaro")
    }
    
    func testEuatableProtocol() {
        let decoder = JSONDecoder()
        let work = try? decoder.decode(Work.self, from: jsonData)
        
        let id = 1
        let workToCompare = Work(id: id, title: "", resource: "", authors: [], headerImagePath: "", galleryImagesPaths: [], caption: "", isLocked: false)
        XCTAssertEqual(work, workToCompare)
    }
}
