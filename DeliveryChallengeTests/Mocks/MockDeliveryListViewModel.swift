import Foundation
@testable import DeliveryChallenge

class MockDeliveryListViewModel: DeliveryListViewModelBehavior {
    var successCompletionHandler: CompletionClosure?
    
    var errorCompletionHandler: ErrorClosure?
    
    var currentPage: Int
    var error: ErrorModel?
    var counterGetDeliveries = 0
    var counterRefreshDeliveries = 0
    var deliveries: [DeliveryModel]
    var counterForNextPageCall = 0
    init(error: ErrorModel?, response: [DeliveryModel]?) {
        self.error = error
        deliveries = response ?? [DeliveryModel]()
        currentPage = 0
    }

    func getDeliveries() {
        counterGetDeliveries += 1
        if let anError = error {
            errorCompletionHandler?(anError)
        } else {
            successCompletionHandler?()
        }
    }

    func shouldShowInfoLabel() -> Bool {
       return !deliveries.isEmpty
    }

    func countOfDeliveries() -> Int {
        return deliveries.count
    }

    func getDeliveryFor(index: Int) -> DeliveryModel {
        return deliveries[index]
    }

    func refreshDeliveries() {
       counterRefreshDeliveries += 1
    }

    func getNextPageData() {
        counterForNextPageCall += 1
    }
    
    func getDescriptionText(forIndex index: Int) -> String {
        return deliveries[index].description
    }
    
    func getImageUrl(forIndex index: Int) -> URL? {
        return URL(string: deliveries[index].imageUrl)
    }
    
    func shouldFetchNextData(index: Int) -> Bool {
        return true
    }
    
}
