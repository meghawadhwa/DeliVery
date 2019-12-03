@testable import DeliveryChallenge

func getBasicDeliveryModel() -> DeliveryModel {
    return DeliveryModel(id: 0, description: "Mock", imageUrl: "abc", location: CoordinateModel(latitude: 0, longitude: 0, address: "abc"))
}
