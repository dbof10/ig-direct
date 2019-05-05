//
//  Result+Extension.swift
//  IG Direct
//
//  Created by Daniel Lee on 4/20/19.
//  Copyright © 2019 Ctech. All rights reserved.
//

import Foundation

extension Result {
    
    var value: Success? {
        guard case let .success(value) = self else { return nil }
        return value
    }
    
    var error: Error? {
        guard case let .failure(value) = self else { return nil }
        return value
    }
    
    var isSuccess: Bool { if case .success = self { return true } else { return false } }
    
    var isError: Bool {  return !isSuccess  }
    
}
