//
//  NetworkError.swift
//  IG Direct
//
//  Created by Daniel Lee on 5/4/19.
//  Copyright © 2019 Ctech. All rights reserved.
//

import Foundation
import ObjectMapper

// MARK: Initializer and Properties
struct NetworkError: ImmutableMappable, Error {
    
    let error : String
    
    init(error: String) {
        self.error = error
    }
    
    init(map: Map) throws {
        error = try map.value("error")
    }
    
    func mapping(map: Map) {
        error >>> map["error"]
    }
    
}
