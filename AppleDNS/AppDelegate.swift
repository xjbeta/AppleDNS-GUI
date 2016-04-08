//
//  AppDelegate.swift
//  AppleDNS
//
//  Created by xjbeta on 16/4/7.
//  Copyright © 2016年 xjbeta. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBAction func about(sender: AnyObject) {
        
        if let url = NSURL(string: "https://github.com/gongjianhui/AppleDNS") {
            NSWorkspace.sharedWorkspace().openURL(url)
        }

        
    }
    func applicationDidFinishLaunching(aNotification: NSNotification) {
        // Insert code here to initialize your application
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }


}

