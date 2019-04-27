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
    let userName: String
    let thumbnail: String
        
    init(id: String, msgPreview: String, userName: String, thumbnail: String) {
        self.id = id
        self.msgPreview = msgPreview
        self.userName = userName
        self.thumbnail = thumbnail
    }
    
    init(map: Map) throws {
        id   = try map.value("id")
        msgPreview = try map.value("msgPreview")
        userName   = try map.value("userName")
        thumbnail = try map.value("thumbnail")
    }
    
    func mapping(map: Map) {
        id >>> map["id"]
        msgPreview >>> map["msgPreview"]
        userName >>> map["userName"]
        thumbnail >>> map["thumbnail"]
    }
    
}
