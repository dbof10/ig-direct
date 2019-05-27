//
//  SeenCellView.swift
//  IG Direct
//
//  Created by Daniel Lee on 5/27/19.
//  Copyright © 2019 Ctech. All rights reserved.
//

import Foundation
import Cocoa

class SeenCellView: NSTableCellView {
    
    
    @IBOutlet weak var tvText: NSTextField!
    
    func bind(viewModel : SeenMessageViewModel) {
        tvText.stringValue = viewModel.payload.text
    }
}

