//
//  IncomingLinkCellView.swift
//  IG Direct
//
//  Created by Daniel Lee on 4/26/19.
//  Copyright © 2019 Ctech. All rights reserved.
//

import Foundation
import Cocoa

class IncomingLinkCellView: NSTableCellView {
    
    
    @IBOutlet weak var tvText: HyperlinkTextField!
    @IBOutlet weak var ivThumbnail: NSImageView!
    
    @IBOutlet weak var tvTitle: NSTextField!
    
    @IBOutlet weak var tvSummary: NSTextField!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.wantsLayer = true
        self.layer!.masksToBounds = true
        self.layer!.cornerRadius = 16;
        self.layer!.backgroundColor = ConstantColor.IMAGECELL_BACKGROUND
        
    }
    
    func bind(viewModel: LinkMessageViewModel){
        tvTitle.stringValue = viewModel.payload.title
        tvSummary.stringValue = viewModel.payload.summary
        ivThumbnail.sd_setImage(with: URL(string: viewModel.payload.mediaUrl))
        tvText.setText(text: viewModel.payload.text)
    }
}
