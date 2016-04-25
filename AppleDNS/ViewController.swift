//
//  ViewController.swift
//  AppleDNS
//
//  Created by xjbeta on 16/4/7.
//  Copyright © 2016年 xjbeta. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    @IBOutlet weak var selectButton: NSPopUpButton!
    @IBOutlet weak var selectNetworkButton: NSPopUpButton!
    @IBAction func run(sender: AnyObject) {
        
        guard let title1 = selectButton.titleOfSelectedItem, let title2 = selectNetworkButton.titleOfSelectedItem else {
            return
        }
        
        downloadFiles.ping(title1, title2: title2)
        
        
        
    }
    @IBAction func cleanDNSCache(sender: AnyObject) {
        

        cleanDNS()
        
        
    }
    
    @IBOutlet weak var cleanDNSCacheButton: NSButton!
    @IBOutlet var text: NSTextView!
    
    @IBOutlet weak var runButton: NSButton!
    
    var downloadFiles: DownloadFiles!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        runButton.enabled = false
//        cleanDNSCacheButton.enabled = false
        downloadFiles = DownloadFiles()
        downloadFilesHandle()

    }

    
    
    override func viewDidAppear() {
        super.viewDidAppear()
        downloadFiles.clearFiles()
        downloadFiles.setPath()
        downloadFiles.downloadFile()
    }
    
    
    
    func downloadFilesHandle() {
        var text = "Downloading master from Github" + "\n"
        self.text.string = text
        downloadFiles.success = {
            text += "Download Success" + "\n"
            
            dispatch_async(dispatch_get_main_queue(), {
                self.text.string = text
            })
            
            self.downloadFiles.unzip()
            
        }
        downloadFiles.error = {
            text += "Download Error" + "\n"
            dispatch_async(dispatch_get_main_queue(), {
                self.text.string = text
            })
        }
        
        
        downloadFiles.notification = { str in
            text += str + "\n"
            dispatch_async(dispatch_get_main_queue(), {
                self.text.string = text
                self.text.scrollRangeToVisible(NSMakeRange((self.text.string?.characters.count)!, 0))
            })
            
        }
        
        downloadFiles.export = { str in
            dispatch_async(dispatch_get_main_queue(), {
                self.text.string = str
                
            })
            
        }
        
        
        
        downloadFiles.unzipSuccess = {
            text += "unzip Success" + "\n"
            dispatch_async(dispatch_get_main_queue(), {
                self.text.string = text
                self.runButton.enabled = true
            })
            
        }
        
        

    }
    
    
    
    
    func cleanDNS() {
        
        
        if (floor(NSAppKitVersionNumber) <= Double( NSAppKitVersionNumber10_9)) {
            /* On a 10.9.x or earlier system */
        } else if (floor(NSAppKitVersionNumber) <= Double(NSAppKitVersionNumber10_10)) {
            /* On a 10.10 system */
        } else if (floor(NSAppKitVersionNumber) <= Double(NSAppKitVersionNumber10_10_Max)) {
            /* on a 10.10.x system */
            
        } else {
            /* 10.11 or later system */
        }
        
        
        switch floor(NSAppKitVersionNumber) {
        case Double(NSAppKitVersionNumber10_10)...Double(NSAppKitVersionNumber10_10_3):
            doScriptWithAdmin("sudo discoveryutil mdnsflushcache")
        case 0..<Double(NSAppKitVersionNumber10_10): break
        default:
            doScriptWithAdmin("sudo killall -HUP mDNSResponder")
        }
        
    }
    
    
    func doScriptWithAdmin(inScript: String){
        let script = "do shell script \"\(inScript)\" with administrator privileges"
        let appleScript = NSAppleScript(source: script)!
        let text = appleScript.executeAndReturnError(nil)
        
        if let str = text.stringValue {
            
            if str == "" {
                cleanDNSCacheButton.title = "清理成功"
            } else {
                cleanDNSCacheButton.title = "出现一些问题"
                self.text.string = "\(str)"
            }
        }
        
    }


}

