//
//  SettingsResponseDeserializer.swift
//  Github users viewer
//
//  Created by Vitaliy Bal on 4/9/18.
//  Copyright © 2018 VitaliySoft. All rights reserved.
//

import Foundation
import SwiftyJSON
import Result

struct DownloadListOfUsersProvider: APIRequestProvider {
    
    let perPage: NSNumber
    let since: String
    
    func provideRequest() -> Request {
        let request = Request(
            url: APIURLProviderLocator.sharedProvider.URL(url: .ListOfUsersURL)!,
            method: .GET,
            encoding: .URL,
            params: ["since": since, "per_page": perPage],
            expectedContentTypes: ["application/json"]
        )
        return request
    }
}

// MARK:- Deserializer
class DownloadListOfUsersResponseDeserializer: APIResponseDeserializer {
    typealias Value = [User]
    
    func deserialize(data: Data?) -> Result<[User], NSError> {
        guard let data = data, let json = JSON(data: data).array else {
            return .success([])
        }
        return .success(json.flatMap(User.create))
    }
}
