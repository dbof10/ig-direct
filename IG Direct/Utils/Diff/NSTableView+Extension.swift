//
//  NSTableView+Extension.swift
//  IG Direct
//
//  Created by Daniel Lee on 5/10/19.
//  Copyright © 2019 Ctech. All rights reserved.
//

import Foundation
import Cocoa
import IGListKit


extension NSTableView {
    
    
    
    func notifyDataSetChange(diffResult: ListIndexSetResult,
                             completion: ((Bool) -> Void)? = nil) {
        
        
        let inserts = diffResult.inserts
        let deletes = diffResult.deletes
        let updates = diffResult.updates
        let moves = diffResult.moves
        
        
        beginUpdates()
        
        
        removeRows(at: deletes, withAnimation: NSTableView.AnimationOptions.slideUp)
        
        insertRows(at: inserts, withAnimation: NSTableView.AnimationOptions.effectGap)
        
        moves.forEach {
            self.moveRow(at: $0.from, to: $0.to)
        }
        
        reloadData(forRowIndexes: updates, columnIndexes: IndexSet(integer: 0))
        
        endUpdates()
        
        completion?(true)
    }
}

extension NSTableView {
    
    func scrollRowToVisible(row: Int, animated: Bool) {
        
        if animated {
            guard let clipView = superview as? NSClipView,
                let scrollView = clipView.superview as? NSScrollView else {
                    
                    assertionFailure("Unexpected NSTableView view hiearchy")
                    return
            }
            
            let rowRect = rect(ofRow: row)
            let scrollOrigin = rowRect.origin
            
            if scrollView.responds(to: #selector(NSScrollView.flashScrollers)) {
                scrollView.flashScrollers()
            }
            
            clipView.animator().setBoundsOrigin(scrollOrigin)
            
        } else {
            
            scrollRowToVisible(row)
        }
    }
}
