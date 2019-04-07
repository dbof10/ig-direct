//
//  LoginViewController.swift
//  IG Direct
//
//  Created by Daniel Lee on 4/6/19.
//  Copyright © 2019 Ctech. All rights reserved.
//

import Cocoa
import RxSwift
import RxCocoa

class LoginViewController: NSViewController {
    
    @IBOutlet weak var etEmail: NSTextField!
    
    @IBOutlet weak var etPassword: NSSecureTextField!
    
    @IBOutlet weak var btLogin: NSButton!
    
    var viewModel: LoginViewModel!

    private let disposeBag = DisposeBag()

  
    override func viewDidLoad() {
        print("view did load")
        super.viewDidLoad()
        setupBinding()
    }
    
    private func setupBinding() {
        
        etEmail.rx.text.orEmpty
            .subscribe(viewModel.input.email)
            .disposed(by: disposeBag)
        
        etPassword.rx.text.orEmpty
            .subscribe(viewModel.input.password)
            .disposed(by: disposeBag)
        
        btLogin.rx.tap.asObservable()
            .subscribe(viewModel.input.signInDidTap)
            .disposed(by: disposeBag)
        
        viewModel.output.errorsObservable
            .subscribe(onNext: { [unowned self] (error) in
                self.presentError(error)
            })
            .disposed(by: disposeBag)
        
        viewModel.output.loginResultObservable
            .subscribe(onNext: { [unowned self] (user) in
                print("User successfully signed in \(user)")
            })
            .disposed(by: disposeBag)
    }
}

