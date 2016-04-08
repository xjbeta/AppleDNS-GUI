//
//  DownloadFiles.swift
//  AppleDNS
//
//  Created by xjbeta on 16/4/7.
//  Copyright © 2016年 xjbeta. All rights reserved.
//

import Cocoa

class DownloadFiles: NSObject {
    
    var path = NSTemporaryDirectory() + "AppleDNS"
    
    let queue = dispatch_queue_create("com.AppleDNS.background", nil)
    
    var success: (() -> Void)?

    var error: (() -> Void)?
    
    var notification: ((String) -> Void)?
    
    var export: ((String) -> Void)?
    
    var unzipSuccess: (() -> Void)?
    
    var pingTerminated: (() -> Void)?
    
    
    func unzip() {

        let task = Task(launchPath: "/usr/bin/unzip",
                        arguments: ["-o", path + "/master"],
                        currentDirectoryPath: path)
        task.setNotification()
        task.launch()
        self.unzipSuccess!()
    }
    
    func setPath() {
        dispatch_sync(queue) {
        do {
            try NSFileManager.defaultManager().createDirectoryAtPath(self.path, withIntermediateDirectories: true, attributes: nil)
        } catch {
            print("createDirectoryAtPath fail")
        }
        }
        
        
        
    }
    
    
    
    func clearFiles() {
        dispatch_sync(queue) {
        
        do {
            try NSFileManager.defaultManager().removeItemAtPath(self.path)
        } catch {
            print("without file")
        }
        
        
        }
        
    }
    
    
    
    
    func downloadFile() {
        
        dispatch_async(queue) {
            
            let url = "https://codeload.github.com/gongjianhui/AppleDNS/zip/master"
            
            if let url = NSURL(string: url) {
                
                let fileUrl = NSURL(fileURLWithPath: self.path)
                
                let destinationUrl = fileUrl.URLByAppendingPathComponent(url.lastPathComponent!)
                
                if NSFileManager().fileExistsAtPath(destinationUrl.path!) {
                    print("文件重复")
                } else {
                    if let myAudioDataFromUrl = NSData(contentsOfURL: url){
                        if myAudioDataFromUrl.writeToURL(destinationUrl, atomically: true) {
                            self.success!()
                        } else {
                            self.error!()
                        }
                    }
                }
            }
            
        }
        

        
        
    }
    
    
    
    func ping(title1: String, title2: String) {
        
        dispatch_sync(queue) {
            let t2: String
            switch title2 {
            case "电信":
                t2 = "ChinaNet"
            case "联通":
                t2 = "ChinaUnicom"
            default:
                t2 = "CMCC"
            }
            
            let task = Task(launchPath: "/usr/bin/python",
                            arguments: ["fetch-timeout.py", "\(t2).json"],
                            currentDirectoryPath: self.path + "/AppleDNS-master/")
            task.setNotification()
            task.notification = { str in
                self.notification!(str)
            }
            task.terminated = {
                self.export(title1)
            }
            
            task.launch()
            
            
            
        }
        

        

        

    }
    
    
    func export(title1: String) {
        dispatch_sync(queue) {
        let task = Task(launchPath: "/usr/bin/python",
                        arguments: ["export-configure.py", title1],
                        currentDirectoryPath: self.path + "/AppleDNS-master/")
        task.setNotification()
        task.notification = { str in
            self.export!(str)
        }
        task.terminated = {
                
        }
        task.launch()
    }
    
    }
    
}
