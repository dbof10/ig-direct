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
import SwinjectStoryboard

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    let container = Container() { container in
        container.register(UserSecretManager.self) { _ in
            let keychain = Keychain(service: "com.ctech.igdirect")
            return UserSecretManager(keychain, UserDefaults.standard)
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
        container.register(SplashViewModel.self) { r in
            SplashViewModel(r.resolve(UserSecretManager.self)!, r.resolve(ThreadScheduler.self)!)
        }
        
        
        // Views
        container.storyboardInitCompleted(LoginViewController.self) { r, c in
            c.viewModel = r.resolve(LoginViewModel.self)!
        }
        
        container.storyboardInitCompleted(SplashViewController.self) { r, c in
            c.viewModel = r.resolve(SplashViewModel.self)!
        }
        
        
        container.storyboardInitCompleted(ChatViewController.self) { r, c in
            
        }
    }
    
    private var nodeCore: NodeCore!
    var windowController: NSWindowController!
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        nodeCore = container.resolve(NodeCore.self)
        nodeCore.lunchServer()
        
        let bundle = Bundle(for: LoginViewController.self)
        let storyboard = SwinjectStoryboard.create(name: "Main", bundle: bundle, container: container)
        windowController = storyboard.instantiateController(withIdentifier: "MainWindowController") as! NSWindowController
        let splashViewController = storyboard.instantiateController(withIdentifier: "SplashViewController") as! SplashViewController
        windowController.contentViewController = splashViewController
        
        windowController.showWindow(self)
        
       
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        nodeCore.shutdown()
    }
    
    
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }
}


