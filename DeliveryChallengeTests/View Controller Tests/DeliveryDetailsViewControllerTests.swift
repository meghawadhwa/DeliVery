import XCTest
import MapKit

@testable import DeliveryChallenge

class DeliveryDetailsViewControllerTests: XCTestCase {
    var deliveryDetailsViewController: DeliveryDetailsViewController!
    
    override func setUp() {
        let viewModel = DeliveryDetailsViewModel(delivery: getBasicDeliveryModel())
        deliveryDetailsViewController = DeliveryDetailsViewController(deliveryDetailsViewModel: viewModel)
    }
    
    override func tearDown() {
        deliveryDetailsViewController = nil
    }
    
    func testIfViewIsConfiguredCorrectly() {
        let _ = deliveryDetailsViewController.view
        
        XCTAssertEqual(deliveryDetailsViewController.view.backgroundColor, UIColor.white)
        XCTAssertEqual(deliveryDetailsViewController.title, LocalizedStrings.deliveryDetails)
        XCTAssertTrue(deliveryDetailsViewController.view.subviews.contains(deliveryDetailsViewController.mapView))
        XCTAssertTrue(deliveryDetailsViewController.view.subviews.contains(deliveryDetailsViewController.deliveryDetailCell))
        XCTAssertTrue(deliveryDetailsViewController.view.subviews.contains(deliveryDetailsViewController.cellSuperview))
    }
    
    func testIfPlacemarkIsAdded() {
        let _ = deliveryDetailsViewController.view
        let coordinates = deliveryDetailsViewController.viewModel.getMapCoordinates()
        let placemark = MKPointAnnotation()
        placemark.title = coordinates.address
        placemark.coordinate = CLLocationCoordinate2D(latitude: coordinates.latitude, longitude: coordinates.longitude)

        XCTAssertTrue(deliveryDetailsViewController.mapView.annotations.contains(where: { (annotation) -> Bool in
         return annotation.title == placemark.title
        }))
    }
}
