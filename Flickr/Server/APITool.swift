//
//  APITool.swift
//  Flickr
//
//  Created by lawliet on 2020/10/2.
//

import Foundation
import Alamofire

final class APITool {
    static let sharedSessionManager: Alamofire.SessionManager = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30
        return Alamofire.SessionManager(configuration: configuration)
    }()
    
    static func request<T: Codable>(urlStr: String, method: HTTPMethod, parameters: Parameters?, successHandle: ((_ responseModel: T) -> Void)?, failureHandle: ((_ error: Error) -> Void)?) {
        sharedSessionManager.request(urlStr, method: method, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            switch response.result {
            case .success:
                guard let data = response.data, let jsonModel = try? newJSONDecoder().decode(T.self, from: data) else { return }
                print("value: \(response.result.value)")
                successHandle?(jsonModel)
            case .failure(let error):
                failureHandle?(error)
            }
        }
    }
}
