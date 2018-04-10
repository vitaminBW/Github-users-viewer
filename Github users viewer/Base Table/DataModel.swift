//
//  DataModel.swift
//  Github users viewer
//
//  Created by Vitaliy Bal on 4/9/18.
//  Copyright © 2018 VitaliySoft. All rights reserved.
//

import Foundation
import ReactiveSwift
import Result

protocol DataModelProtocol {
    
    var errorSignal: Signal<NSError, NoError> {get}
    var completedSignal: Signal<AnyObject, NoError> {get}
    
    func load()
    func cancel()
    
}

class DataModel: DataModelProtocol {
    
    var errorSignal: Signal<NSError, NoError> {
        get {
            return errorSubject
        }
    }
    var completedSignal: Signal<AnyObject, NoError> {
        get {
            return completedSubject
        }
    }
    
    private var (errorSubject, errorObserver) = Signal<NSError, NoError>.pipe()
    private var (completedSubject, completedObserver) = Signal<AnyObject, NoError>.pipe()
    
    var disposable: Disposable?
    
    func loadSignal() -> SignalProducer<AnyObject, NSError> {
        return SignalProducer.empty
    }
    
    func load() {
        self.cancel()
        
        self.disposable = self.loadSignal().startWithResult { [weak self] result in
            switch result {
            case let .success(object):
                self?.completedObserver.send(value: object)
            case let .failure(error):
                self?.errorObserver.send(value: error)
            }
        }
    }
    
    
    func cancel() {
        self.disposable?.dispose()
    }
    
}
