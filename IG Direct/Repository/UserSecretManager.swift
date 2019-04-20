//
//  UserSecretManager.swift
//  IG Direct
//
//  Created by Daniel Lee on 4/16/19.
//  Copyright © 2019 Ctech. All rights reserved.
//

import Foundation
import KeychainAccess
import RxSwift
import ObjectMapper

class UserSecretManager {
    private let KEY_TOKEN : String = "KEY_TOKEN"
    private let KEY_USER : String = "KEY_USER"
    
    private let storage : UserDefaults
    
    init(_ storage : UserDefaults) {
        self.storage = storage
    }
    
    
    func setUserToken(token: String) {
        storage.set(token, forKey: KEY_TOKEN)
    }
    
    func getUserToken() -> String {
        return self.storage.string(forKey: self.KEY_TOKEN) ?? ""
    }
    
    func setUser(user: User) {
        let userAsString = Mapper().toJSONString(user, prettyPrint: false)
        storage.set(userAsString, forKey: KEY_USER)
        storage.synchronize()
    }
    
    func getUser() -> Observable<User> {
        return Observable<User>.create{ emitter -> Disposable in
            let userAsString = self.storage.string(forKey: self.KEY_USER) ?? ""
            let user: User
            if userAsString.isEmpty {
                user = User.ANONYMOUS
            }else {
                user = Mapper<User>().map(JSONString: userAsString)!
            }
            emitter.onNext(user)
            emitter.onCompleted()
            return Disposables.create { }
        }
        
    }
    
}
