import XCTest
@testable import ExhibitionApp

class AssetsManagerTests: XCTestCase {

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }
    
    func testAssetsManager() {
        let assetsManager = AssetsManager.default
        for icon in AssetsManager.IconName.allCases {
            let _ = assetsManager.getImage(icon: icon)
        }
    }
}
