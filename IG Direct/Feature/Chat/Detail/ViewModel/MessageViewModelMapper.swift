//
//  MessageViewModelMapper.swift
//  IG Direct
//
//  Created by Daniel Lee on 4/21/19.
//  Copyright © 2019 Ctech. All rights reserved.
//

import Foundation

class MessageViewModelMapper {
    
    private let userSecret: UserSecretManager
    
    init(_ userSecret: UserSecretManager) {
        self.userSecret = userSecret
    }
    
    func toViewModel(messages : [Message]) -> [BaseMessageViewModel] {
        return messages.map {
            let type = $0.type
            let direction: MessageDirection
            if userSecret.getUserBlocking().id == $0.senderId {
                direction = MessageDirection.outgoing
            } else {
                direction = MessageDirection.incoming
            }
            switch type {
            case .text:
                return TextMessageViewModel(id: $0.id, senderId: $0.senderId, createdAt: $0.createdAt,
                                            type: $0.type , direction: direction,
                                            payload: $0.payload as! TextPayload)
                
            case .media:
                return ImageMessageViewModel(id: $0.id, senderId: $0.senderId, createdAt: $0.createdAt,
                                             type: $0.type, direction: direction,
                                             payload: $0.payload as! ImagePayload)
            case .like:
                return LikeMessageViewModel(id: $0.id , senderId: $0.senderId, createdAt: $0.createdAt
                    , type: $0.type , direction: direction)
            case .link:
                return LinkMessageViewModel(id: $0.id , senderId: $0.senderId, createdAt: $0.createdAt,
                                            type: $0.type, direction: direction,
                      payload: $0.payload as! LinkPayload)
                
            case .seen:
                return SeenMessageViewModel(id: $0.id, payload: $0.payload as! TextPayload)
                
            default:
                return UnsupportMessageViewModel(id: $0.id, senderId: $0.senderId,
                                                 createdAt: $0.createdAt,
                                                 type: $0.type, direction: direction)
            }
        }
    }
}
