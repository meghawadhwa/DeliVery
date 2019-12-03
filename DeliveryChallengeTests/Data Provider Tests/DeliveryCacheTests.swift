import XCTest
import CoreData
@testable import DeliveryChallenge

class DeliveryCacheTests: XCTestCase {
    var deliveryCache: DeliveryCache!
    var dbContext: NSManagedObjectContext!
    
    override func setUp() {
        super.setUp()
        dbContext = CoreDataStack().setUpInMemoryManagedObjectContext()
        deliveryCache = DeliveryCache(context: dbContext)
    }
    
    override func tearDown() {
        deliveryCache = nil
        dbContext = nil
        super.tearDown()
    }

    func testInsertedDeliveriesSuccess() {
        deliveryCache.insertDeliveries(deliveries: [DeliveryModel(id: 0, description: "MockTitle", imageUrl: "abc", location: CoordinateModel(latitude: 100, longitude: 100, address: "mockAddress"))])
        var deliveries = [Delivery]()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: CacheConstants.deliveryEntity)
        do {
            deliveries = try dbContext.fetch(fetchRequest) as! [Delivery]
        } catch {
            XCTFail("Failed in Fetch")
        }
        XCTAssertEqual(deliveries.count, 1, "Only one object was inserted")
        XCTAssertEqual(deliveries.first?.id, 0)
        XCTAssertEqual(deliveries.first?.title, "MockTitle")
        XCTAssertEqual(deliveries.first?.imageUrl, "abc")
    }

    func testFetchedDeliveriesSuccess() {
        deliveryCache.insertDeliveries(deliveries: [DeliveryModel(id: 1, description: "MockTitle1", imageUrl: "abc", location: CoordinateModel(latitude: 100, longitude: 100, address: "mockAddress"))])
        deliveryCache.insertDeliveries(deliveries: [DeliveryModel(id: 2, description: "MockTitle2", imageUrl: "abc2", location: CoordinateModel(latitude: 100, longitude: 100, address: "mockAddress"))])
        
        deliveryCache.fetchDeliveries(offset: 0, limit: 2) { result in
            switch result {
            case .failure(let error):
                XCTFail("\(error)")
            case .success(let deliveries):
                XCTAssertEqual(deliveries.count, 2)
                XCTAssertEqual(deliveries.first?.id, 1)
                XCTAssertEqual(deliveries[1].id, 2)
            }
        }
    }
    
    func testFetchedDeliveriesFailureWithNoData() {
        deliveryCache.fetchDeliveries(offset: 0, limit: 2) { result in
            switch result {
            case .failure(let error):
                XCTAssertEqual(error, CacheError.noData)
            case .success(_):
                XCTFail("Should not pass")
           }
        }
    }
    
    func testDeletedDeliveries() {
        deliveryCache.insertDeliveries(deliveries: [DeliveryModel(id: 1, description: "MockTitle1", imageUrl: "abc", location: CoordinateModel(latitude: 100, longitude: 100, address: "mockAddress"))])

        deliveryCache.deleteCachedDeliveries()
        
        testFetchedDeliveriesFailureWithNoData()
    }
    
}
