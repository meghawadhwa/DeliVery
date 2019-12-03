import Foundation
typealias CompletionClosure = (() -> Void)
typealias ErrorClosure = (ErrorModel) -> Void

protocol DeliveryListViewModelBehavior {
    var successCompletionHandler: CompletionClosure? {get set}
    var errorCompletionHandler: ErrorClosure? {get set}
    func getDeliveries()
    var deliveries: [DeliveryModel] { get set}
    func shouldShowInfoLabel() -> Bool
    func countOfDeliveries() -> Int
    func getDeliveryFor(index: Int) -> DeliveryModel
    func refreshDeliveries()
    var currentPage : Int {get}
    func shouldFetchNextData(index: Int) -> Bool
    func getNextPageData()
    func getDescriptionText(forIndex index: Int) -> String
    func getImageUrl(forIndex index: Int) -> URL?
}

extension DeliveryListViewModel {

    func shouldShowInfoLabel() -> Bool {
       return !deliveries.isEmpty
    }

    func countOfDeliveries() -> Int {
        return deliveries.count
    }

    func getDeliveryFor(index: Int) -> DeliveryModel {
        return deliveries[index]
    }

    func getDescriptionText(forIndex index: Int) -> String {
        let delivery = deliveries[index]
        return "\(delivery.description) \(LocalizedStrings.at) \(delivery.location.address)"
    }

    func getImageUrl(forIndex index: Int) -> URL? {
        let delivery = deliveries[index]
        return URL(string:delivery.imageUrl)
    }
}
