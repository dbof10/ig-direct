//
//  ChatItemViewModel.swift
//  IG Direct
//
//  Created by Daniel Lee on 4/19/19.
//  Copyright © 2019 Ctech. All rights reserved.
//

import Foundation

import ObjectMapper
import DeepDiff

struct ChatItemViewModel : DiffAware,  Equatable, Hashable  {
    public var diffId: Int {
        return hashValue
    }

    let id: String
    let msgPreview: String
    let userName: String
    let thumbnail: String
    
    static func compareContent(_ a: ChatItemViewModel, _ b: ChatItemViewModel) -> Bool {
        return a == b
    }
    
    static func == (lhs: ChatItemViewModel, rhs: ChatItemViewModel) -> Bool {
        return lhs.id == rhs.id && lhs.msgPreview == rhs.msgPreview
        && lhs.userName == rhs.userName && lhs.thumbnail == rhs.thumbnail
    }
}
