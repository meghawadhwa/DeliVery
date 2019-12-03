import Foundation

extension URLSession {
    func dataTask(with url: URL,
                  result: @escaping (Result<(URLResponse, Data), Error>) -> Void) -> URLSessionDataTask {
        return dataTask(with: url) { (data, response, error) in
            if let error = error {
                if let err = error as? URLError, err.code  == URLError.Code.notConnectedToInternet {
                    result(.failure(APIServiceError.noNetwork))
                    return
                } else {
                    result(.failure(error))
                    return
                }
            }
            guard let response = response, let data = data else {
                result(.failure(APIServiceError.noDataFound))
                return
            }
            result(.success((response, data)))
        }
    }
}
