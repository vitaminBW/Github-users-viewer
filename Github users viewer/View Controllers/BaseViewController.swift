//
//  BaseViewController.swift
//  Github users viewer
//
//  Created by Vitaliy Bal on 4/9/18.
//  Copyright © 2018 VitaliySoft. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

}

extension UIViewController {
    var assembly: AssemblyManager {
        get {return AssemblyManager.shared}
    }
}

extension UIView {
    var assembly: AssemblyManager {
        get {return AssemblyManager.shared}
    }
}

extension DataModel {
    var assembly: AssemblyManager {
        get {return AssemblyManager.shared}
    }
}
