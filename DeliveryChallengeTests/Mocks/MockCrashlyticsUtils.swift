import Foundation
@testable import DeliveryChallenge

class MockCrashlyticsUtils: CrashlyticsUtilsBehavior {
    var counterForConfigure = 0
    func configure() {
        counterForConfigure += 1
    }
    
}
