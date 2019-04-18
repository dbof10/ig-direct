//
//  AppDelegate.swift
//  IG Direct
//
//  Created by Daniel Lee on 4/6/19.
//  Copyright © 2019 Ctech. All rights reserved.
//

import Cocoa
import Swinject
import KeychainAccess

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    private let container = Container() { container in
        container.register(UserSecretManager.self) { _ in
            let keychain = Keychain(service: "com.ctech.igdirect")
            return UserSecretManager(keychain)
            }.inObjectScope(.container)
        
        container.register(ThreadScheduler.self) {
            _ in WorkerThreadScheduler()
            }
            .inObjectScope(.container)
        
        container.register(NodeCore.self) { r in
            let threadScheduler = r.resolve(ThreadScheduler.self)!
            return NodeCore(context: NSApplication.shared, threadScheduler)
            }
            .inObjectScope(.container)
        
        container.register(IGApiClient.self) { r in
            IGApiClient(r.resolve(UserSecretManager.self)!)
            }
            .inObjectScope(.container)
        
        //repository
        container.register(UserRepository.self) { r in
            UserRepository(r.resolve(IGApiClient.self)!, r.resolve(UserSecretManager.self)!)
            }.inObjectScope(.container)
        
     
        
        //viewmodel
        container.register(LoginViewModel.self) { r in
            LoginViewModel(r.resolve(UserRepository.self)!)
        }
        
    }
    
    private var nodeCore: NodeCore!
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        nodeCore = container.resolve(NodeCore.self)!
        nodeCore.lunchServer()
        
        let storyboard = NSStoryboard(name: NSStoryboard.Name("Main"), bundle: Bundle.main)
        let windowController = storyboard.instantiateController(withIdentifier: "MainWindowController") as! NSWindowController
        let loginViewController = storyboard.instantiateController(withIdentifier: "LoginViewController") as! LoginViewController
        
        loginViewController.viewModel = container.resolve(LoginViewModel.self)
        windowController.contentViewController = loginViewController
        
        windowController.showWindow(self)
        
       
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        nodeCore.shutdown()
    }
    
    
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }
}


