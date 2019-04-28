//
//  OutgoingLinkCellView.swift
//  IG Direct
//
//  Created by Daniel Lee on 4/27/19.
//  Copyright © 2019 Ctech. All rights reserved.
//

import Foundation
import Cocoa

class OutgoingLinkCellView : NSTableCellView {
    
    @IBOutlet weak var tvText: HyperlinkTextField!
    
    @IBOutlet weak var ivThumbnail: NSImageView!
    
    @IBOutlet weak var tvTitle: NSTextField!
    
    @IBOutlet weak var tvSummary: NSTextField!
    
    @IBOutlet weak var ivBackground: NSImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.ivBackground.wantsLayer = true
        self.ivBackground.layer!.masksToBounds = true
        self.ivBackground.layer!.cornerRadius = 16;
        self.ivBackground.layer!.backgroundColor = ConstantColor.IMAGECELL_BACKGROUND
    }
    
    func bind(viewModel: LinkMessageViewModel){
        tvText.setText(text: viewModel.payload.text)
        tvTitle.stringValue = viewModel.payload.title
        tvSummary.stringValue = viewModel.payload.summary
        ivThumbnail.sd_setImage(with: URL(string: viewModel.payload.mediaUrl))
    }
}
