//
//  Chat.swift
//  IG Direct
//
//  Created by Daniel Lee on 4/19/19.
//  Copyright © 2019 Ctech. All rights reserved.
//

import Foundation
import ObjectMapper

struct Chat :  ImmutableMappable  {
    
    let id: String
    let msgPreview: String
    let account: [User]
    
    init(id: String, msgPreview: String, account: [User]) {
        self.id = id
        self.msgPreview = msgPreview
        self.account = account
    }
    
    init(map: Map) throws {
        id   = try map.value("id")
        msgPreview = try map.value("msgPreview")
        account   = try map.value("account")
    }
    
    func mapping(map: Map) {
        id >>> map["id"]
        msgPreview >>> map["msgPreview"]
        account >>> map["account"]
    }
    
}
