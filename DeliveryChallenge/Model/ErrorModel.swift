import Foundation

struct ErrorModel: Error, CustomStringConvertible {
    let error: APIServiceError
    init(error: APIServiceError) {
        self.error = error
    }

    var description: String {
        let message: String
        switch error {
        case .emptyOrInvalidJson:
            message = LocalizedErrors.invalidJson
        case .invalidEndpoint:
            message = LocalizedErrors.invalidEndpoint
        case .noDataFound:
            message = LocalizedErrors.noDataFound
        case .noNetwork:
            message = LocalizedErrors.noNetwork
        case .apiError:
            message = LocalizedErrors.apiError
        case .invalidResponse:
            message = LocalizedErrors.invalidResponse
        }
        return message
    }
}
