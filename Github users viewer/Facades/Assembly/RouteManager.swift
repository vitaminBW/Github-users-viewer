//
//  RouteManager.swift
//  Github users viewer
//
//  Created by Vitaliy Bal on 4/9/18.
//  Copyright © 2018 VitaliySoft. All rights reserved.
//

import UIKit
import ReactiveSwift
import Result

protocol RouteManagerProtocol {
    var window: UIWindow? {get set}
    
    func openMainController()

}

class RouteManager: RouteManagerProtocol {
    
    var window: UIWindow?
    
    required init(window: UIWindow? = nil) {
        self.window = window
    }
    
    func openMainController() {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let initialVC = mainStoryboard.instantiateInitialViewController()
        window?.rootViewController = initialVC
    }

}
