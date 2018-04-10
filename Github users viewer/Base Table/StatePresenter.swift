//
//  StatePresenter.swift
//  Github users viewer
//
//  Created by Vitaliy Bal on 4/9/18.
//  Copyright © 2018 VitaliySoft. All rights reserved.
//

import Foundation
import UIKit
import ReactiveSwift
import SVProgressHUD

enum StatePresenterType {
    case loading
    case error(error: Error)
    case nodata
}

protocol StatePresenterProtocol: class {
    
    func getController() -> UIViewController?
    func getModel() -> DataModelProtocol?
    
    func showState(_ type: StatePresenterType)
    func hideStates()
    
}

class StatePresenter : StatePresenterProtocol {
    
    private(set) var model: DataModelProtocol?
    private(set) weak var controller: UIViewController?
    private var emptyState: EmptyStateView?
    
    var container: UIView = UIView()
    var loadingView: UIView = UIView()
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    init(model: DataModelProtocol?, controller: UIViewController) {
        self.model = model
        self.controller = controller
        
        // Setup container mask of activityIndicator view
        container.frame = controller.view.frame
        container.center = controller.view.center
        container.backgroundColor = UIColor.clear //white.withAlphaComponent(0.3)
        
        // Setup loadingView of activityIndicator
        loadingView.frame = CGRect(origin: CGPoint(x: 0,y :0), size: CGSize(width: 80, height: 80))
        loadingView.backgroundColor = UIColor.gray
        loadingView.clipsToBounds = true
        loadingView.layer.cornerRadius = 10
        
        // Setup activityIndicator
        activityIndicator.frame = CGRect(origin: CGPoint(x: 0,y :0), size: CGSize(width: 40, height: 40))
        activityIndicator.activityIndicatorViewStyle =
            UIActivityIndicatorViewStyle.whiteLarge
        
        
        
        SVProgressHUD.setDefaultStyle(.dark)
        SVProgressHUD.setDefaultMaskType(.black)
        SVProgressHUD.setMaxSupportedWindowLevel(UIWindowLevelAlert)
        SVProgressHUD.setOffsetFromCenter(.init(horizontal: 0, vertical: -70))
        
//        self.model?.loadingSignal.observe(on: UIScheduler()).observe { [weak self] value in
//            switch (value) {
//            case let .value(object):
//                if object == true {
//                    self?.showState(.loading)
//                } else {
//                    self?.hideStates()
//                }
//            default:
//                break;
//            }
//        }
        
        self.model?.completedSignal.observe(on: UIScheduler()).observe { [weak self] value in
            switch (value) {
            case let .value(object):
                self?.hideStates()
                if let value = object as? Array<Any>, value.count == 0 {
                    self?.showState(.nodata)
                }
            default:
                break
            }
        }
    }
    
    func showState(_ type: StatePresenterType) {
        SVProgressHUD.setContainerView(self.controller?.view)
        switch type {
        case .loading:
            //SVProgressHUD.show()
            if let view = self.controller?.view {
                showActivityIndicatory(uiView: view)
            }
        case let .error(error):
            SVProgressHUD.showError(withStatus: error.localizedDescription)
        case .nodata:
            showNoData()
        }
    }
    
    func showActivityIndicatory(uiView: UIView) {
        // Change container position
        var modifyRect = uiView.frame
        container.center = uiView.center
        
        if modifyRect.origin.y > 0 {
            modifyRect.origin.y = 0
            container.center.y = uiView.center.y + modifyRect.origin.y
        }
        container.frame = modifyRect
        
        // Change loadingView position
        let yPosition = uiView.center.y - 80
        loadingView.center = CGPoint(x: uiView.center.x ,y :yPosition) //uiView.center
        
        // Change activityIndicator position
        activityIndicator.center = CGPoint(x: loadingView.frame.size.width / 2,y :loadingView.frame.size.height / 2)
        
        // Show HUD
        loadingView.addSubview(activityIndicator)
        container.addSubview(loadingView)
        uiView.addSubview(container)
        activityIndicator.startAnimating()
    }
    
    func hideActivityIndicator(uiView: UIView) {
        activityIndicator.stopAnimating()
        container.removeFromSuperview()
    }
    
    func hideStates() {
        if let view = self.controller?.view {
            hideActivityIndicator(uiView: view)
        }
        emptyState?.hideAnimation()
        
        //        SVProgressHUD.dismiss()
    }
    
    func getController() -> UIViewController? {
        return controller
    }
    
    
    func getModel() -> DataModelProtocol? {
        return model
    }
    
    private func showNoData() {
        if let view = self.controller?.view {
            emptyState = EmptyStateView(message: NSLocalizedString("General:Nodata:Error", comment: ""))
            emptyState?.handler = { [weak self] in
                    self?.model?.load()
            }
            emptyState?.startAnimation(inView: view, animated: true)
        }
    }
}
