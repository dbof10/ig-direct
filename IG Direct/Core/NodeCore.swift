//
//  NodeCore.swift
//  IG Direct
//
//  Created by Daniel Lee on 4/13/19.
//  Copyright © 2019 Ctech. All rights reserved.
//

import Cocoa
import RxSwift

class NodeCore {
    
    private var task: NodeTask!
    private let disposeBag = DisposeBag()
    private let context: NSApplication
    private let threadScheduler: ThreadScheduler
    
    init(context: NSApplication,_ threadScheduler: ThreadScheduler) {
        self.context = context
        self.threadScheduler = threadScheduler
    }
    
    func lunchServer() {
        let mainBundle = Bundle.main
        
        // If any of these fail, we need a runtime error.
        let pathToNodeApp = mainBundle.path(forResource: "app.bundle", ofType: "js")!
        let pathToNode = mainBundle.path(forResource: "node", ofType: "")!
        let pathToAppFolder = (pathToNodeApp as NSString).deletingLastPathComponent
        
        task = NodeTask(nodeJSPath: pathToNode, appPath: pathToNodeApp, currentDirectoryPath: pathToAppFolder)
        task.launch()
     
    }
    
    func shutdown() {
        task.terminate()
    }
    
    func taskStatus() -> Observable<Result<String,Error>> {
        return task.observeTaskStatus()
    }
    
}
