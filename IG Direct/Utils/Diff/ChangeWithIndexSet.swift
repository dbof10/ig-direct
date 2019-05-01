//
//  ChangeWithIndexSet.swift
//  IG Direct
//
//  Created by Daniel Lee on 5/1/19.
//  Copyright © 2019 Ctech. All rights reserved.
//

import Foundation
import DeepDiff

public struct ChangeWithIndexSet {
    
    public let inserts: IndexSet
    public let deletes: IndexSet
    public let replaces: IndexSet
    public let moves: [(from: Int, to: Int)]
    
    public init(
        inserts: IndexSet,
        deletes: IndexSet,
        replaces:IndexSet,
        moves: [(from: Int, to: Int)]) {
        
        self.inserts = inserts
        self.deletes = deletes
        self.replaces = replaces
        self.moves = moves
    }
}

public class IndexSetConverter {
        
    public func convert<T>(changes: [Change<T>]) -> ChangeWithIndexSet {
        let inserts = changes.compactMap({ $0.insert }).map({ $0.index })
        let deletes = changes.compactMap({ $0.delete }).map({ $0.index })
        let replaces = changes.compactMap({ $0.replace }).map({ $0.index })
        let moves = changes.compactMap({ $0.move }).map({
            (
                from: $0.fromIndex,
                to: $0.toIndex
            )
        })
        
        return ChangeWithIndexSet(
            inserts: IndexSet(inserts),
            deletes: IndexSet(deletes),
            replaces: IndexSet(replaces),
            moves: moves
        )
    }
}
