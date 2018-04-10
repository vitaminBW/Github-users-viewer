//
//  LoadMoreUsersModel.swift
//  Github users viewer
//
//  Created by Vitaliy Bal on 4/11/18.
//  Copyright © 2018 VitaliySoft. All rights reserved.
//

import UIKit
import ReactiveSwift

class LoadMoreUsersModel: DataModel {
    
    var perPage: NSNumber = defaultCountPerPage
    var since: String = "0"
    
    override func loadSignal() -> SignalProducer<AnyObject, NSError> {
        
        return assembly.requestManager.downloadUsers(since: since, perPage: perPage).map({ users -> AnyObject in
            return users as AnyObject
        })
        
    }
}
