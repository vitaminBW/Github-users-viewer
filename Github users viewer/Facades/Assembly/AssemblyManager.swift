//
//  AssemblyManager.swift
//  Github users viewer
//
//  Created by Vitaliy Bal on 4/9/18.
//  Copyright © 2018 VitaliySoft. All rights reserved.
//

import UIKit

class AssemblyManager {
    
    static let shared = AssemblyManager()
    
    var requestManager: APIRequestsManagerProtocol
    var routeManager: RouteManagerProtocol
    var connectivityManager: ConnectivityManagerProtocol
    
    private init() {
        
        requestManager = APIRequestsManager(serviceManager: APIRequestsService())
        routeManager = RouteManager()
        connectivityManager = ConnectivityManager()
    }
    
    func start(application: UIApplication, launchOptions: [UIApplicationLaunchOptionsKey: Any]?, window: UIWindow?) {
        routeManager.window = window
        
        self.routeManager.openMainController()
    }

}
