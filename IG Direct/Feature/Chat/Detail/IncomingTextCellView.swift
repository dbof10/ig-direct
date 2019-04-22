//
//  IncomingTextCellView.swift
//  IG Direct
//
//  Created by Daniel Lee on 4/21/19.
//  Copyright © 2019 Ctech. All rights reserved.
//

import Foundation
import Cocoa

class IncomingTextCellView: NSTableCellView {
    

    @IBOutlet weak var tvText: NSTextField!
    
    func bind(viewModel : TextMessageViewModel) {
        tvText.stringValue = viewModel.text
    }
}
