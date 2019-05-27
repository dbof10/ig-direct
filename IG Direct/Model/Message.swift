//
//  Message.swift
//  IG Direct
//
//  Created by Daniel Lee on 5/27/19.
//  Copyright © 2019 Ctech. All rights reserved.
//

import Foundation
import ObjectMapper

struct Message : ImmutableMappable {
    let id: String
    let senderId: Int
    let createdAt: Int
    let type: MessageType
    let payload: MessagePayload
    
    init(map: Map) throws {
        id   = try map.value("id")
        senderId = try map.value("senderId")
        createdAt   = try map.value("createdAt")
        type = try map.value("type")
        payload = try map.value("payload", using: MessagePayloadTransform(type: type))
    }
}

enum MessageType : RawRepresentable {
    
    typealias RawValue = String
    
    init(rawValue: RawValue) {
        switch rawValue {
        case "text": self = .text
        case "media": self = .media
        case "like": self = .like
        case "link": self = .link
        case "seen": self = .seen
        default:
            self = .unknown
        }
    }
    
    var rawValue: RawValue {
        switch self {
        case .text: return "text"
        case .media: return "media"
        case .like: return "like"
        case .link: return "link"
        case .seen: return "seen"
        default:
            return ""
        }
    }
    
    case text
    case media
    case like
    case link
    case seen
    case unknown
}

class MessagePayloadTransform : TransformType {
    
    private let type: MessageType
    init(type: MessageType) {
        self.type = type
    }
    
    public typealias Object = MessagePayload
    
    public typealias JSON = String
    
    func transformFromJSON(_ value: Any?) -> MessagePayload? {
        guard let payload = value as? [String: Any] else { return EmptyPayload() }
        switch type {
        case .text, .seen:
            return TextPayload(JSON: payload)
        case .media:
            return ImagePayload(JSON: payload)
        case .link:
            return LinkPayload(JSON: payload)
        default:
            return EmptyPayload()
        }
    }
    
    func transformToJSON(_ value: MessagePayload?) -> String? {
        return nil
    }
    
}
