import Foundation
import Reachability

protocol ReachableBehavior {
    func isInternetAvailable() -> Bool
}

class ReachabilityUtil: ReachableBehavior {

    func isInternetAvailable() -> Bool {
        return !(Reachability.Connection.none == Reachability()?.connection)
    }
}
