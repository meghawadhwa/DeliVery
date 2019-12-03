import Foundation
import XCTest
@testable import DeliveryChallenge

class DeliveryListViewModelNetworkTests: XCTestCase {
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

    func testFetchedDeliveriesFromNetworkSuccess() {
        setUp(response: [getBasicDeliveryModel()], error: nil, savedData: nil)
        deliveryListViewModel.successCompletionHandler = {
            self.asyncExpectation.fulfill()
            XCTAssertEqual(self.deliveryListViewModel.countOfDeliveries(), 1)
            XCTAssertEqual(self.deliveryListViewModel.getDeliveryFor(index: 0).id, 0)
        }
        deliveryListViewModel.errorCompletionHandler = { error in
            self.asyncExpectation.fulfill()
            XCTFail("\(error)")
        }

        deliveryListViewModel.refreshDeliveries()
        waitForExpectations(timeout: 2, handler: nil)
    }

    func testFetchedDeliveriesWithNoNetworkError() {
        setUp(response: nil, error: APIServiceError.noNetwork, savedData: nil)
        deliveryListViewModel.successCompletionHandler = {
            self.asyncExpectation.fulfill()
            XCTFail("Should not pass")
        }
        deliveryListViewModel.errorCompletionHandler = { error in
            XCTAssertEqual(error.description, LocalizedErrors.noNetwork)
            self.asyncExpectation.fulfill()
        }
        deliveryListViewModel.refreshDeliveries()
        waitForExpectations(timeout: 2, handler: nil)
    }

    func testFetchedDeliveriesWithNoNetworkAvailable() {
        setUp(response: nil, error: nil, savedData: nil, internetAvailable: false)
        deliveryListViewModel.successCompletionHandler = {
            self.asyncExpectation.fulfill()
            XCTFail("Should not pass")
        }
        deliveryListViewModel.errorCompletionHandler = { error in
            XCTAssertEqual(error.description, LocalizedErrors.noNetwork)
            self.asyncExpectation.fulfill()
        }

        deliveryListViewModel.refreshDeliveries()

        waitForExpectations(timeout: 2, handler: nil)
    }

    func testFetchedDeliveriesFromAPIError() {
        setUp(response: nil, error: APIServiceError.apiError, savedData: nil)
        deliveryListViewModel.successCompletionHandler = {
            self.asyncExpectation.fulfill()
            XCTFail("Should not pass")
        }
        deliveryListViewModel.errorCompletionHandler = { error in
            XCTAssertEqual(error.description, LocalizedErrors.apiError)
            self.asyncExpectation.fulfill()
        }

        deliveryListViewModel.refreshDeliveries()
        waitForExpectations(timeout: 2, handler: nil)
    }

    func testFetchedDeliveriesFromAPIInvalidEndpoint() {
        setUp(response: nil, error: APIServiceError.invalidEndpoint, savedData: nil)
        deliveryListViewModel.successCompletionHandler = {
            self.asyncExpectation.fulfill()
            XCTFail("Should not pass")
        }
        deliveryListViewModel.errorCompletionHandler = { error in
            XCTAssertEqual(error.description, LocalizedErrors.invalidEndpoint)
            self.asyncExpectation.fulfill()
        }

        deliveryListViewModel.refreshDeliveries()
        waitForExpectations(timeout: 2, handler: nil)
    }

    func testFetchedDeliveriesFromNetworkNoData() {
        setUp(response: nil, error: APIServiceError.noDataFound, savedData: nil)
        deliveryListViewModel.successCompletionHandler = {
            self.asyncExpectation.fulfill()
            XCTFail("Should not pass")
        }
        deliveryListViewModel.errorCompletionHandler = { error in
            XCTAssertEqual(error.description, LocalizedErrors.noDataFound)
            self.asyncExpectation.fulfill()
        }

        deliveryListViewModel.refreshDeliveries()
        waitForExpectations(timeout: 2, handler: nil)
    }

    func testFetchedDeliveriesFromAPIInvalidResponse() {
        setUp(response: nil, error: APIServiceError.invalidResponse, savedData: nil)
        deliveryListViewModel.successCompletionHandler = {
            self.asyncExpectation.fulfill()
            XCTFail("Should not pass")
        }
        deliveryListViewModel.errorCompletionHandler = { error in
            XCTAssertEqual(error.description, LocalizedErrors.invalidResponse)
            self.asyncExpectation.fulfill()
        }

        deliveryListViewModel.refreshDeliveries()
        waitForExpectations(timeout: 2, handler: nil)
    }

    func testFetchedDeliveriesSuccess() {
        let deliveries = [getBasicDeliveryModel()]
        setUp(response: nil, error: nil, savedData: deliveries)
        deliveryListViewModel.successCompletionHandler = {
            XCTAssertEqual(deliveries.count, 1)
                           XCTAssertEqual(deliveries.first?.id, 0)
                           self.asyncExpectation.fulfill()
        }
        deliveryListViewModel.errorCompletionHandler = { error in
                        XCTFail("\(error)")
                          self.asyncExpectation.fulfill()
        }
        
        deliveryListViewModel.getDeliveries()
        
        waitForExpectations(timeout: 2, handler: nil)
    }
}
