//
//  UserRepository.swift
//  IG Direct
//
//  Created by Daniel Lee on 4/6/19.
//  Copyright © 2019 Ctech. All rights reserved.
//

import RxSwift

class UserRepository {
    
    private let apiClient: IGApiClient
    private let userSecret: UserSecretManager
    init(_ apiClient: IGApiClient, _ userSecret: UserSecretManager) {
        self.apiClient = apiClient
        self.userSecret = userSecret
    }
    
    
    func signIn(with credentials: Credentials) -> Single<User> {
        return apiClient.login(credentials: credentials)
            .do(onSuccess: { (respose: LoginResponse) in
                self.userSecret.setUserToken(token: respose.session)
            })
            .map {_ in 
                User(name: "Name")
            }
        
    }
}
