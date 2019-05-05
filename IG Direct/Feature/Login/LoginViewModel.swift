//
//  LoginViewModel.swift
//  IG Direct
//
//  Created by Daniel Lee on 4/6/19.
//  Copyright © 2019 Ctech. All rights reserved.
//

import RxSwift

class LoginViewModel: BaseViewModel {
    
     struct Input {
        let emailObservable: Observable<String>
        let passwordObservable: Observable<String>
        let loginTapObservable: Observable<Void>
    }
    
    struct Output {
        let loginResultObservable: Observable<User>
        let errorsObservable: Observable<Error>
    }
    
    // MARK: - Public properties
    let output: Output
    
    // MARK: - Private properties
    private let loginResultSubject = PublishSubject<User>()
    private let errorsSubject = PublishSubject<Error>()
    private let disposeBag = DisposeBag()

    private let repo: UserRepository
    
    init(_ repo: UserRepository) {
        self.repo =  repo
        
        
        output = Output(loginResultObservable: loginResultSubject.asObservable(),
                        errorsObservable: errorsSubject.asObservable())
        
       
    }
    
    func bind(input: Input) {
        
        let credentialsObservable = Observable.combineLatest(input.emailObservable, input.passwordObservable) { (email, password) in
                    return Credentials(email: email, password: password)
        }
        
        input.loginTapObservable
            .do(onNext: { _ in
                print("next tap ")
            })
            .withLatestFrom(credentialsObservable)
            .flatMapLatest { credentials in
                return self.repo.signIn(with: credentials)
            }
            .subscribe(onNext: { (result: Result<LoginResponse, Error>) in
                if result.isSuccess {
                    self.loginResultSubject.onNext(result.value!.user)
                }else {
                    self.errorsSubject.onNext(result.error!)
                }
            })
            .disposed(by: disposeBag)
    }
    
}
