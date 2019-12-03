import Foundation

struct DeliveryModel: Codable {
    public let id: Int16
    public let description: String
    public let imageUrl: String
    public let location: CoordinateModel

    init(id:Int16, description: String, imageUrl: String, location: CoordinateModel) {
        self.id             = id
        self.description    = description
        self.imageUrl       = imageUrl
        self.location       = location
    }

    init(delivery: Delivery) {
        id                  = delivery.id
        description         = delivery.title ?? ""
        imageUrl            = delivery.imageUrl ?? ""
        location            = CoordinateModel(coordinate: delivery.location!)
    }

}

struct CoordinateModel: Codable {
    public let latitude: Double
    public let longitude: Double
    public let address: String
    enum CodingKeys: String, CodingKey {
        case latitude = "lat"
        case longitude = "lng"
        case address
    }

    init(latitude: Double, longitude: Double, address: String) {
        self.latitude = latitude
        self.longitude = longitude
        self.address = address
    }

    init(coordinate: Coordinate) {
        latitude = coordinate.latitude
        longitude = coordinate.longitude
        address = coordinate.address!
    }
}
