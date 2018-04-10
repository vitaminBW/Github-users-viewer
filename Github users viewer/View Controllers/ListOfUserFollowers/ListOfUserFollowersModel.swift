//
//  ListOfUserFollowersModel.swift
//  Github users viewer
//
//  Created by Vitaliy Bal on 4/11/18.
//  Copyright © 2018 VitaliySoft. All rights reserved.
//

import Foundation
import ReactiveSwift

class ListOfUserFollowersModel: DataModel {
    
    var username: String = ""
    
    override func loadSignal() -> SignalProducer<AnyObject, NSError> {
        
        return assembly.requestManager.downloadUserFollowers(since: "0", perPage: defaultCountPerPage, username: username).map({ users -> AnyObject in
            return users as AnyObject
        })
        
    }
}
