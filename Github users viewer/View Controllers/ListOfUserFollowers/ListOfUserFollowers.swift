//
//  ListOfUserFollowers.swift
//  Github users viewer
//
//  Created by Vitaliy Bal on 4/11/18.
//  Copyright © 2018 VitaliySoft. All rights reserved.
//

import UIKit
import ReactiveSwift
import Alamofire

class ListOfUserFollowers: BaseTableViewController<User, UserTableCell> {
    
    var username: String?
    
    private var statePresenter: StatePresenter!
    private var model: ListOfUserFollowersModel!
    private var loadMoreModel: LoadMoreUserFollowersModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = NSLocalizedString("ListOfUserFollowers:Title", comment: "")
        
        tableView.separatorStyle = .singleLine
        
        setupModel()
        
        if AssemblyManager.shared.connectivityManager.isConnectedToInternet() == true {
            self.model.load()
        }
        
        tableView.addInfiniteScroll { (tableView) -> Void in
            // update table view
            self.loadMoreModel.load()
        }
    }
    
    private func setupModel() {
        model = ListOfUserFollowersModel()
        model.username = username ?? ""
        loadMoreModel = LoadMoreUserFollowersModel()
        loadMoreModel.username = username ?? ""
        
        model.loadingSignal.observe(on: UIScheduler()).observe { [weak self] value in
            switch (value) {
            case let .value(object):
                if object == true {
                    DispatchQueue.main.async {
                        self?.statePresenter.showState(.loading)
                    }
                } else {
                    DispatchQueue.main.async {
                        self?.statePresenter.hideStates()
                    }
                }
            default:
                break;
            }
        }
        
        model.completedSignal.observe(on: UIScheduler()).observe { [weak self] value in
            switch (value) {
            case let .value(object):
                
                self?.createModel(items: object as? [User])
                
                if let items = object as? [User], let lastID = items.last?.ID {
                    self?.loadMoreModel.since = String(lastID.intValue)
                }
                
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
                print("[ListOfUserFollowers] - \(error)")
            default:
                break;
            }
        }
        
        //load more
        loadMoreModel.completedSignal.observe(on: UIScheduler()).observe { [weak self] value in
            switch (value) {
            case let .value(object):
                
                self?.addItemsToModel(items: object as? [User])
                
                if let items = object as? [User], let lastID = items.last?.ID {
                    self?.loadMoreModel.since = String(lastID.intValue)
                }
                
                DispatchQueue.main.async {
                    // finish infinite scroll animation
                    self?.tableView.finishInfiniteScroll()
                }
                
            default:
                break;
            }
        }
        
        statePresenter = StatePresenter(model: model, controller: self)
    }
    
    
}

