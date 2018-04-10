//
//  MapperProtocol.swift
//  Github users viewer
//
//  Created by Vitaliy Bal on 4/9/18.
//  Copyright © 2018 VitaliySoft. All rights reserved.
//

import Foundation
import SwiftyJSON

protocol MapperProtocol {
    associatedtype Value
    static func create(_ data: JSON) -> Value?
}
