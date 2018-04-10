
//
//  TableAction.swift
//  Github users viewer
//
//  Created by Vitaliy Bal on 4/9/18.
//  Copyright © 2018 VitaliySoft. All rights reserved.
//

import Foundation
import ReactiveSwift
import ObjectiveC
import Result

enum TableActionEnum: String, CustomStringConvertible {
    case Unknown = "Unknown"
    case Selected = "Selected"

    var description : String {
        return String(describing: self)
    }
}

class TableActionPipe<T>: Hashable, Equatable {
    var output: Signal<T, NoError>
    var input: Signal<T, NoError>.Observer

    private let hash: String = { return NSUUID().uuidString.lowercased() }()

    var hashValue: Int {
        get {
            return hash.hashValue
        }
    }

    init(output: Signal<T, NoError>, input: Signal<T, NoError>.Observer) {
        self.output = output
        self.input = input
    }

    static func ==(lhs: TableActionPipe, rhs: TableActionPipe) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
}

class TableActions {

    private var signals = Dictionary<String, TableActionPipe<AnyObject?>>()

    private func createPipeIfNeeded(action: String) -> TableActionPipe<AnyObject?> {
        var pipe = signals[action]
        if pipe == nil {
            let (output, input) = Signal<AnyObject?, NoError>.pipe()
            pipe = TableActionPipe(output:output, input: input)
            signals[action] = pipe
        }
        return pipe!
    }

    @discardableResult
    func registerAction(_ action: String) -> Signal<AnyObject?, NoError> {
        let pipe = createPipeIfNeeded(action: action)
        return pipe.output
    }


    @discardableResult
    func registerAction(_ action: String, handler: @escaping (AnyObject?) -> Void ) -> Bool {
        let pipe = createPipeIfNeeded(action: action)
        pipe.output.observe(on: UIScheduler()).observe { event in
            switch event {
            case let .value(value):
                handler(value)
            default:
                break;
            }
        }

        return false
    }

    @discardableResult
    func sendAction(_ action: String, object: AnyObject? ) -> Bool {
        let pipe = signals[action]
        if let pipe = pipe {
            pipe.input.send(value: object)
            return true
        }
        return false
    }

}


extension UITableViewCell {
    private struct AssociatedKeys {
        static var actions = "actions"
    }

    var actions: TableActions? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.actions) as? TableActions
        }
        set {
            if let newValue = newValue {
                objc_setAssociatedObject(
                        self,
                        &AssociatedKeys.actions,
                        newValue as TableActions?,
                        .OBJC_ASSOCIATION_ASSIGN
                )
            }
        }
    }
}
