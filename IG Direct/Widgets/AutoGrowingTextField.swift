//
//  AutoGrowingTextField.swift
//  IG Direct
//
//  Created by Daniel Lee on 4/27/19.
//  Copyright © 2019 Ctech. All rights reserved.
//

import Foundation
import Cocoa

@IBDesignable
class AutoGrowingTextField: NSTextField {
    
    @IBInspectable
    let minHeight: CGFloat = 24
    
    @IBInspectable
    let bottomSpace: CGFloat = 6
    // magic number! (the field editor TextView is offset within the NSTextField. It’s easy to get the space above (it’s origin), but it’s difficult to get the default spacing for the bottom, as we may be changing the height
    
    private var heightLimit: CGFloat?
    private var lastSize: NSSize?
    private var isEditing = false
    
    override func textDidBeginEditing(_ notification: Notification) {
        super.textDidBeginEditing(notification)
        isEditing = true
    }
    
    override func textDidEndEditing(_ notification: Notification) {
        super.textDidEndEditing(notification)
        isEditing = false
    }
    
    override func textDidChange(_ notification: Notification) {
        super.textDidChange(notification)
        self.invalidateIntrinsicContentSize()
    }
    
    override var intrinsicContentSize: NSSize {
        var minSize: NSSize {
            var size = super.intrinsicContentSize
            size.height = minHeight
            return size
        }
        // Only update the size if we’re editing the text, or if we’ve not set it yet
        // If we try and update it while another text field is selected, it may shrink back down to only the size of one line (for some reason?)
        if isEditing || lastSize == nil {
            guard let
                // If we’re being edited, get the shared NSTextView field editor, so we can get more info
                textView = self.window?.fieldEditor(false, for: self) as? NSTextView,
                let container = textView.textContainer,
                let newHeight = container.layoutManager?.usedRect(for: container).height
                else {
                    return lastSize ?? minSize
            }
            var newSize = super.intrinsicContentSize
            newSize.height = newHeight + bottomSpace
            
            if let heightLimit = heightLimit,
                let lastSize = lastSize, newSize.height > heightLimit {
                newSize = lastSize
            }
            
            if  newSize.height < minHeight {
                newSize.height = minHeight
            }
            
            lastSize = newSize
            return newSize
        }
        else {
            return lastSize ?? minSize
        }
    }
}
