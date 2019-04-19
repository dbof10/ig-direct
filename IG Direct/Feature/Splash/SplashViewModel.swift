//
//  SplashViewModel.swift
//  IG Direct
//
//  Created by Daniel Lee on 4/18/19.
//  Copyright © 2019 Ctech. All rights reserved.
//

import Foundation
import RxSwift

class SplashViewModel : BaseViewModel {
    struct Input {
        
    }
    struct Output {
        let loginResultObservable: Observable<User>
        let errorsObservable: Observable<Error>
    }
    
    // MARK: - Public properties
    let output: Output
    
    private let loginResultSubject = PublishSubject<User>()
    private let errorsSubject = PublishSubject<Error>()
    
    private let disposeBag = DisposeBag()

    private let userSecret: UserSecretManager
    private let threadScheduler: ThreadScheduler
    init(_ userSecret: UserSecretManager, _ threadScheduler: ThreadScheduler) {
        self.userSecret = userSecret
        self.threadScheduler = threadScheduler
        
        
        output = Output(loginResultObservable: loginResultSubject.asObservable(),
                        errorsObservable: errorsSubject.asObservable())
    
    }
    
    
    func viewDidLoad() {
        userSecret.getUser()
            .subscribeOn(threadScheduler.worker)
            .observeOn(threadScheduler.asyncUi)
            .subscribe(onNext: { (user: User) in
                self.loginResultSubject.onNext(user)
            }, onError: {(error: Error) in
                self.errorsSubject.onNext(error)
            })
            .disposed(by: disposeBag)
        
    }
}
