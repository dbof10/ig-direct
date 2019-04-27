//
//  LinkMessageViewModel.swift
//  IG Direct
//
//  Created by Daniel Lee on 4/26/19.
//  Copyright © 2019 Ctech. All rights reserved.
//

import Foundation

struct LinkMessageViewModel : BaseMessageViewModel {
    var id: String
    
    var senderId: Int64
    
    var createdAt: Int64
    
    var type: MessageType
    
    var isSeen: String
    
    var direction: MessageDirection
    
    let payload: LinkPayload
    
}
