//
//  APIRequestsManager.swift
//  Github users viewer
//
//  Created by Vitaliy Bal on 4/9/18.
//  Copyright © 2018 VitaliySoft. All rights reserved.
//

import UIKit
import ReactiveSwift

protocol APIRequestsManagerProtocol: class {

    func downloadUsers(since: String, perPage: NSNumber) -> SignalProducer<[User], NSError>

}

class APIRequestsManager: APIRequestsManagerProtocol {
    
    let serviceManager: APIRequestsServiceProtocol
    
    required init (serviceManager: APIRequestsServiceProtocol) {
        self.serviceManager = serviceManager
    }
    
    func downloadUsers(since: String, perPage: NSNumber) -> SignalProducer<[User], NSError> {
        return sendRequest(requestProvider: DownloadListOfUsersProvider(perPage: perPage, since: since), deserializer: DownloadListOfUsersResponseDeserializer())
    }

}
