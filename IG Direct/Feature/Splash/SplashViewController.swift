//
//  SplashViewController.swift
//  IG Direct
//
//  Created by Daniel Lee on 4/18/19.
//  Copyright © 2019 Ctech. All rights reserved.
//

import Cocoa
import RxSwift
import SwinjectStoryboard

class SplashViewController: NSViewController {
    
    var viewModel: SplashViewModel!
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBinding()
        viewModel.viewDidLoad()
    }
    
    private func setupBinding() {

        
        viewModel.output.errorsObservable
            .subscribe(onNext: { [unowned self] (error) in
                self.presentError(error)
            })
            .disposed(by: disposeBag)
        
        viewModel.output.loginResultObservable
            .subscribe(onNext: { [unowned self] (user) in
                if(user == User.ANONYMOUS) {
                    self.showLogin()
                } else {
                    self.showChat()
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func showLogin() {
        let appDelegate = (NSApplication.shared.delegate as! AppDelegate)
        let container = appDelegate.container
        let bundle = Bundle(for: LoginViewController.self)
        let storyboard = SwinjectStoryboard.create(name: "Main", bundle: bundle, container: container)
        let loginViewController = storyboard.instantiateController(withIdentifier: "LoginViewController") as! LoginViewController
        appDelegate.windowController.contentViewController = loginViewController
        appDelegate.windowController.showWindow(appDelegate)
    }
    
    
    private func showChat() {
        let appDelegate = (NSApplication.shared.delegate as! AppDelegate)
        let container = appDelegate.container
        let bundle = Bundle(for: LoginViewController.self)
        let storyboard = SwinjectStoryboard.create(name: "Main", bundle: bundle, container: container)
        let loginViewController = storyboard.instantiateController(withIdentifier: "ChatViewController") as! ChatViewController
        appDelegate.windowController.contentViewController = loginViewController
        appDelegate.windowController.showWindow(appDelegate)
    }
}
