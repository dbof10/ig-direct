//
//  NSTableView+Extension.swift
//  IG Direct
//
//  Created by Daniel Lee on 5/1/19.
//  Copyright © 2019 Ctech. All rights reserved.
//

import Foundation
import Cocoa
import DeepDiff


public extension NSTableView {
    
    /// Animate reload in a batch update
    ///
    /// - Parameters:
    ///   - changes: The changes from diff
    ///   - section: The section that all calculated IndexPath belong
    ///   - insertionAnimation: The animation for insert rows
    ///   - deletionAnimation: The animation for delete rows
    ///   - replacementAnimation: The animation for reload rows
    ///   - updateData: Update your data source model
    ///   - completion: Called when operation completes
    func notifyDataSetChange<T: DiffAware>(
        changes: [Change<T>],
        insertionAnimation: NSTableView.AnimationOptions = NSTableView.AnimationOptions.effectGap,
        deletionAnimation: NSTableView.AnimationOptions = NSTableView.AnimationOptions.slideUp,
        replacementAnimation: NSTableView.AnimationOptions = NSTableView.AnimationOptions.effectFade,
        updateData: () -> Void,
        completion: ((Bool) -> Void)? = nil) {
        
        let changesWithIndexPath = IndexSetConverter().convert(changes: changes)
        
        unifiedPerformBatchUpdates({
            updateData()
            self.insideUpdate(
                changesWithIndexSet: changesWithIndexPath,
                insertionAnimation: insertionAnimation,
                deletionAnimation: deletionAnimation
            )
        }, completion: { finished in
            completion?(finished)
        })
        
        // reloadRows needs to be called outside the batch
        outsideUpdate(changesWithIndexPath: changesWithIndexPath, replacementAnimation: replacementAnimation)
    }
    
    // MARK: - Helper
    private func unifiedPerformBatchUpdates(
        _ updates: (() -> Void),
        completion: (@escaping (Bool) -> Void)) {
        
            beginUpdates()
            updates()
            endUpdates()
            completion(true)
    }
    
    private func insideUpdate(
        changesWithIndexSet: ChangeWithIndexSet,
        insertionAnimation: NSTableView.AnimationOptions ,
        deletionAnimation: NSTableView.AnimationOptions ) {
        
        removeRows(at: changesWithIndexSet.deletes, withAnimation: deletionAnimation)
        
        insertRows(at: changesWithIndexSet.inserts, withAnimation: insertionAnimation)
        
        changesWithIndexSet.moves.executeIfPresent {
            $0.forEach { move in
                moveRow(at: move.from, to: move.to)
            }
        }
    }
    
    private func outsideUpdate(
        changesWithIndexPath: ChangeWithIndexSet,
        replacementAnimation: NSTableView.AnimationOptions ) {
        
        reloadData(forRowIndexes: changesWithIndexPath.replaces, columnIndexes: IndexSet(integer: 0))

        }
}
