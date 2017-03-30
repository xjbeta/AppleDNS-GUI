//
//  Task.swift
//  AppleDNS
//
//  Created by xjbeta on 16/4/8.
//  Copyright © 2016年 xjbeta. All rights reserved.
//

import Cocoa

class Task: NSObject {

    fileprivate let pipe = Pipe()
    fileprivate let task = Process()
    
    var notification: ((String) -> Void)?
    var terminated: (() -> Void)?
    
    init(launchPath: String, arguments: [String], currentDirectoryPath: String) {
        super.init()
        task.launchPath = launchPath
        task.arguments = arguments
        task.currentDirectoryPath = currentDirectoryPath
        task.standardOutput = self.pipe
        
    }
    
    func setNotification() {
        let outHandle = pipe.fileHandleForReading
        outHandle.waitForDataInBackgroundAndNotify()
        var obs1 : NSObjectProtocol!
        obs1 = NotificationCenter.default.addObserver(forName: NSNotification.Name.NSFileHandleDataAvailable, object: outHandle, queue: nil) {  notification in
            let data = outHandle.availableData
            if data.count > 0 {
                if let str = NSString(data: data, encoding: String.Encoding.utf8.rawValue) {
                    print("got output: \(str)")
                    
                    self.notification!(str as String)
                    
                }
                outHandle.waitForDataInBackgroundAndNotify()
            } else {
                print("EOF on stdout from process")
                NotificationCenter.default.removeObserver(obs1)
            }
        }
        
        var obs2 : NSObjectProtocol!
        obs2 = NotificationCenter.default.addObserver(forName: Process.didTerminateNotification,                            object: task, queue: nil) { notification in
            self.terminated!()
            
            NotificationCenter.default.removeObserver(obs2)
        }
    }
    
    func launch() {
        task.launch()
    }
    

    
    
}
