import XCTest
@testable import ExhibitionApp

class FirebaseServiceTests: XCTestCase {

    override func setUp() {
        super.setUp()
        //FirebaseService.shared.configure()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testPerformanceOfFetchWorks() {
        measure {
            let fetchWorksExpectation = expectation(description: "Fetch works")
            FirebaseService.shared.fetchWorks().retry(3).timeout(timeout: 10.0).then({ works in
                XCTAssertNotNil(works)
            }).catch({ error in
                XCTFail(error.localizedDescription)
            }).always(body: {
                fetchWorksExpectation.fulfill()
            })
            wait(for: [fetchWorksExpectation], timeout: 10.0)
        }
    }
    
    func testPerformanceOfDownloadResource() {
        measure {
            let downloadResourceExpectation = expectation(description: "Download resource")
            let resourceName = "Chino.arobject"
            let resourceDirectoryToSave = DataStore.shared.resourcesDirectory
            FirebaseService.shared.download(resource: resourceName, to: resourceDirectoryToSave).retry(3).timeout(timeout: 10.0).then({ resourcePath in
                XCTAssertNotNil(resourcePath)
            }).catch({ error in
                XCTFail(error.localizedDescription)
            }).always(body: {
                downloadResourceExpectation.fulfill()
            })
            wait(for: [downloadResourceExpectation], timeout: 10.0)
        }
    }
    
    func testPerformanceOfDownloadImage() {
        measure {
            let downloadImageExpectation = expectation(description: "Download image")
            let imageName = "hatena.png"
            let imagesDirectoryToSave = DataStore.shared.imagesDirectory
            FirebaseService.shared.download(image: imageName, to: imagesDirectoryToSave).retry(3).timeout(timeout: 10.0).then({ imagePath in
                XCTAssertNotNil(imagePath)
            }).catch({ error in
                XCTFail(error.localizedDescription)
            }).always(body: {
                downloadImageExpectation.fulfill()
            })
            wait(for: [downloadImageExpectation], timeout: 10.0)
        }
    }
}
