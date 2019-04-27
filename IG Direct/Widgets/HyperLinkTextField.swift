//
//  HyperLinkTextField.swift
//  IG Direct
//
//  Created by Daniel Lee on 4/27/19.
//  Copyright © 2019 Ctech. All rights reserved.
//

import Foundation
import Cocoa

class HyperlinkTextField: NSTextField {
    
    
    private var detector: NSDataDetector!
    
    override func awakeFromNib() {
        super.awakeFromNib()
         detector = try! NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
    }
    
    
    func setText(text: String) {
        let matches = detector.matches(in: text, options: [], range: NSRange(location: 0, length: text.utf16.count))
        
        for match in matches {
            guard let range = Range(match.range, in: text) else { continue }
            let url = text[range]
            let attributedString = NSMutableAttributedString(string: text)
            attributedString.addAttribute(.link, value: url, range: match.range)
            self.attributedStringValue = attributedString
        }
    }
    
}
