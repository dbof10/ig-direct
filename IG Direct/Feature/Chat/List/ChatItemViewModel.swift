//
//  ChatItemViewModel.swift
//  IG Direct
//
//  Created by Daniel Lee on 4/19/19.
//  Copyright © 2019 Ctech. All rights reserved.
//

import Foundation

import ObjectMapper
import IGListKit

final class ChatItemViewModel : ListDiffable {

    
    let id: String
    let msgPreview: String
    let userName: String
    let thumbnail: String
    
    init(id: String, msgPreview: String, userName: String, thumbnail: String) {
        self.id = id
        self.msgPreview = msgPreview
        self.userName = userName
        self.thumbnail = thumbnail
    }
    
    static func == (lhs: ChatItemViewModel, rhs: ChatItemViewModel) -> Bool {
        return lhs.id == rhs.id && lhs.msgPreview == rhs.msgPreview
        && lhs.userName == rhs.userName && lhs.thumbnail == rhs.thumbnail
    }
    
    
    func diffIdentifier() -> NSObjectProtocol {
        return id as NSObjectProtocol
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        guard self !== object else { return true }
        guard let object = object as? ChatItemViewModel else { return false }
        return self == object
    }
}
