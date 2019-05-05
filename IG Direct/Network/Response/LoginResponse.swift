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
struct LoginResponse: ImmutableMappable {
    
    let token: String
    let user: User
    
    init(token: String, user: User) {
        self.token = token
        self.user = user
    }
    
    init(map: Map) throws {
        token = try map.value("token")
        user = try map.value("user")
    }
    
    func mapping(map: Map) {
        token >>> map["token"]
        user >>> map["user"]
    }
    
}
