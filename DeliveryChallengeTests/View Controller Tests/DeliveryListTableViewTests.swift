import Foundation
import XCTest
@testable import DeliveryChallenge

class DeliveryListTableViewTests: XCTestCase {
    var deliveryListViewController: DeliveryListViewController!
    var mockDeliveryListViewModel: MockDeliveryListViewModel!
    var deliveryListNavigationController: UINavigationController!

    override func setUp() {
       setUp(nil, nil)
    }

    override func tearDown() {
        deliveryListViewController = nil
    }

  func setUp(_ error: ErrorModel?, _ response: [DeliveryModel]?) {
      mockDeliveryListViewModel = MockDeliveryListViewModel(error: error, response: response)
      deliveryListViewController = DeliveryListViewController(deliveryListViewModel: mockDeliveryListViewModel)
      deliveryListNavigationController = UINavigationController(rootViewController: deliveryListViewController)
  }
    
    func testIfTableViewIsSetUpCorrectly() {
        let _ = deliveryListViewController.view
        
        XCTAssertFalse(deliveryListViewController.tableView.translatesAutoresizingMaskIntoConstraints)
        XCTAssertEqual(deliveryListViewController.tableView.separatorStyle, .none)
        XCTAssertNotNil(deliveryListViewController.tableView.refreshControl)
        XCTAssertEqual(deliveryListViewController.tableView.refreshControl?.tintColor, ColorPallete.themeColor)
    }
    
    func testIfDetailViewIsPushedCorrectly() {
        setUp(nil, [getBasicDeliveryModel()])
        let _ = deliveryListNavigationController.view
        deliveryListViewController.tableView(deliveryListViewController.tableView, didSelectRowAt: IndexPath(row: 0, section: 0))
        wait(for: 2.0)
        let details = deliveryListNavigationController.topViewController as? DeliveryDetailsViewController
        XCTAssertNotNil(details)
       //TODO XCTAssertEqual(details?.deliveryDetailCell., "Mock")
    }
    
    func testIfNextPageCallIsMadeCorrectly() {
        setUp(nil, [getBasicDeliveryModel()])
        let _ = deliveryListNavigationController.view
        let tableviewCell = UITableViewCell.init()
        let indexPath = IndexPath(item: 0, section: 0)
        
        deliveryListViewController.tableView(deliveryListViewController.tableView, willDisplay: tableviewCell, forRowAt: indexPath)
        
        XCTAssertEqual(mockDeliveryListViewModel.counterForNextPageCall, 1)
    }
}
