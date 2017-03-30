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

    @IBAction func about(_ sender: AnyObject) {
        if let url = URL(string: "https://github.com/gongjianhui/AppleDNS") {
            NSWorkspace.shared().open(url)
        }
    }
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

