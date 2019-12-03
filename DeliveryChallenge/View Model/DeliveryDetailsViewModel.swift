import Foundation

protocol DeliveryDetailsViewModelBehavior {
    func getDescriptionText() -> String
    func getImageUrl() -> URL?
    func getMapCoordinates() -> CoordinateModel
}

class DeliveryDetailsViewModel: DeliveryDetailsViewModelBehavior {

    private let delivery: DeliveryModel

    init(delivery: DeliveryModel) {
        self.delivery = delivery
    }

    func getMapCoordinates() -> CoordinateModel {
        return delivery.location
    }

    func getDescriptionText() -> String {
        return "\(delivery.description) \(LocalizedStrings.at) \(delivery.location.address)"
    }

    func getImageUrl() -> URL? {
        return URL(string:delivery.imageUrl)
    }
}
