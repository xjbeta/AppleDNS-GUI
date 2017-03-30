//
//  DownloadFiles.swift
//  AppleDNS
//
//  Created by xjbeta on 16/4/7.
//  Copyright © 2016年 xjbeta. All rights reserved.
//

import Cocoa

class DownloadFiles: NSObject {
	
	static let shared = DownloadFiles()
	
	fileprivate override init() {
	}
	
    
    var path = NSTemporaryDirectory() + "AppleDNS"
    
    let queue = DispatchQueue(label: "com.AppleDNS.background", attributes: [])
    
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
        queue.sync {
			do {
				try FileManager.default.createDirectory(atPath: self.path, withIntermediateDirectories: true, attributes: nil)
			} catch {
				print("createDirectoryAtPath fail")
			}
        }
    }
    
    
    
    func clearFiles() {
        queue.sync {
			do {
				try FileManager.default.removeItem(atPath: self.path)
			} catch {
				print("without file")
			}
		}
    }
    
    
    
    
    func downloadFile() {
        
        queue.async {
            
            let url = "https://codeload.github.com/gongjianhui/AppleDNS/zip/master"
            
            if let url = URL(string: url) {
                
                let fileUrl = URL(fileURLWithPath: self.path)
                
                let destinationUrl = fileUrl.appendingPathComponent(url.lastPathComponent)
                
                if FileManager().fileExists(atPath: destinationUrl.path) {
                    print("文件重复")
                } else {
                    if let myAudioDataFromUrl = try? Data(contentsOf: url){
                        if (try? myAudioDataFromUrl.write(to: destinationUrl, options: [.atomic])) != nil {
                            self.success!()
                        } else {
                            self.error!()
                        }
                    }
                }
            }
            
        }
        

        
        
    }
    
    
    
    func ping(_ title1: String, title2: String) {
        
        queue.sync {
            
            let task = Task(launchPath: "/usr/bin/python",
                            arguments: ["fetch-timeout.py", "\(title2).json"],
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
    
    
    func export(_ title1: String) {
        queue.sync {
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
