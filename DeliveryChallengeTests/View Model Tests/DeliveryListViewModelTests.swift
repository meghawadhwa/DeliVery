import XCTest
@testable import DeliveryChallenge

class DeliveryListViewModelTests: XCTestCase {
    var deliveryListViewModel: DeliveryListViewModel!
    var asyncExpectation : XCTestExpectation!
    var mockCache: MockDeliveryCache!

    func setUp(response: [DeliveryModel]?, error: Error?, savedData: [DeliveryModel]?, internetAvailable: Bool? = true) {
        let apiError = error as? APIServiceError ?? nil
        let cacheError = error as? CacheError ?? nil
        mockCache = MockDeliveryCache(error: cacheError, response: savedData)
        let mockNetworkAdaptor = MockNetworkAdaptor(error: apiError, response: response)
        let mockReachabilityUtil = MockReachabilityUtil(internetAvailable: internetAvailable ?? true)
        asyncExpectation = expectation(description: "Async Request")
        deliveryListViewModel = DeliveryListViewModel(cache:mockCache, networkAdaptor: mockNetworkAdaptor, reachable: mockReachabilityUtil)
    }
    
    func testIfDatabaseIsDeletedOnSuccessWhenPullToRefresh() {
        setUp(response: [getBasicDeliveryModel()], error:  nil, savedData: nil)
        deliveryListViewModel.successCompletionHandler = {
          XCTAssertEqual(self.deliveryListViewModel.currentPage, 0)
           XCTAssertEqual(self.mockCache.counterForDeletingDB, 1)
           self.asyncExpectation.fulfill()
        }
        deliveryListViewModel.errorCompletionHandler = { _ in
            self.asyncExpectation.fulfill()
            XCTFail("Should not fail")
        }
        deliveryListViewModel.refreshDeliveries()
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testErrorWhenPullToRefresh() {
        setUp(response:nil, error:  APIServiceError.noNetwork, savedData: nil)
        deliveryListViewModel.successCompletionHandler = {
          XCTFail("Should fail")
          self.asyncExpectation.fulfill()
        }
        deliveryListViewModel.errorCompletionHandler = { error in
            XCTAssertTrue(self.deliveryListViewModel.isCallInProgress)
            XCTAssertEqual(error.description, LocalizedErrors.noNetwork)
            self.asyncExpectation.fulfill()
        }
        deliveryListViewModel.refreshDeliveries()
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testNextDataSetFetchedSuccessForDB() {
        setUp(response: nil, error:  nil, savedData: [getBasicDeliveryModel()])
        deliveryListViewModel.currentPage = 1
        deliveryListViewModel.successCompletionHandler = {
          XCTAssertTrue(self.deliveryListViewModel.isCallInProgress)
          XCTAssertEqual(self.deliveryListViewModel.countOfDeliveries(), 1)
          XCTAssertEqual(self.deliveryListViewModel.getDeliveryFor(index: 0).id, 0)
          XCTAssertEqual(self.deliveryListViewModel.currentPage, 2)
          self.asyncExpectation.fulfill()
        }
        deliveryListViewModel.errorCompletionHandler = { _ in
            self.asyncExpectation.fulfill()
             XCTFail("Should not fail")
        }

        deliveryListViewModel.getNextPageData()
        waitForExpectations(timeout: 2, handler: nil)
    }
}
