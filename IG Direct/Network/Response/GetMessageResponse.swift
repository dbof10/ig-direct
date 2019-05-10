//
//  GetMessageResponse.swift
//  IG Direct
//
//  Created by Daniel Lee on 5/5/19.
//  Copyright © 2019 Ctech. All rights reserved.
//

import Foundation
import ObjectMapper

// MARK: Initializer and Properties
struct GetMessageResponse: ImmutableMappable {
    
    let messages: [BaseMessage]
    let isSeen: String?
    
    init(map: Map) throws {
        messages = try map.value("messages")
        isSeen = try? map.value("isSeen")
    }
    
    func mapping(map: Map) {
        messages >>> map["messages"]
        isSeen >>> map["isSeen"]
    }
    
}
