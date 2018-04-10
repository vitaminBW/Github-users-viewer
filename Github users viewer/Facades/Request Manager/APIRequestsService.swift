//
//  APIRequestsService.swift
//  Github users viewer
//
//  Created by Vitaliy Bal on 4/9/18.
//  Copyright © 2018 VitaliySoft. All rights reserved.
//

import Foundation
import Alamofire
import enum Result.Result


protocol APIRequestsServiceProtocol {
    func request(requestObject: Request, callback: @escaping(Result<BaseResponse<Data?>, BaseResponseError>) -> Void) -> ResponseCancelable?
}

// based on Alamofire
class APIRequestsService : APIRequestsServiceProtocol {
    
    var sessionManager: Alamofire.SessionManager
    
    init () {
        let config = URLSessionConfiguration.default
        config.requestCachePolicy = .reloadIgnoringLocalCacheData
        
        sessionManager = Alamofire.SessionManager(configuration:config)
    }
    
    func request(requestObject: Request, callback: @escaping(Result<BaseResponse<Data?>, BaseResponseError>) -> Void) -> ResponseCancelable? {
        guard let url = requestObject.request.url,
            let method = requestObject.request.httpMethod  else {
                callback(.failure(BaseResponseError(error: NSError(domain: GithubDomain, code: ErrorCodes.UnknownError.rawValue))))
                return ResponseNullCancelable()
        }
        
        var request = sessionManager.request(url,
                                             method: HTTPMethod(rawValue: method) ?? HTTPMethod.get,
                                             parameters: requestObject.params,
                                             encoding: requestObject.encoding == .URL ? URLEncoding.default : URLEncoding.httpBody)
            .validate(contentType: requestObject.expectedContentTypes)
            .validate(statusCode: [200, 202])
        
        if ( requestObject.expectedStatusCodes.count > 0 ) {
            request = request.validate(statusCode: requestObject.expectedStatusCodes)
        }
        
        return request.response { [weak self] responseObject in

            if responseObject.error != nil {
                let code = responseObject.response?.statusCode ?? ErrorCodes.UnknownError.rawValue
                let errorMessage = self?.errorMessage(from: responseObject.data) ?? "Error"
                print("Response Error Message: \(errorMessage))\n")
                let err = NSError(domain: GithubDomain,
                                  code: code,
                                  userInfo: [NSLocalizedDescriptionKey: errorMessage])
                
                callback(.failure(BaseResponseError(error: err, response: responseObject.response)))
            } else {
                let response = BaseResponse<Data?>(value: responseObject.data, response: responseObject.response)
                callback(.success(response))
            }
            }.task
    }
}

//MARK: Server error message mapping
extension APIRequestsService {
    
    func errorMessage(from data: Data?) -> String {
        
        var errorString = "Something goes wrong"
        if let responseData = data {
            do {
                if let response = try JSONSerialization.jsonObject(with: responseData, options:[]) as? [String: [String]],
                    let errorsArray = response["errors"] {
                    errorString = errorsArray.joined(separator: "\n")
                } else if let responseDictionary = try JSONSerialization.jsonObject(with: responseData, options:[]) as? [String: String],
                    let errorMessage = responseDictionary["error_description"] {
                    errorString = errorMessage
                }
            } catch _ as NSError { }
        }
        return errorString
    }
}
