//
//  ChatItemCellView.swift
//  IG Direct
//
//  Created by Daniel Lee on 4/19/19.
//  Copyright © 2019 Ctech. All rights reserved.
//

import Foundation

import Cocoa
import SDWebImage
class ChatItemCellView: NSTableCellView {
    
    
    @IBOutlet weak var ivAvatar: NSImageView!
    
    @IBOutlet weak var tvUserName: NSTextField!
    
    @IBOutlet weak var tvMsgPreview: NSTextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        ivAvatar.wantsLayer = true
        ivAvatar.layer!.masksToBounds = true
        ivAvatar.layer!.cornerRadius = ivAvatar.bounds.height / 2;

    }
    
    func bind(viewModel : ChatItemViewModel) {
        ivAvatar.sd_setImage(with: URL(string: viewModel.thumbnail))
        tvUserName.stringValue = viewModel.userName
        tvMsgPreview.stringValue = viewModel.msgPreview
    }
}
