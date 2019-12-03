import Foundation

class URLRequestConfigurator {

    func getDeliveriesURL(offset: Int, limit: Int) -> URL? {
        guard let deliveriesURL = URL(string: "https://\(Constants.host)\(Constants.deliveryEndPoint)") else {
            return nil
        }
        let queryItems = [URLQueryItem(name: Constants.deliveryOffset,
        value: "\(offset)"), URLQueryItem(name: Constants.deliveryLimit, value: "\(limit)")]
        var urlComponents =
            URLComponents(url: deliveriesURL, resolvingAgainstBaseURL: true)
        urlComponents?.queryItems = queryItems
        return urlComponents?.url
    }
}
