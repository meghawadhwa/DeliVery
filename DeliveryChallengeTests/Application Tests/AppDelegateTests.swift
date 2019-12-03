import XCTest
@testable import DeliveryChallenge

class AppDelegateTests: XCTestCase {
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func setUp() {
    }

    override func tearDown() {
    }

    func testIfRootViewControllerIsSet() {
        let rootViewController = appDelegate.window?.rootViewController
        XCTAssertTrue(rootViewController?.isKind(of: UINavigationController.self) ?? false)
        XCTAssertTrue((rootViewController as! UINavigationController).topViewController?.isKind(of: DeliveryListViewController.self) ?? false)
    }

    func testIfCrashlyticsIsSetUp() {
        let mockCrashlytics = MockCrashlyticsUtils()
        appDelegate.crashlyticsUtils = mockCrashlytics

        _ = appDelegate.application(UIApplication.shared, didFinishLaunchingWithOptions: nil)
        
        XCTAssertEqual(mockCrashlytics.counterForConfigure, 1)
    }
}
