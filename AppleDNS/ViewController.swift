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
        
        
        
    }
    
    @IBOutlet weak var cleanDNSCacheButton: NSButton!
    @IBOutlet var text: NSTextView!
    
    @IBOutlet weak var runButton: NSButton!
    
    var downloadFiles: DownloadFiles!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        runButton.enabled = false
        cleanDNSCacheButton.enabled = false
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
    
    
    
    


}

