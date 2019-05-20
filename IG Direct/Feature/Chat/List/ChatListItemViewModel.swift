//
//  ChatListItemViewModel.swift
//  IG Direct
//
//  Created by Daniel Lee on 5/13/19.
//  Copyright © 2019 Ctech. All rights reserved.
//

import Foundation
import IGListKit

protocol ChatListItemViewModel : ListDiffable {
    var id: String { get }
    var msgPreview: String { get }
    var userName: String { get }
    var thumbnail: String { get }
    var newChat: Bool{ get } 
}
