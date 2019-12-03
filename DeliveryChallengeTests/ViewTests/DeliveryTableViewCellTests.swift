import XCTest
@testable import DeliveryChallenge

class DeliveryTableViewCellTests: XCTestCase {
    var deliveryTableViewCell: DeliveryTableViewCell!
    override func setUp() {
        deliveryTableViewCell = DeliveryTableViewCell(style: .default, reuseIdentifier: Constants.cellIdentifier)
    }

    override func tearDown() {
        deliveryTableViewCell = nil
    }

    func testViewSetUpOnModelSet() {
        let mockModel = DeliveryDetailsViewModel(delivery: getBasicDeliveryModel())
        deliveryTableViewCell.configureUIForDetailView(viewModel: mockModel)
        XCTAssertEqual(deliveryTableViewCell.descriptionLabel.text, "Mock at abc")
        XCTAssertEqual(deliveryTableViewCell.cellView.backgroundColor, UIColor.lightGray)
        XCTAssertEqual(deliveryTableViewCell.cellView.layer.cornerRadius, 10.0)
    }
}
