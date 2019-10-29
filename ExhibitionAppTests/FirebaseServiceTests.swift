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
            FirebaseService.shared.fetchWorks().then({ works in
                XCTAssertNotNil(works)
                fetchWorksExpectation.fulfill()
            }).catch({ error in
                XCTFail(error.localizedDescription)
                fetchWorksExpectation.fulfill()
            })
            wait(for: [fetchWorksExpectation], timeout: 10.0)
        }
    }
}
