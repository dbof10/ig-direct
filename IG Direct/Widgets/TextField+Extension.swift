//
//  TextField+Extension.swift
//  IG Direct
//
//  Created by Daniel Lee on 5/4/19.
//  Copyright © 2019 Ctech. All rights reserved.
//

import Foundation
import Cocoa

extension NSTextField {
    
    
    func setHintTextColor (color: NSColor) {
        let currentHint = placeholderString ?? ""
        let placeholderAttributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.foregroundColor: color,
            NSAttributedString.Key.font: font!
        ]
        
        let placeholderAttributedString = NSMutableAttributedString(string: currentHint, attributes: placeholderAttributes)
        let paragraphStyle = NSMutableParagraphStyle()
        
        placeholderAttributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0,length: placeholderAttributedString.length))
        
        self.placeholderAttributedString =  placeholderAttributedString
    }
}

