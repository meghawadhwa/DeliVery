import XCTest

@testable import DeliveryChallenge

class URLRequestConfiguratorTests: XCTestCase {

    override func setUp() {
    }

    override func tearDown() {
    }

    func testURLWithOffset() {
        let url = URLRequestConfigurator().getDeliveriesURL(offset: 0, limit: 2)
        XCTAssertEqual(url?.host, Constants.host)
        XCTAssertEqual(url?.path,Constants.deliveryEndPoint)
        XCTAssertEqual(url?.query, "\(Constants.deliveryOffset)=0&\(Constants.deliveryLimit)=2")
    }

}
