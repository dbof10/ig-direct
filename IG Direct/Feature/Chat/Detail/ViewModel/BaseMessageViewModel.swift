//
//  BaseMessageViewModel.swift
//  IG Direct
//
//  Created by Daniel Lee on 4/21/19.
//  Copyright © 2019 Ctech. All rights reserved.
//

import Foundation
import IGListKit

protocol BaseMessageViewModel: ListDiffable  {
    var id: String {get}
    var senderId: Int {get}
    var createdAt: Int {get}
    var type: MessageType {get}
    var direction: MessageDirection { get }
}

enum MessageDirection {
    case incoming
    case outgoing
}
