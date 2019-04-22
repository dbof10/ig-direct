//
//  BaseMessageViewModel.swift
//  IG Direct
//
//  Created by Daniel Lee on 4/21/19.
//  Copyright © 2019 Ctech. All rights reserved.
//

import Foundation

protocol BaseMessageViewModel  {
    var id: String {get}
    var senderId: Int64 {get}
    var createdAt: Int64 {get}
    var type: MessageType {get}
    var isSeen: String {get}
    var direction: MessageDirection { get }
}

enum MessageDirection {
    case incoming
    case outgoing
}
