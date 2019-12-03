import XCTest
@testable import DeliveryChallenge

class DeliveryDetailsViewModelTests: XCTestCase {
    var deliveryDetailsViewModel: DeliveryDetailsViewModel!
    var asyncExpectation : XCTestExpectation!
    
    override func setUp() {
        deliveryDetailsViewModel = DeliveryDetailsViewModel(delivery: getBasicDeliveryModel())
    }

    override func tearDown() {
        deliveryDetailsViewModel = nil
    }

    func testGetLocation() {
        let coordinate = deliveryDetailsViewModel.getMapCoordinates()
        
        XCTAssertEqual(coordinate.longitude, getBasicDeliveryModel().location.longitude)
        XCTAssertEqual(coordinate.latitude, getBasicDeliveryModel().location.latitude)
        
    }
    
}
