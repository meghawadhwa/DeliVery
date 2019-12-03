import XCTest
import OHHTTPStubs
import Foundation

@testable import DeliveryChallenge

class NetworkAdaptorTests: XCTestCase {
    var networkAdaptor: NetworkAdaptor!
    var stub: OHHTTPStubsDescriptor?

    override func setUp() {
        super.setUp()
        networkAdaptor = NetworkAdaptor()
    }

    override func tearDown() {
        stub = nil
        OHHTTPStubs.removeAllStubs()
        super.tearDown()
    }
    
    func testGetDeliveriesSuccessReturnDeliveries() {
        stub = getDeliveryListSuccessStub()
        let deliveriesExpection = expectation(description: "Deliveries")
        networkAdaptor.getDeliveries(offset: 0, limit: 1) { result in
            switch result {
            case .success(let deliveries):
                XCTAssertNotNil(deliveries)
                deliveriesExpection.fulfill()
            case .failure(let error):
                XCTAssertNil(error)
            }
        }
        waitForExpectations(timeout: 5.0, handler: nil)
    }
    
    func testGetDeliveriesFailureReturnsInternalError() {
        stub = getDeliveryListInternalServerErrorStub()
        let errorExpectation = expectation(description: "Internal Error")
        networkAdaptor.getDeliveries(offset: 0, limit: 2) { result in
            switch result {
            case .success(let deliveries):
                XCTAssertNil(deliveries)
            case .failure(let error):
                XCTAssertEqual(error, APIServiceError.apiError)
                errorExpectation.fulfill()
            }
        }
        waitForExpectations(timeout: 5.0, handler: nil)
    }
    
    func testGetDeliveriesFailureReturnsInvalidResponseError() {
        stub = getDeliveryListServerErrorStub()
        let errorExpectation = expectation(description: "Invalid Response Error")
        networkAdaptor.getDeliveries(offset: 0, limit: 2) { result in
            switch result {
            case .success(let deliveries):
                XCTAssertNil(deliveries)
            case .failure(let error):
                XCTAssertEqual(error, APIServiceError.invalidResponse)
                errorExpectation.fulfill()
            }
        }
        waitForExpectations(timeout: 5.0, handler: nil)
    }

    
    func testGetDeliveriesEmptyListReturnsError() {
        stub = getEmptyDeliveryListFailureStub()
        let errorExpectation = expectation(description: "Empty Json Error")
       networkAdaptor.getDeliveries(offset: 0, limit: 2) { result in
            switch result {
            case .success(let deliveries):
                XCTAssertNil(deliveries)
            case .failure(let error):
                XCTAssertEqual(error, APIServiceError.emptyOrInvalidJson)
                errorExpectation.fulfill()
            }
        }
        waitForExpectations(timeout: 5.0, handler: nil)
    }

    func testGetDeliveriesNoDataReturnsError() {
        stub = getNoDataFailureStub()
        let errorExpectation = expectation(description: "No Data Error")
        networkAdaptor.getDeliveries(offset: 0, limit: 2) { result in
            switch result {
            case .success(let deliveries):
                XCTAssertNil(deliveries)
            case .failure(let error):
                XCTAssertEqual(error, APIServiceError.noDataFound)
                errorExpectation.fulfill()
            }
        }
        waitForExpectations(timeout: 5.0, handler: nil)
    }

    func testGetDeliveriesNoInternetError() {
        stub = networkErrorStub()
        let errorExpectation = expectation(description: "No Internet Error")
        networkAdaptor.getDeliveries(offset: 0, limit: 2) { result in
            switch result {
            case .success(let deliveries):
                XCTAssertNil(deliveries)
            case .failure(let error):
                XCTAssertEqual(error, APIServiceError.noNetwork)
                errorExpectation.fulfill()
            }
        }
        waitForExpectations(timeout: 5.0, handler: nil)
    }
}
