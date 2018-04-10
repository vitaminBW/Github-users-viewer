//
//  ListOfUsersModel.swift
//  Github users viewer
//
//  Created by Vitaliy Bal on 4/10/18.
//  Copyright © 2018 VitaliySoft. All rights reserved.
//

import UIKit
import ReactiveSwift

class ListOfUsersModel: DataModel {
    
    override func loadSignal() -> SignalProducer<AnyObject, NSError> {

        return assembly.requestManager.downloadUsers(since: "0", perPage: defaultCountPerPage).map({ users -> AnyObject in
            return users as AnyObject
        })

    }
}
