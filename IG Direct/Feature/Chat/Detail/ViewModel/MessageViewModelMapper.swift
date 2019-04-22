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
    
    func toViewModel(messages : [BaseMessage]) -> [BaseMessageViewModel] {
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
                                            type: $0.type, isSeen: $0.isSeen , direction: direction, text: $0.text!)
                
            case .media:
                return TextMessageViewModel(id: $0.id, senderId: $0.senderId, createdAt: $0.createdAt,
                                            type: $0.type, isSeen: $0.isSeen , direction: direction, text: $0.text!)
                
            default:
            return UnsupportMessageViewModel(id: $0.id, senderId: $0.senderId,
                                             createdAt: $0.createdAt,
                                             type: $0.type, isSeen: $0.isSeen , direction: direction)
            }
        }
    }
}
