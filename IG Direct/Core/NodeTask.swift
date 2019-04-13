//
//  NodeTask.swift
//  IG Direct
//
//  Created by Daniel Lee on 4/12/19.
//  Copyright © 2019 Ctech. All rights reserved.
//

import Foundation
import Cocoa

class NodeTask: NSObject {
    
    private let processIdentifier = ProcessInfo.processInfo.processIdentifier
    private let nodeTask = Process()
    private let readPipe = Pipe()
    private let errorPipe = Pipe()
    
    private let queue = DispatchQueue(label: "NodeTask.output.queue")
    
    private var running = false
    
    init(nodeJSPath: String, appPath: String, currentDirectoryPath: String) {
        
        super.init()
        
        
        readPipe.fileHandleForReading.readabilityHandler = { [unowned self] (handler: FileHandle!) in
            self.queue.async {
                if self.running {
                    let data = handler.readDataToEndOfFile()
                    self.onRead(data)
                }
            }
        }
        readPipe.fileHandleForReading.readInBackgroundAndNotify()
        
        errorPipe.fileHandleForReading.readabilityHandler = { [unowned self] (handler: FileHandle!) in
            self.queue.async {
                if self.running {
                    let data = handler.readDataToEndOfFile()
                    self.onError(data)
                }
            }
        }
        
        nodeTask.currentDirectoryPath = currentDirectoryPath
        nodeTask.launchPath = nodeJSPath
        nodeTask.arguments = [appPath, "\(processIdentifier)"]
        nodeTask.qualityOfService = .userInitiated
        nodeTask.standardOutput = readPipe
        nodeTask.standardError = errorPipe
    }
    
    deinit {
        self.terminate()
    }
    
    func launch() {
        
        if !running {
            print("------------------------------ Node launch ------------------------------")
            running = true
            nodeTask.launch()
        }
    }
    
    
     func terminate() {
        
        if running {
            print("------------------------------ Node quit ------------------------------")
            running = false
            readPipe.fileHandleForReading.closeFile()
            errorPipe.fileHandleForReading.closeFile()
            nodeTask.terminate()
        }
        
    }
    
    private func stringFromData(_ data: Data) -> String {
        return NSString(data: data, encoding: String.Encoding.utf8.rawValue)!.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines) as String
    }
    
    private func onRead(_ data: Data) {
        
        let text = stringFromData(data)
            print("Node: \(text)")
        
    }
    
    private func onError(_ data: Data) {
        
        let text = stringFromData(data)
            print("------------------------------ Node fatal error ------------------------------")
            print(text)
            self.terminate()
        
    }
    
}
