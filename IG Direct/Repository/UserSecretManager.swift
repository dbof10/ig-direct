//
//  UserSecretManager.swift
//  IG Direct
//
//  Created by Daniel Lee on 4/16/19.
//  Copyright © 2019 Ctech. All rights reserved.
//

import Foundation
import KeychainAccess

class UserSecretManager {
    private let KEY_TOKEN : String = "KEY_TOKEN"

    private let keychain: Keychain
    init(_ keychain: Keychain) {
        self.keychain = keychain
    }
    
    
    func setUserToken(token: String) {
        keychain[KEY_TOKEN] = token

    }
    
    func getUserToken() -> String {
        return keychain[KEY_TOKEN]!
    }
    
}
