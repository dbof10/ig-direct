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
    
    init(_ apiClient: IGApiClient) {
        self.apiClient = apiClient
    }
    
    
    func signIn(with credentials: Credentials) -> Observable<User> {
        return Observable.just(User.ANNONYMOUS)
    }
}
