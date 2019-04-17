//
//  NodeTask.swift
//  IG Direct
//
//  Created by Daniel Lee on 4/12/19.
//  Copyright © 2019 Ctech. All rights reserved.
//

import Foundation
import Cocoa
import RxSwift

class NodeTask: NSObject {
    
    private let processIdentifier = ProcessInfo.processInfo.processIdentifier
    private let nodeTask = Process()
    private let readPipe = Pipe()
    private let errorPipe = Pipe()
    
    private let queue = DispatchQueue(label: "NodeTask.output.queue")
    
    private var running = false
    private let outputSubject = PublishSubject<Result<String, Error>>()
    
    init(nodeJSPath: String, appPath: String, currentDirectoryPath: String) {
        super.init()
        
        let documents = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)[0] as NSString
        let writePath = documents.appendingPathComponent(Bundle.main.bundleIdentifier!)

        guard (createFolder(folderName: writePath) != nil) else {
            return
        }
        
        nodeTask.currentDirectoryPath = currentDirectoryPath
        nodeTask.launchPath = nodeJSPath
        nodeTask.arguments = [appPath, "\(processIdentifier)", "\(writePath)"]
        nodeTask.qualityOfService = .userInitiated
        nodeTask.standardOutput = readPipe
        nodeTask.standardError = errorPipe
        
        readPipe.fileHandleForReading.waitForDataInBackgroundAndNotify()
        
      
        
        errorPipe.fileHandleForReading.readabilityHandler = { [unowned self] (handler: FileHandle!) in
            self.queue.async {
                if self.running {
                    let data = handler.readDataToEndOfFile()
                    self.onError(data)
                }
            }
        }
        
    }
    
    func observeTaskStatus() -> Observable<Result<String, Error>> {
        return outputSubject.asObservable()
    }
    
    func launch() {
        
        if !running {
            print("------------------------------ Node launch ------------------------------")
            running = true
            registerObserveTaskOutput()
            nodeTask.launch()
        }
    }
    
    private func registerObserveTaskOutput() {
        NotificationCenter.default.addObserver(forName: NSNotification.Name.NSFileHandleDataAvailable, object: readPipe.fileHandleForReading , queue: nil) {
            notification in
            
            let output = self.readPipe.fileHandleForReading.availableData
            let outputString = String(data: output, encoding: String.Encoding.utf8) ?? ""
            
            if !outputString.isEmpty {
            self.outputSubject.onNext(.success(outputString))
            }
            self.readPipe.fileHandleForReading.waitForDataInBackgroundAndNotify()
        }
    }
    
    private func unregisterObserveTaskOutput() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.NSFileHandleDataAvailable,
                                                  object: readPipe.fileHandleForReading)
    }
    
    
    func terminate() {
        
        if running {
            print("------------------------------ Node quit ------------------------------")
            running = false
            readPipe.fileHandleForReading.closeFile()
            errorPipe.fileHandleForReading.closeFile()
            unregisterObserveTaskOutput()
            nodeTask.terminate()
        }
        
    }
    
    private func stringFromData(_ data: Data) -> String {
        return NSString(data: data, encoding: String.Encoding.utf8.rawValue)!.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines) as String
    }
    

    private func onError(_ data: Data) {
        
        let text = stringFromData(data)
        print("------------------------------ Node fatal error ------------------------------")
        outputSubject.onNext(.failure(NodeError(message: text)))
        self.terminate()
        
    }
    
    private func createFolder(folderName: String) -> URL? {
        let fileManager = FileManager.default
        if let documentDirectory = fileManager.urls(for: .documentDirectory,
                                                    in: .userDomainMask).first {
            let folderURL = documentDirectory.appendingPathComponent(folderName)
            if !fileManager.fileExists(atPath: folderURL.path) {
                do {
                    try fileManager.createDirectory(atPath: folderURL.path,
                                                    withIntermediateDirectories: true,
                                                    attributes: nil)
                } catch {
                    print(error.localizedDescription)
                    return nil
                }
            }
            return folderURL
        }
        return nil
    }
    
    
}
