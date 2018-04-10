//
//  BaseTableViewController.swift
//  Github users viewer
//
//  Created by Vitaliy Bal on 4/9/18.
//  Copyright © 2018 VitaliySoft. All rights reserved.
//

import Foundation
import UIKit
import ReactiveSwift
import Result

protocol TableObjectCellProtocol {
    associatedtype T
    func updateCellWithObject(object: T)
    static func heightFor(object: AnyObject, atIndexPath: IndexPath, tableView: UITableView) -> CGFloat
}


class BaseTableViewController<T, V:UITableViewCell & TableObjectCellProtocol> : BaseViewController, UITableViewDataSource, UITableViewDelegate where V.T == T {
    
    private(set) var tableViewController: UITableViewController = UITableViewController(style: .plain)
    
    var tableView: UITableView {
        get {
            return self.tableViewController.tableView
        }
    }
    
    var clearsSelectionOnViewWillAppear: Bool = true {
        didSet {
            tableViewController.clearsSelectionOnViewWillAppear = clearsSelectionOnViewWillAppear
        }
    }
    
    var itemsCount: NSNumber {
        get {
            return NSNumber(value: self.items?.count ?? 0)
        }
    }
    
    private var items: [T]?
    
    var actions: TableActions = TableActions()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addChildViewController(tableViewController)
        view.addSubview(tableViewController.view)
        tableViewController.clearsSelectionOnViewWillAppear = clearsSelectionOnViewWillAppear
        self.tableViewController.tableView.register(V.self, forCellReuseIdentifier: "Default")
        tableViewController.tableView.dataSource = self
        tableViewController.tableView.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tableViewController.view.frame = view.bounds
    }
    
    func createModel (items: [T]?) {
        self.items = items
        self.tableViewController.tableView.reloadData()
    }
    
    func addItemsToModel (items: [T]?) {
        if let newItems = items {
            for item in newItems {
                self.items?.append(item)
            }
            self.tableViewController.tableView.reloadData()
        }
    }
    
    // Delegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items?.count ?? 0
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "Default", for: indexPath) as? V
        
        if let o = cell {
            cell = o
        } else {
            cell = V(style: .default, reuseIdentifier: "Default")
        }
        
        cell?.actions = self.actions
        
        if let item = self.items?[indexPath.row] {
            cell?.updateCellWithObject(object: item)
        }
        
        return cell!
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let items = self.items, items.count > indexPath.row {
            actions.sendAction(TableActionEnum.Selected.rawValue, object: items[indexPath.row] as AnyObject )
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let items = self.items, items.count > indexPath.row {
            let object = items[indexPath.row] as AnyObject
            return V.self.heightFor(object: object, atIndexPath: indexPath, tableView: tableView)
        }
        return 90
    }
    
}
