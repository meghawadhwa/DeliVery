import CoreData

class CoreDataStack {
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: CacheConstants.persistantContainer)
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                CrashlyticsUtils.log(message:"❗️\(#function) - \(error.userInfo)")
                fatalError("\(LocalizedErrors.fatalError)\(storeDescription) \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    func setUpInMemoryManagedObjectContext() -> NSManagedObjectContext {
        let managedObjectModel = NSManagedObjectModel.mergedModel(from: [Bundle.main])!
        let storeCoordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)
        do {
            try storeCoordinator.addPersistentStore(ofType: NSInMemoryStoreType, configurationName: nil, at: nil, options: nil)
        } catch {
            CrashlyticsUtils.log(message:LocalizedErrors.inMemoryError)
        }
        let managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = storeCoordinator
        return managedObjectContext
    }
}
