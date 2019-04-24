//
//  OutgoingImageCellView.swift
//  IG Direct
//
//  Created by Daniel Lee on 4/24/19.
//  Copyright © 2019 Ctech. All rights reserved.
//

import Foundation
import Cocoa

class OutgoingImageCellView : NSTableCellView {
    
    @IBOutlet weak var ivImage: NSImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        ivImage.wantsLayer = true
        ivImage.layer!.masksToBounds = true
        ivImage.layer!.cornerRadius = 16
        ivImage.layer!.backgroundColor = ConstantColor.IMAGECELL_BACKGROUND
    }
    
    func bind(viewModel : ImageMessageViewModel) {
        ivImage.sd_setImage(with: URL(string: viewModel.mediaUrl))
    }
}
