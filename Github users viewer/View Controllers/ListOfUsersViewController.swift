//
//  ViewController.swift
//  Github users viewer
//
//  Created by Vitaliy Bal on 4/9/18.
//  Copyright © 2018 VitaliySoft. All rights reserved.
//

import UIKit
import ReactiveSwift
import Alamofire

class ListOfUsersViewController: BaseTableViewController<User, UserTableCell> {
    
    private var statePresenter: StatePresenter!
    private var model: ListOfUsersModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = NSLocalizedString("ListOfUsers:Title", comment: "")

        tableView.separatorStyle = .singleLine
        
        setupModel()
        registryHandlers()
        
        if AssemblyManager.shared.connectivityManager.isConnectedToInternet() == true {
            self.model.load()
            self.statePresenter.showState(.loading)
        }
    }
    
    private func setupModel() {
        model = ListOfUsersModel()
        
        model.completedSignal.observe(on: UIScheduler()).observe { [weak self] value in
            switch (value) {
            case let .value(object):

                self?.createModel(items: object as? [User])
                
                if let value = object as? Array<Any>, value.count == 0 {
                    self?.statePresenter?.showState(.nodata)
                } else {
                    self?.statePresenter?.hideStates()
                }

            default:
                break;
            }
        }
        
        model.errorSignal.observe(on: UIScheduler()).observe { [weak self] value in
            switch (value) {
            case let .value(object):
                let error = object
                self?.statePresenter.showState(.error(error: error))
            case let .failed(error):
                print("[ListOfUsersViewController] - \(error)")
            default:
                break;
            }
        }
        
        statePresenter = StatePresenter(model: model, controller: self)
    }
    
    private func registryHandlers() {
        actions.registerAction(TableActionEnum.Selected.rawValue)
            .observeValues { value in
                if let user = value as? User {
                    print("Open user: \(String(describing: user.login))")
                }
            }

    }



}

