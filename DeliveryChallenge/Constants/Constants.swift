import Foundation
import UIKit

struct Constants {
  static let host = "mock-api-mobile.dev.lalamove.com"
  static let deliveryEndPoint = "/deliveries"
  static let deliveryOffset = "offset"
  static let deliveryLimit = "limit"
  static let placeHolderImageName = "Placeholder.png"
  static let deliveryFetchLimit = 20
  static let cellIdentifier = "cell"
  static let defaultFontSize: CGFloat = 14.0
  static let toastDuration = 2.0
}

enum HTTPStatusCode: Int {
    case ok = 200
    case created
    case badRequest = 400
    case unauthorized = 401
    case notFound = 404
    case notConfirmed = 412
    case mediaTypeError = 415
    case unprocessibleEntity = 422
    case conflict = 409
    case tooManyRequests = 429
    case internalError = 500
    case forbidden = 503
    case networkError = -1
    case unknownError = 1000
}

struct LocalizedStrings {
    static let deliveryTitle             = NSLocalizedString("Things To Deliver", comment: "")
    static let infoFetchingDeliveries    = NSLocalizedString("Fetching Deliveries ...", comment: "")
    static let deliveryDetails           = NSLocalizedString("Delivery Details", comment: "")
    static let okTitle                   = NSLocalizedString("OK", comment: "")
    static let alertTitle                = NSLocalizedString("Alert", comment: "")
    static let at                        = NSLocalizedString("at", comment: "")
    static let pullToRefresh             = NSLocalizedString("Pull Down To Refresh", comment: "")
}

struct CacheConstants {
    static let deliveryEntity       = "Delivery"
    static let coordinateEntity     = "Coordinate"
    static let deliveryID           = "id"
    static let persistantContainer  = "DeliveryChallenge"
}

struct LocalizedErrors {
    static let inMemoryError    = NSLocalizedString("Adding in-memory persistent store failed.", comment: "")
    static let fatalError       = NSLocalizedString("Unresolved error: ", comment: "")
    static let insertError      = NSLocalizedString("Failed to insert deliveries while saving context:", comment: "")
    static let invalidJson      = NSLocalizedString("Unparseable data returned from Server.", comment: "")
    static let invalidResponse  = NSLocalizedString("Invalid data returned from Server.", comment: "")
    static let invalidEndpoint  = NSLocalizedString("Invalid server endpoint. Please check and try again.", comment: "")
    static let noDataFound      = NSLocalizedString("No more Data available to show.", comment: "")
    static let noNetwork        = NSLocalizedString("Please check your Internet connection and try again.", comment: "")
    static let apiError         = NSLocalizedString("Something went wrong. Please try again later.", comment: "")
}

struct ColorPallete {
    static let baseBackgroundColor = UIColor.white
    static let cellBackgroundColor = UIColor.lightGray
    static let labelTextColor      = UIColor.white
    static let themeColor          = UIColor(red: 112.0/255.0, green: 188.0/255.0, blue: 217.0/255.0, alpha: 1.0)
}

struct InfoLabelConstants {
    static let height = 60.0
}
