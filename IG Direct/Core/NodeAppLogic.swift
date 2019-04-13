//
//  NodeAppLogic.swift
//  IG Direct
//
//  Created by Daniel Lee on 4/13/19.
//  Copyright © 2019 Ctech. All rights reserved.
//

import Foundation
import RxSwift

class NodeAppLogic: AppLogic {
    
    private let nodeCore : NodeCore
    
    init(nodeCore: NodeCore) {
        self.nodeCore = nodeCore
    }
    
    func execute() -> Completable {
        return Completable.empty()

    }
    
    
    
}
