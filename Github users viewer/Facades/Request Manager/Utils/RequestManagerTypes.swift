//
//  RequestManagerTypes.swift
//  Github users viewer
//
//  Created by Vitaliy Bal on 4/9/18.
//  Copyright © 2018 VitaliySoft. All rights reserved.
//

import Foundation
import Result

// MARK:- Response

struct BaseResponse<T> {
    let value: T
    let response: HTTPURLResponse?
    
    init(value: T, response: HTTPURLResponse? = nil) {
        self.value = value
        self.response = response
    }
}

// MARK:- Response Error

struct BaseResponseError: Swift.Error {
    let error: NSError
    let response: HTTPURLResponse?
    
    init(error: NSError, response: HTTPURLResponse? = nil) {
        self.error = error
        self.response = response
    }
}

// MARK:- Cancelable Protocol

protocol ResponseCancelable {
    func cancel()
}

// MARK:- Cancelable Null Object

struct ResponseNullCancelable: ResponseCancelable {
    func cancel() {}
}


extension URLSessionTask: ResponseCancelable {
}


// MARK:- Request

struct Request {
    let request: URLRequest
    let params: [String: Any]
    let encoding: RequestParamsEncoding
    let expectedStatusCodes: Array<Int>
    let expectedContentTypes: [String]
    let stubDataFilename: String
    
    init(
        url: URL,
        method: RequestMethod,
        encoding: RequestParamsEncoding,
        params: [String: Any] = [:],
        headers: [String: String] = [:],
        expectedStatusCodes: [Int] = [Int](),//(200..<300)
        expectedContentTypes: [String] = ["*/*"],
        stubDataFilename: String = ""
        ) {
        self.params = params
        self.encoding = encoding
        self.stubDataFilename = stubDataFilename
        self.expectedStatusCodes = expectedStatusCodes
        self.expectedContentTypes = expectedContentTypes
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.cachePolicy = .reloadRevalidatingCacheData
        
        self.request = request
    }
}

// MARK:- Request Params Encoding

enum RequestParamsEncoding: String {
    case URL
    case BODY
}

// MARK:- Request Method

enum RequestMethod: String {
    case GET
    case POST
    case PUT
    case DELETE
}


protocol APIRequestProvider {
    func provideRequest() -> Request
}
