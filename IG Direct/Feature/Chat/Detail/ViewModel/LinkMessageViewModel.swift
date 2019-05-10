//
//  LinkMessageViewModel.swift
//  IG Direct
//
//  Created by Daniel Lee on 4/26/19.
//  Copyright © 2019 Ctech. All rights reserved.
//

import Foundation
import IGListKit

final class LinkMessageViewModel : BaseMessageViewModel {
    var id: String
    
    var senderId: Int
    
    var createdAt: Int
    
    var type: MessageType
        
    var direction: MessageDirection
    
    let payload: LinkPayload
    
    
    init(id: String, senderId: Int, createdAt: Int, type: MessageType, direction: MessageDirection, payload: LinkPayload) {
        self.id = id
        self.senderId = senderId
        self.createdAt = createdAt
        self.type = type
        self.direction = direction
        self.payload = payload
    }
    
    static func == (lhs: LinkMessageViewModel, rhs: LinkMessageViewModel) -> Bool {
        return lhs.id == rhs.id && lhs.senderId == rhs.senderId
            && lhs.createdAt == rhs.createdAt && lhs.type == rhs.type &&
            lhs.direction == rhs.direction && lhs.payload == rhs.payload
    }
    
    
    func diffIdentifier() -> NSObjectProtocol {
        return id as NSObjectProtocol
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        guard self !== object else { return true }
        guard let object = object as? LinkMessageViewModel else { return false }
        return self == object
    }
}
