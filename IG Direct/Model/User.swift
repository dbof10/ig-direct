//
//  User.swift
//  IG Direct
//
//  Created by Daniel Lee on 4/6/19.
//  Copyright © 2019 Ctech. All rights reserved.
//
import ObjectMapper

struct User : ImmutableMappable {
  
    let id: Int
    let username: String
    let fullName: String
    let profilePicUrl: String
    
    static let ANONYMOUS = User(id: 0,username: "", fullName: "", profilePicUrl: "")
    
    init(id: Int, username: String, fullName: String, profilePicUrl: String) {
        self.id = id
        self.username = username
        self.fullName = fullName
        self.profilePicUrl = profilePicUrl
    }
    
    init(map: Map) throws {
        id   = try map.value("id")
        username = try map.value("username")
        fullName   = try map.value("fullName")
        profilePicUrl = try map.value("profilePicUrl")
    }
    
    func mapping(map: Map) {
        id >>> map["id"]
        username >>> map["username"]
        fullName >>> map["fullName"]
        profilePicUrl >>> map["profilePicUrl"]
    }
    
}
