//
//  ChatDetailViewController.swift
//  IG Direct
//
//  Created by Daniel Lee on 4/21/19.
//  Copyright © 2019 Ctech. All rights reserved.
//

import Foundation
import Cocoa


class ChatDetailViewController: NSViewController {
    
    
    var viewModel: ChatDetailViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func chatSelected(item: ChatItemViewModel) {
        viewModel.onItemSelected(item)
    }
}
