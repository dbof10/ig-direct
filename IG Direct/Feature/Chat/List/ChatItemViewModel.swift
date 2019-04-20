//
//  ChatItemViewModel.swift
//  IG Direct
//
//  Created by Daniel Lee on 4/19/19.
//  Copyright © 2019 Ctech. All rights reserved.
//

import Foundation

import ObjectMapper

struct ChatItemViewModel :  Equatable  {
    
    let id: String
    let msgPreview: String
    let userName: String
    let thumbnail: String
    
    
    static func == (lhs: ChatItemViewModel, rhs: ChatItemViewModel) -> Bool {
        return lhs.id == rhs.id &&
            lhs.msgPreview == rhs.msgPreview &&
            lhs.userName == rhs.userName &&
            lhs.thumbnail == rhs.thumbnail
    }
}
