//
//  LoadMoreUserFollowersModel.swift
//  Github users viewer
//
//  Created by Vitaliy Bal on 4/11/18.
//  Copyright © 2018 VitaliySoft. All rights reserved.
//

import Foundation
import ReactiveSwift

class LoadMoreUserFollowersModel: DataModel {
    
    var username: String = ""
    var perPage: NSNumber = defaultCountPerPage
    var since: String = "0"
    
    override func loadSignal() -> SignalProducer<AnyObject, NSError> {
        
        return assembly.requestManager.downloadUserFollowers(since: since, perPage: perPage, username: username).map({ users -> AnyObject in
            return users as AnyObject
        })
        
    }
}
