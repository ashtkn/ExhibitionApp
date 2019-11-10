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
            {
                "name": "hoge",
                "imageName": "fuga",
                "greeting": "Hi",
                "belonging": "something"
            }
        ],
        "images": [
            "turtlerock.jpg"
        ],
        "caption": "これはキャプションです．",
        "url": "https://www.google.co.jp/",
        "is_locked": false,
        "version": 0,
        "keyword_images": ["something"]
    }
    """.data(using: .utf8)!
    
    let invalidJsonData = """
    {
        "id": "XXXXXX",
        "title": "Syaro"
    }
    """.data(using: .utf8)!
    
    private func getWork() throws -> Work {
        let decoder = JSONDecoder()
        return try decoder.decode(Work.self, from: jsonData)
    }

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testDecoding() {
        XCTAssertNoThrow(try getWork())
        
        let decoder = JSONDecoder()
        XCTAssertThrowsError(try decoder.decode(Work.self, from: invalidJsonData))
    }
    
    func testEncoding() {
        let work = try! getWork()
        
        let encoder = JSONEncoder()
        XCTAssertNoThrow(try encoder.encode(work))
        
        let data = try! encoder.encode(work)
        let decoder = JSONDecoder()
        XCTAssertNoThrow(try decoder.decode(Work.self, from: data))
    }
    
    func testEuatableProtocol() {
        let id = "XXXXXX"
        let version = 0
        let work = Work(id: id, title: "", authors: [], images: [], caption: "", url: "",  isLocked: false, version: version, resources: [], keywordImages: [])
        
        XCTAssertEqual(work, try! getWork())
    }
    
    func testWorkObject() {
        let work = try! getWork()
        let workObject = WorkObject.create(from: work)
        
        XCTAssertEqual(work.id, workObject.id)
        XCTAssertEqual(work.version, workObject.version)
        
        XCTAssertEqual(work, workObject.entity)
    }
}
