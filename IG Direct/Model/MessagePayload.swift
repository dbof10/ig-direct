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

struct TextPayload: MessagePayload, ImmutableMappable , Equatable {
    let text: String
    
    init(map: Map) throws {
        text  = try map.value("text")
    }
    
    static func == (lhs: TextPayload, rhs: TextPayload) -> Bool {
        return lhs.text == rhs.text
    }
}

struct ImagePayload : MessagePayload, ImmutableMappable, Equatable {
    let mediaUrl: String
    
    init(map: Map) throws {
        mediaUrl  = try map.value("mediaUrl")
    }
    
    static func == (lhs: ImagePayload, rhs: ImagePayload) -> Bool {
        return lhs.mediaUrl == rhs.mediaUrl
    }
}

struct LinkPayload: MessagePayload, ImmutableMappable, Equatable  {
    
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
    
    
    static func == (lhs: LinkPayload, rhs: LinkPayload) -> Bool {
        return lhs.mediaUrl == rhs.mediaUrl && lhs.text == rhs.text
            && lhs.title == rhs.title && lhs.summary == rhs.summary
    }
    
}
