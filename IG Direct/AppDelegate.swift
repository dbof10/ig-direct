//
//  AppDelegate.swift
//  IG Direct
//
//  Created by Daniel Lee on 4/6/19.
//  Copyright © 2019 Ctech. All rights reserved.
//

import Cocoa
import Swinject
import SwinjectStoryboard
import RxSwift
@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    private let SERVER_STATUS_OK = "100"
    
    let container = Container() { container in
        container.register(UserSecretManager.self) { _ in
            return UserSecretManager(UserDefaults.standard)
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
        
        container.register(ChatRepository.self) { r in
            ChatRepository(r.resolve(IGApiClient.self)!)
            }.inObjectScope(.container)
        
        
        //viewmodel
        container.register(LoginViewModel.self) { r in
            LoginViewModel(r.resolve(UserRepository.self)!)
        }
        container.register(ChatListViewModel.self) { r in
            ChatListViewModel(r.resolve(ChatRepository.self)!, r.resolve(ThreadScheduler.self)!)
        }
        container.register(MessageViewModelMapper.self) { r in
            MessageViewModelMapper(r.resolve(UserSecretManager.self)!)
        }
        container.register(ChatDetailViewModel.self) { r in
            ChatDetailViewModel(r.resolve(ChatRepository.self)!,
                                r.resolve(MessageViewModelMapper.self)!,
                                r.resolve(ThreadScheduler.self)!)
        }
        
        
        // Views
        container.storyboardInitCompleted(LoginViewController.self) { r, c in
            c.viewModel = r.resolve(LoginViewModel.self)!
        }
        
        container.storyboardInitCompleted(ChatViewController.self) { r, c in
            
        }
        
        container.storyboardInitCompleted(ChatListViewController.self) { r, c in
            c.viewModel = r.resolve(ChatListViewModel.self)!
        }
        
        container.storyboardInitCompleted(ChatDetailViewController.self) { r, c in
            c.viewModel = r.resolve(ChatDetailViewModel.self)!
        }
    }
    
    private var nodeCore: NodeCore!
    private let disposeBag = DisposeBag()
    var windowController: NSWindowController!
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        nodeCore = container.resolve(NodeCore.self)
        nodeCore.lunchServer()
        nodeCore.taskStatus()
            .filter {
               $0.isSuccess
            }
            .map {
               $0.value!
            }
            .map {
                $0.trimmingCharacters(in: .whitespacesAndNewlines)
            }
            .subscribeOn(SerialDispatchQueueScheduler(qos: .background))
            .observeOn(MainScheduler.asyncInstance)
            .subscribe({ result in
                switch(result) {
                case .next(let status):
                    if self.SERVER_STATUS_OK.elementsEqual(status) {
                        let userSecretManager = self.container.resolve(UserSecretManager.self)!
                        let bundle = Bundle(for: LoginViewController.self)
                        let storyboard = SwinjectStoryboard.create(name: "Main", bundle: bundle, container: self.container)
                        self.windowController = (storyboard.instantiateController(withIdentifier: "MainWindowController") as! NSWindowController)

                        let viewController : NSViewController
                        if userSecretManager.getUserToken().isEmpty {
                            viewController = self.getLoginViewController()
                        } else {
                            viewController = self.getChatViewController()
                        }
                        self.windowController.contentViewController = viewController
                        self.windowController.showWindow(self)
                    }
                case .error(let error as NodeError):
                    self.showNodeErrorDialog(error.message)
                default: ()
                }
                
            })
            .disposed(by: disposeBag)
        
        nodeCore.taskStatus()
            .filter {
                $0.isError
            }
            .subscribeOn(SerialDispatchQueueScheduler(qos: .background))
            .observeOn(MainScheduler.asyncInstance)
            .subscribe({ result in
                switch(result) {
                case .next(let result):
                   let error = result.error as! NodeError
                   self.showNodeErrorDialog(error.message)
                default: ()
                }
                
            })
            .disposed(by: disposeBag)
        
    }
    
    private func showNodeErrorDialog(_ message: String) {
        let storyboard = NSStoryboard(name: "Main", bundle: nil)
        windowController = (storyboard.instantiateController(withIdentifier: "MainWindowController") as! NSWindowController)
        windowController.showWindow(self)
        
        let alert: NSAlert = NSAlert()
        alert.messageText = "An error has occured"
        alert.informativeText = message
        alert.addButton(withTitle: "Ok")
        alert.alertStyle = NSAlert.Style.warning
        
        alert.beginSheetModal(for: NSApplication.shared.mainWindow!, completionHandler: { (modalResponse: NSApplication.ModalResponse) -> Void in
            if(modalResponse == NSApplication.ModalResponse.alertFirstButtonReturn){
                NSApplication.shared.terminate(1)
            }
        })
    }
    
    private func getLoginViewController() -> NSViewController {
        let bundle = Bundle(for: LoginViewController.self)
        let storyboard = SwinjectStoryboard.create(name: "Main", bundle: bundle, container: container)
        let loginViewController = storyboard.instantiateController(withIdentifier: "LoginViewController") as! LoginViewController
        return loginViewController
    }
    
    
    private func getChatViewController()  -> NSViewController {
        let bundle = Bundle(for: ChatViewController.self)
        let storyboard = SwinjectStoryboard.create(name: "Main", bundle: bundle, container: container)
        let chatViewController = storyboard.instantiateController(withIdentifier: "ChatViewController") as! ChatViewController
        return chatViewController
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        nodeCore.shutdown()
    }
    
    
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }
}


