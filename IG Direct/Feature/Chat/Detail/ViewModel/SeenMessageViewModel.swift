//
//  SeenMessageViewModel.swift
//  IG Direct
//
//  Created by Daniel Lee on 5/26/19.
//  Copyright © 2019 Ctech. All rights reserved.
//

import Foundation
import IGListKit

final class SeenMessageViewModel: BaseMessageViewModel {
    
    
    var id: String
    
    var senderId: Int
    
    var createdAt: Int
    
    var type: MessageType
    
    var direction: MessageDirection
    
    let payload: TextPayload
    
    init(id: String, payload: TextPayload) {
        self.id = id
        self.senderId = Int.min
        self.createdAt = Int.min
        self.type = MessageType.seen
        self.direction = MessageDirection.incoming
        self.payload = payload
    }
    
    static func == (lhs: SeenMessageViewModel, rhs: SeenMessageViewModel) -> Bool {
        return lhs.id == rhs.id && lhs.senderId == rhs.senderId
            && lhs.createdAt == rhs.createdAt && lhs.type == rhs.type &&
            lhs.direction == rhs.direction && lhs.payload == rhs.payload
    }
    
    func diffIdentifier() -> NSObjectProtocol {
        return id as NSObjectProtocol
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        guard self !== object else { return true }
        guard let object = object as? SeenMessageViewModel else { return false }
        return self == object
    }
    
}
