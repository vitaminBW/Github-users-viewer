//
//  ListOfUserFollowersRequest.swift
//  Github users viewer
//
//  Created by Vitaliy Bal on 4/11/18.
//  Copyright © 2018 VitaliySoft. All rights reserved.
//

import Foundation
import SwiftyJSON
import Result

struct DownloadListOfUserFollowersProvider: APIRequestProvider {
    
    let username: String?
    let perPage: NSNumber
    let since: String
    
    func provideRequest() -> Request {
        let urlStr = "(username)/followers"
        var result = urlStr
        if let username = username {
            result = urlStr.replacingOccurrences(of: "(username)", with: username)
        }
        let request = Request(
            url: APIURLProviderLocator.sharedProvider.URL(url: .ListOfUsersURL, path: result)!,
            method: .GET,
            encoding: .URL,
            params: ["since": since, "per_page": perPage],
            expectedContentTypes: ["application/json"]
        )
        return request
    }
}

// MARK:- Deserializer
class DownloadListOfUserFollowersResponseDeserializer: APIResponseDeserializer {
    typealias Value = [User]
    
    func deserialize(data: Data?) -> Result<[User], NSError> {
        guard let data = data, let json = JSON(data: data).array else {
            return .success([])
        }
        return .success(json.flatMap(User.create))
    }
}
