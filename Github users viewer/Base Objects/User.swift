//
//  User.swift
//  Github users viewer
//
//  Created by Vitaliy Bal on 4/9/18.
//  Copyright © 2018 VitaliySoft. All rights reserved.
//

import UIKit
import SwiftyJSON

class User {
    
    var ID: String?
    var login: String?
    var avatarUrl: String?
    var gravatarId: String?
    var url: String?
    var htmlUrl: String?
    var followersUrl: String?
    var followingUrl: String?
    var gistsUrl: String?
    var starredUrl: String?
    var subscriptionsUrl: String?
    var organizationsUrl: String?
    var reposUrl: String?
    var eventsUrl: String?
    var receivedEventsUrl: String?
    var type: String?
    var siteAdmin: String?
    
}


extension User : MapperProtocol {
    typealias Value = User
    
    static func create(_ data: JSON) -> User? {
//        guard let userId = data["id"].string else {
//            return nil;
//        }

        let user = User()
        user.login = data["login"].string
        user.ID = data["id"].string
        user.avatarUrl = data["avatar_url"].string
        user.gravatarId = data["gravatar_id"].string
        user.url = data["url"].string
        user.htmlUrl = data["html_url"].string
        user.followersUrl = data["followers_url"].string
        user.followingUrl = data["following_url"].string
        user.gistsUrl = data["gists_url"].string
        user.starredUrl = data["starred_url"].string
        user.subscriptionsUrl = data["subscriptions_url"].string
        user.organizationsUrl = data["organizations_url"].string
        user.reposUrl = data["repos_url"].string
        user.eventsUrl = data["events_url"].string
        user.receivedEventsUrl = data["received_events_url"].string
        user.type = data["type"].string
        user.siteAdmin = data["site_admin"].string
        
        return user
    }
}
