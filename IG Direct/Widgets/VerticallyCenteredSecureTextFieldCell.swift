//
//  VerticallyCenteredSecureTextFieldCell.swift
//  IG Direct
//
//  Created by Daniel Lee on 5/4/19.
//  Copyright © 2019 Ctech. All rights reserved.
//

import Foundation
import Cocoa

class VerticallyCenteredSecureTextFieldCell: NSSecureTextFieldCell {
    
    
    override func drawingRect(forBounds theRect: NSRect) -> NSRect {
        var newRect = super.drawingRect(forBounds: theRect)
        let textSize = self.cellSize(forBounds: theRect)
        let heightDelta = newRect.size.height - textSize.height
        if heightDelta > 0 {
            newRect.size.height -= heightDelta
            newRect.origin.y += (heightDelta / 2)
        }
        return newRect
    }
    
}
