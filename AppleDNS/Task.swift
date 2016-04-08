//
//  Task.swift
//  AppleDNS
//
//  Created by xjbeta on 16/4/8.
//  Copyright © 2016年 xjbeta. All rights reserved.
//

import Cocoa

class Task: NSObject {

    private let pipe = NSPipe()
    private let task = NSTask()
    
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
        obs1 = NSNotificationCenter.defaultCenter().addObserverForName(NSFileHandleDataAvailableNotification, object: outHandle, queue: nil) {  notification in
            let data = outHandle.availableData
            if data.length > 0 {
                if let str = NSString(data: data, encoding: NSUTF8StringEncoding) {
                    print("got output: \(str)")
                    
                    self.notification!(str as String)
                    
                }
                outHandle.waitForDataInBackgroundAndNotify()
            } else {
                print("EOF on stdout from process")
                NSNotificationCenter.defaultCenter().removeObserver(obs1)
            }
        }
        
        var obs2 : NSObjectProtocol!
        obs2 = NSNotificationCenter.defaultCenter().addObserverForName(NSTaskDidTerminateNotification,                            object: task, queue: nil) { notification in
            self.terminated!()
            
            NSNotificationCenter.defaultCenter().removeObserver(obs2)
        }
    }
    
    func launch() {
        task.launch()
    }
    

    
    
}
