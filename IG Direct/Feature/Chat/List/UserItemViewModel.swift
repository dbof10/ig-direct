//
//  UserItemViewModel.swift
//  IG Direct
//
//  Created by Daniel Lee on 5/13/19.
//  Copyright © 2019 Ctech. All rights reserved.
//

import Foundation
import ObjectMapper
import IGListKit

final class UserItemViewModel : ChatListItemViewModel {
    
    let id: String
    let msgPreview: String
    let userName: String
    let thumbnail: String
    let newChat: Bool = true
    
    init(user: User) {
        self.id = String(user.id)
        self.msgPreview = "Send a message"
        self.userName = user.username
        self.thumbnail = user.profilePicUrl
    }
    
    static func == (lhs: UserItemViewModel, rhs: UserItemViewModel) -> Bool {
        return lhs.id == rhs.id && lhs.msgPreview == rhs.msgPreview
            && lhs.userName == rhs.userName && lhs.thumbnail == rhs.thumbnail
    }
    
    
    func diffIdentifier() -> NSObjectProtocol {
        return id as NSObjectProtocol
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        guard self !== object else { return true }
        guard let object = object as? UserItemViewModel else { return false }
        return self == object
    }
}
