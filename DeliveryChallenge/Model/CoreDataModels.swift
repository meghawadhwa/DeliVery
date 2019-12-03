import Foundation
import CoreData

extension Delivery {
    convenience init(withDelivery delivery: DeliveryModel, insertIntoManagedObjectContext context: NSManagedObjectContext) {
        let entity = NSEntityDescription.entity(forEntityName: CacheConstants.deliveryEntity, in: context)!
        self.init(entity: entity, insertInto: context)
        title       = delivery.description
        id          = delivery.id
        imageUrl    = delivery.imageUrl
        location = Coordinate(withCoordinate: delivery.location, insertIntoManagedObjectContext: context)
    }
}

extension Coordinate {
    convenience init(withCoordinate coordinate: CoordinateModel, insertIntoManagedObjectContext context: NSManagedObjectContext) {
        let entity = NSEntityDescription.entity(forEntityName: CacheConstants.coordinateEntity, in: context)!
        self.init(entity: entity, insertInto: context)
        address    = coordinate.address
        latitude   = coordinate.latitude
        longitude  = coordinate.longitude
    }

}
