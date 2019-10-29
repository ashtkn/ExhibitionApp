import XCTest
@testable import ExhibitionApp

class UserDataTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }
    
    func testUserDataObject() {
        let userData = UserData(id: 0, isFirstLaunch: true, isLoadingFiles: true)
        let userDataObject = UserDataObject.create(from: userData)
        
        XCTAssertEqual(userData, userDataObject.entity)
    }
}
