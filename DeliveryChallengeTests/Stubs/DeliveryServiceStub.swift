import Foundation
import OHHTTPStubs
@testable import DeliveryChallenge

func getDeliveryListSuccessStub() -> OHHTTPStubsDescriptor {
    return stub(condition: isHost(Constants.host)) { _ in
        let obj = [
            [
                "id": 0,
                "description": "Deliver documents to Andrio",
                "imageUrl": "https://s3-ap-southeast-1.amazonaws.com/lalamove-mock-api/images/pet-8.jpeg",
                "location": [
                    "lat": 22.336093,
                    "lng": 114.155288,
                    "address": "Cheung Sha Wan"
                ]
            ]
        ]
        let stub = OHHTTPStubsResponse(jsonObject: obj, statusCode:Int32(HTTPStatusCode.ok.rawValue), headers: nil)
        return stub
    }
}

func getEmptyDeliveryListFailureStub() -> OHHTTPStubsDescriptor {
    return stub(condition: isHost(Constants.host)) { _ in
        let obj = [[]]
        let stub = OHHTTPStubsResponse(jsonObject: obj, statusCode:Int32(HTTPStatusCode.ok.rawValue), headers: nil)
        return stub
    }
}

func getNoDataFailureStub() -> OHHTTPStubsDescriptor {
    return stub(condition: isHost(Constants.host)) { _ in
        let stub = OHHTTPStubsResponse(error: APIServiceError.noDataFound)
        return stub
    }
}


func getDeliveryListServerErrorStub() -> OHHTTPStubsDescriptor {
    return stub(condition: isHost(Constants.host)) { _ in
        let stub = OHHTTPStubsResponse(error: APIServiceError.invalidResponse)
        return stub
    }
}

func getDeliveryListInternalServerErrorStub() -> OHHTTPStubsDescriptor {
        return stub(condition: isHost(Constants.host)) { _ in
            let stub = OHHTTPStubsResponse(jsonObject: [[]], statusCode:Int32(HTTPStatusCode.internalError.rawValue), headers: nil)
            return stub
        }
    }

func networkErrorStub() -> OHHTTPStubsDescriptor {
    return stub(condition: isHost(Constants.host)) { _ in
        let notConnectedError = NSError(domain:NSURLErrorDomain, code:Int(URLError.notConnectedToInternet.rawValue), userInfo:nil)
        return OHHTTPStubsResponse(error: notConnectedError)
    }
}


