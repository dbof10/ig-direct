//
//  AppDelegate.swift
//  IG Direct
//
//  Created by Daniel Lee on 4/6/19.
//  Copyright © 2019 Ctech. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

   
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        let storyboard = NSStoryboard(name: NSStoryboard.Name("Main"), bundle: Bundle.main)
        let window = storyboard.instantiateController(withIdentifier: "MainWindowController") as! NSWindowController
        let loginViewController = storyboard.instantiateController(withIdentifier: "LoginViewController") as! LoginViewController
     
        let repo = UserRepository()
        
        let viewModel = LoginViewModel(repo)
        loginViewController.viewModel = viewModel
        window.contentViewController = loginViewController
       
        window.showWindow(self) // neede
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
       return true
    }
}

