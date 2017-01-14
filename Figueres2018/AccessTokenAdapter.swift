// Native Header
import Foundation
import Alamofire

class AccessTokenAdapter: RequestAdapter {
    private let accessToken: String
    
    init(accessToken: String) {
        self.accessToken = accessToken
    }
    
    
    func adapt(_ urlRequest: URLRequest) throws -> URLRequest {
        var urlRequest = urlRequest
        
//        if (urlRequest.url?.absoluteString.hasPrefix("https://httpbin.org"))! {
            urlRequest.setValue("Bearer " + accessToken, forHTTPHeaderField: "Authorization")
//        }
        
        return urlRequest
    }
}
