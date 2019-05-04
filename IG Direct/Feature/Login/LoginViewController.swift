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
import SwinjectStoryboard

class LoginViewController: NSViewController {
    
    @IBOutlet weak var etEmail: NSTextField!
    
    @IBOutlet weak var etPassword: NSTextField!
    
    @IBOutlet weak var btLogin: NSButton!
    
    @IBOutlet weak var mastelView: MastelView!
    @IBOutlet weak var ivBackground: NSImageView!
    var viewModel: LoginViewModel!

    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupBinding()
        
       
    }
    
    private func setupView() {
        ivBackground.wantsLayer = true
        ivBackground.layer!.masksToBounds = true
        ivBackground.layer!.cornerRadius = 8;
        ivBackground.layer!.backgroundColor = ConstantColor.COLOR_F4F4F4
        
        
        etEmail.wantsLayer = true
        etEmail.layer!.borderColor = .black
        etEmail.layer!.borderWidth = 1
        etEmail.layer!.cornerRadius = 4
        
        etPassword.wantsLayer = true
        etPassword.layer!.borderColor = .black
        etPassword.layer!.borderWidth = 1
        etPassword.layer!.cornerRadius = 4
        
        etEmail.setHintTextColor(color: .black)
        etPassword.setHintTextColor(color: .black)

        mastelView.startPastelPoint = .bottomLeft
        mastelView.endPastelPoint = .topRight
        
        // Custom Duration
        mastelView.animationDuration = 3.0
        
        // Custom Color
        mastelView.setColors([NSColor(red: 156/255, green: 39/255, blue: 176/255, alpha: 1.0),
                              NSColor(red: 255/255, green: 64/255, blue: 129/255, alpha: 1.0),
                              NSColor(red: 123/255, green: 31/255, blue: 162/255, alpha: 1.0),
                              NSColor(red: 32/255, green: 76/255, blue: 255/255, alpha: 1.0),
                              NSColor(red: 32/255, green: 158/255, blue: 255/255, alpha: 1.0),
                              NSColor(red: 90/255, green: 120/255, blue: 127/255, alpha: 1.0),
                              NSColor(red: 58/255, green: 255/255, blue: 217/255, alpha: 1.0)])
        
        mastelView.startAnimation()
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
                self.showChat()
            })
            .disposed(by: disposeBag)
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

