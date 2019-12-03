import Foundation

protocol APIBehavior {
    typealias Completion = (Result<[DeliveryModel], APIServiceError>) -> Void
    func getDeliveries(offset: Int, limit: Int, completion: @escaping (Completion))
}

class NetworkAdaptor: APIBehavior {
    var session: URLSession!
    typealias Completion = (Result<[DeliveryModel], APIServiceError>) -> Void

    func getDeliveries(offset: Int, limit: Int, completion: @escaping (Completion)) {
        guard let modifiedURL = URLRequestConfigurator().getDeliveriesURL(offset: offset, limit: limit) else {
            completion(.failure(.invalidEndpoint))
            return
        }
        URLSession.shared.dataTask(with: modifiedURL) { result in
            switch result {
            case .success(let (response, data)):
                guard let statusCode = (response as? HTTPURLResponse)?.statusCode else {
                    completion(.failure(.invalidResponse))
                    return
                }
                 guard 200..<299 ~= statusCode else {
                    completion(.failure(.apiError))
                    return
                }
                do {
                    let values = try JSONDecoder().decode([DeliveryModel].self, from: data)
                    if values.isEmpty {
                        completion(.failure(.noDataFound))
                    } else {
                        completion(Result.success(values))
                    }
                } catch {
                    completion(.failure(APIServiceError.emptyOrInvalidJson))
                }
            case .failure(let error):
                if let serviceError = error as? APIServiceError {
                    completion(.failure(serviceError))
                } else {
                    completion(.failure(APIServiceError.apiError))
                }
            }
            }.resume()
    }
}

public enum APIServiceError: Error,Equatable {
    case noDataFound
    case invalidEndpoint
    case emptyOrInvalidJson
    case noNetwork
    case invalidResponse
    case apiError
}
