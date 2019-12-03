import UIKit
import Firebase

protocol CrashlyticsUtilsBehavior {
    func configure()
}

class CrashlyticsUtils: CrashlyticsUtilsBehavior {
    func configure() {
        FirebaseApp.configure()
    }
    class func log(message: String) {
        CLSLogv("%@", getVaList([message]))
    }
}
