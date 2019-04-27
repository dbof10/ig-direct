//
//  MessagePayload.swift
//  IG Direct
//
//  Created by Daniel Lee on 4/26/19.
//  Copyright © 2019 Ctech. All rights reserved.
//

import Foundation
import ObjectMapper

protocol MessagePayload {
    
}

struct EmptyPayload: MessagePayload {
    
}

struct TextPayload: MessagePayload, ImmutableMappable {
    let text: String
    
    init(map: Map) throws {
        text  = try map.value("text")
    }
}

struct ImagePayload : MessagePayload, ImmutableMappable {
    let mediaUrl: String
    
    init(map: Map) throws {
        mediaUrl  = try map.value("mediaUrl")
    }
}

struct LinkPayload: MessagePayload, ImmutableMappable  {
    
    let mediaUrl: String
    let text: String
    let title: String
    let summary: String
    
    init(map: Map) throws {
        mediaUrl  = try map.value("mediaUrl")
        text  = try map.value("text")
        title  = try map.value("title")
        summary  = try map.value("summary")
    }
}
