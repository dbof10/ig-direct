//
//  AppDelegate.swift
//  IG Direct
//
//  Created by Daniel Lee on 4/6/19.
//  Copyright © 2019 Ctech. All rights reserved.
//

import Cocoa
import Swinject

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    let container = Container() { container in
        container.register(IGApiClient.self) { _ in IGApiClient() }
            .inObjectScope(.container)
        
        //repository
        container.register(UserRepository.self) { r in
            UserRepository(r.resolve(IGApiClient.self)!)
            }.inObjectScope(.container)
        
        
        //viewmodel
        container.register(LoginViewModel.self) { r in
            LoginViewModel(r.resolve(UserRepository.self)!)
        }
        
    }
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        let storyboard = NSStoryboard(name: NSStoryboard.Name("Main"), bundle: Bundle.main)
        let window = storyboard.instantiateController(withIdentifier: "MainWindowController") as! NSWindowController
        let loginViewController = storyboard.instantiateController(withIdentifier: "LoginViewController") as! LoginViewController
        
        loginViewController.viewModel = container.resolve(LoginViewModel.self)
        window.contentViewController = loginViewController
        
        window.showWindow(self)
    }
    
    
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }
}


