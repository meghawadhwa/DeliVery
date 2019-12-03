import XCTest
@testable import DeliveryChallenge

class DeliveryListViewControllerTests: XCTestCase {
    var deliveryListViewController: DeliveryListViewController!
    var mockDeliveryListViewModel: MockDeliveryListViewModel!
    var deliveryListNavigationController: UINavigationController!

    override func setUp() {
      setUp(nil, nil)
    }

    override func tearDown() {
        deliveryListViewController = nil
    }

    func testIfViewIsConfiguredCorrectly() {
        let _ = deliveryListViewController.view
        
        XCTAssertEqual(deliveryListViewController.title, LocalizedStrings.deliveryTitle)
        XCTAssertEqual(deliveryListViewController.view.backgroundColor, ColorPallete.baseBackgroundColor)
        XCTAssertTrue(deliveryListViewController.view.subviews.contains(deliveryListViewController.tableView))
        XCTAssertNotNil(deliveryListViewController.tableView.refreshControl)
        XCTAssertTrue(deliveryListViewController.view.subviews.contains(deliveryListViewController.infoLabel))
        XCTAssertEqual(deliveryListViewController.infoLabel.text, LocalizedStrings.pullToRefresh)
        XCTAssertTrue(deliveryListViewController.infoLabel.isHidden)
        XCTAssertNotNil(deliveryListViewController.tableView.tableFooterView)
    }
 
    func testIfHandleRefreshIsCalledCorrectly() {
        setUp(nil, [getBasicDeliveryModel()])
        _ = deliveryListViewController.view
        
        deliveryListViewController.handleRefresh(deliveryListViewController.tableView.refreshControl!)
        
        XCTAssertEqual(mockDeliveryListViewModel.counterRefreshDeliveries, 1)
    }
    
    func testFetchDeliveriesSuccess() {
        setUp(nil, [getBasicDeliveryModel()])
        let _ = deliveryListViewController.view
        
        XCTAssertEqual(mockDeliveryListViewModel.getDeliveryFor(index: 0).id, getBasicDeliveryModel().id)
        XCTAssertTrue(deliveryListViewController.tableView.refreshControl?.isRefreshing ?? true)
    }
    
    func setUp(_ error: ErrorModel?, _ response: [DeliveryModel]?) {
        mockDeliveryListViewModel = MockDeliveryListViewModel(error: error, response: response)
        deliveryListViewController = DeliveryListViewController(deliveryListViewModel: mockDeliveryListViewModel)
        deliveryListNavigationController = UINavigationController(rootViewController: deliveryListViewController)
    }
    
    func testFetchDeliveriesFailure() {
        let error = ErrorModel(error: .noNetwork)
        setUp(error,nil)

        let _ = deliveryListViewController.view

        wait(for: 2.0)
        XCTAssertEqual(mockDeliveryListViewModel.countOfDeliveries(), 0)
        XCTAssertFalse(deliveryListViewController.tableView.refreshControl?.isRefreshing ?? true)
        XCTAssertEqual(deliveryListViewController.infoLabel.text, LocalizedStrings.pullToRefresh)
    }
}
