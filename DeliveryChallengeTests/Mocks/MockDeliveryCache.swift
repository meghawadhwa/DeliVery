import Foundation
@testable import DeliveryChallenge

class MockDeliveryCache: CacheBehavior {
    var error: CacheError?
    var response: [DeliveryModel]?
    var counterForDeletingDB = 0

    init(error: CacheError?, response: [DeliveryModel]?) {
        self.error = error
        self.response = response
    }
    func fetchDeliveries(offset: Int, limit: Int, completion: @escaping(Completion)) {
        if let errorPresent = error {
            completion(.failure(errorPresent))
        } else if let aResponse = response {
            completion(.success(aResponse))
        }
    }

    func insertDeliveries(deliveries: [DeliveryModel]) {
    }
    
    func deleteCachedDeliveries(){
        counterForDeletingDB += 1
    }

}
