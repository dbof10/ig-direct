//
//  LoginResponse.swift
//  IG Direct
//
//  Created by Daniel Lee on 4/16/19.
//  Copyright © 2019 Ctech. All rights reserved.
//

import Foundation
import ObjectMapper

// MARK: Initializer and Properties
struct LoginResponse: Mappable {
    
    var session: String!
    
    // MARK: JSON
    init?(map: Map) { }
    
    mutating func mapping(map: Map) {
        session <- map["session"]
    }
    
}
