//
//  BaseMessage.swift
//  IG Direct
//
//  Created by Daniel Lee on 4/21/19.
//  Copyright © 2019 Ctech. All rights reserved.
//

import Foundation
import ObjectMapper

struct BaseMessage : ImmutableMappable {
    let id: String
    let senderId: Int64
    let createdAt: Int64
    let type: MessageType
    let isSeen: String
    let text: String?
    let mediaUrl: String?
    
    init(map: Map) throws {
        id   = try map.value("id")
        senderId = try map.value("senderId")
        createdAt   = try map.value("createdAt")
        type = try map.value("type")
        isSeen   = try map.value("isSeen")
        text = try? map.value("text")
        mediaUrl = try? map.value("mediaUrl")
    }
}

enum MessageType : RawRepresentable{
  
    
    typealias RawValue = String
    
    init(rawValue: RawValue) {
        switch rawValue {
        case "text": self = .text
        case "media": self = .media
        default:
           self = .unknown
        }
    }
    
    var rawValue: RawValue {
        switch self {
        case .text: return "text"
        case .media: return "media"
        default:
            return ""
        }
    }
    
    case text
    case media
    case unknown
}
