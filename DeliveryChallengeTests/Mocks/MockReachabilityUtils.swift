import Foundation
@testable import DeliveryChallenge

class MockReachabilityUtil: ReachableBehavior {
    let internetAvailable: Bool

    init(internetAvailable: Bool) {
        self.internetAvailable = internetAvailable
    }

    func isInternetAvailable() -> Bool {
        return internetAvailable
    }
}

