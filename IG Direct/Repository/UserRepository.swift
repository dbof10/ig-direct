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
    
    
    func signIn(with credentials: Credentials) -> Single<Result<LoginResponse, Error>> {
        return apiClient.login(credentials: credentials)
            .map {
                Result.success($0)
            }
            .catchError({ (error: Error) -> PrimitiveSequence<SingleTrait, Result<LoginResponse, Error>> in
                return Single.just(Result.failure(error))
            })
            .do(onSuccess: { (result: Result<LoginResponse, Error>) in
                if result.isSuccess {
                    self.userSecret.setUserToken(token: result.value!.token)
                    self.userSecret.setUser(user: result.value!.user)
                }
            })
        
    }
}
