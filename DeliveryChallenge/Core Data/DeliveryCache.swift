import Foundation
import UIKit
import CoreData

enum CacheError: Error,Equatable {
    case noData
    case dbError(_ localizedDescription: String)
}

protocol CacheBehavior {
    typealias Completion = (Result<[DeliveryModel], CacheError>) -> Void
    func insertDeliveries(deliveries: [DeliveryModel])
    func fetchDeliveries(offset: Int, limit: Int, completion: @escaping(Completion))
    func deleteCachedDeliveries()
}

class DeliveryCache: CacheBehavior {
    let context: NSManagedObjectContext
    typealias Completion = (Result<[DeliveryModel], CacheError>) -> Void
    init(context: NSManagedObjectContext) {
        self.context = context
    }

    func insertDeliveries(deliveries: [DeliveryModel]) {
        context.performAndWait {
            for delivery in deliveries {
                _ = Delivery(withDelivery: delivery, insertIntoManagedObjectContext: context)
            }
                if context.hasChanges {
                    do {
                        try context.save()
                    } catch {
                        handleError(error: error, message: LocalizedErrors.insertError)
                    }
                }
        }
    }

    func fetchDeliveries(offset: Int, limit: Int, completion: @escaping(Completion)) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: CacheConstants.deliveryEntity)
        fetchRequest.fetchLimit = limit
        fetchRequest.fetchOffset = offset
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: CacheConstants.deliveryID, ascending: true)]
        do {
            guard let deliveries = try context.fetch(fetchRequest) as? [Delivery], !deliveries.isEmpty else {
                completion(.failure(CacheError.noData))
                return
            }
            var deliveryModels = [DeliveryModel]()
            for delivery in deliveries {
                let deliveryModel = DeliveryModel(delivery: delivery)
                deliveryModels.append(deliveryModel)
            }
            completion(.success(deliveryModels))
        } catch {
            completion(.failure(CacheError.dbError(error.localizedDescription)))
        }

    }

    func deleteCachedDeliveries() {
        context.performAndWait {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: CacheConstants.deliveryEntity)
                 do {
                    guard let deliveries = try context.fetch(fetchRequest) as? [Delivery], !deliveries.isEmpty else {
                        return
                    }
                    for delivery in deliveries {
                        context.delete(delivery)
                    }
                    try context.save()
                     CrashlyticsUtils.log(message:"✅ \(#function) - \(CacheConstants.deliveryEntity) deleted")
                 } catch {
                     handleError(error: error, message: "Failed to delete \(CacheConstants.deliveryEntity):")
                 }
        }
    }

    func handleError(error: Error, message: String) {
        let nserror = error as NSError
        CrashlyticsUtils.log(message:"❗️\(message) - \(nserror.userInfo)")
        fatalError("\(message) \(error)")
    }
}
