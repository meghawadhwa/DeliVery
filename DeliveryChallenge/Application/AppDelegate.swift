import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    lazy var coreDataStack = CoreDataStack()
    lazy var crashlyticsUtils: CrashlyticsUtilsBehavior = CrashlyticsUtils()
    func application(_ application: UIApplication, didFinishLaunchingWithOptions
        launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        let cache = DeliveryCache(context: coreDataStack.persistentContainer.viewContext)
        let deliveryModel = DeliveryListViewModel(cache: cache, networkAdaptor: NetworkAdaptor(), reachable: ReachabilityUtil())
        let deliveryListController = DeliveryListViewController(deliveryListViewModel: deliveryModel)
        window?.rootViewController = UINavigationController(rootViewController:deliveryListController)
        crashlyticsUtils.configure()
        window?.makeKeyAndVisible()
        return true
    }
}
