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
    
    var loadingSignal: Signal<Bool, NoError> {get}
    var errorSignal: Signal<NSError, NoError> {get}
    var completedSignal: Signal<AnyObject, NoError> {get}
    
    func load()
    func cancel()
    
}

class DataModel: DataModelProtocol {
    
    var loadingSignal: Signal<Bool, NoError> {
        get {
            return loadingSubject
        }
    }
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
    
    private var (loadingSubject, loadingObserver) = Signal<Bool, NoError>.pipe()
    private var (errorSubject, errorObserver) = Signal<NSError, NoError>.pipe()
    private var (completedSubject, completedObserver) = Signal<AnyObject, NoError>.pipe()
    
    var disposable: Disposable?
    
    func loadSignal() -> SignalProducer<AnyObject, NSError> {
        return SignalProducer.empty
    }
    
    func load() {
        self.cancel()
        
        self.loadingObserver.send(value: true)
        
        self.disposable = self.loadSignal().startWithResult { [weak self] result in
            switch result {
            case let .success(object):
                self?.loadingObserver.send(value: false)
                self?.completedObserver.send(value: object)
            case let .failure(error):
                self?.loadingObserver.send(value: false)
                self?.errorObserver.send(value: error)
            }
        }
    }
    
    
    func cancel() {
        self.disposable?.dispose()
        self.loadingObserver.send(value: false)
    }
    
}
