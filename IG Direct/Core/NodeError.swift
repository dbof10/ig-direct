//
//  NodeError.swift
//  IG Direct
//
//  Created by Daniel Lee on 4/14/19.
//  Copyright © 2019 Ctech. All rights reserved.
//


final class NodeError : Error {
    
    let message: String
    init(message : String) {
        self.message = message
    }
}
