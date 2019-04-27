//
//  IncomingImageCellView.swift
//  IG Direct
//
//  Created by Daniel Lee on 4/24/19.
//  Copyright © 2019 Ctech. All rights reserved.
//

import Foundation
import Cocoa

class IncomingImageCellView : NSTableCellView {
    
    @IBOutlet weak var ivImage: NSImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.wantsLayer = true
        self.layer!.masksToBounds = true
        self.layer!.cornerRadius = 16;
        self.layer!.backgroundColor = ConstantColor.IMAGECELL_BACKGROUND
    }
    
    func bind(viewModel : ImageMessageViewModel) {
        ivImage.sd_setImage(with: URL(string: viewModel.payload.mediaUrl))
    }
}
