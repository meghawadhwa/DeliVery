import Foundation
@testable import DeliveryChallenge

class MockNetworkAdaptor: APIBehavior {
    var error: APIServiceError?
    var response: [DeliveryModel]?
    init(error: APIServiceError?, response: [DeliveryModel]?) {
        self.error = error
        self.response = response
    }
    func getDeliveries(offset: Int, limit: Int, completion: @escaping(Completion)) {
        if let errorPresent = error {
            completion(.failure(errorPresent))
        } else if let aResponse = response{
            completion(.success(aResponse))
        }
    }
 }
