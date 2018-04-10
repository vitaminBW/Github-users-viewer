//
//  ConnectivityManager.swift
//  Github users viewer
//
//  Created by Vitaliy Bal on 4/9/18.
//  Copyright © 2018 VitaliySoft. All rights reserved.
//

import UIKit
import Alamofire
import ReactiveSwift
import Result

protocol ConnectivityManagerProtocol: class {
    func isConnectedToInternet() -> Bool
    
    var status: MutableProperty<NetworkReachabilityManager.NetworkReachabilityStatus>{ get}
}

class ConnectivityManager: ConnectivityManagerProtocol {
    
    var status: MutableProperty<NetworkReachabilityManager.NetworkReachabilityStatus> = MutableProperty<NetworkReachabilityManager.NetworkReachabilityStatus>(.notReachable)
    var net = NetworkReachabilityManager()
    
    required init() {
        //let net = NetworkReachabilityManager()
        net?.startListening()
        self.net?.listener = { status in
            if self.net?.isReachable ?? false {
                
                switch status {
                    
                case .reachable(.ethernetOrWiFi):
                    print("The network is reachable over the WiFi connection")
                    self.status.value = status
                case .reachable(.wwan):
                    print("The network is reachable over the WWAN connection")
                    self.status.value = status
                case .notReachable:
                    print("The network is not reachable")
                    self.status.value = status
                case .unknown :
                    print("It is unknown whether the network is reachable")
                    
                }
            } else {
                self.status.value = NetworkReachabilityManager.NetworkReachabilityStatus.notReachable
            }
        }
    }
    
    func isConnectedToInternet() -> Bool {
        return NetworkReachabilityManager()!.isReachable
    }
    
}
