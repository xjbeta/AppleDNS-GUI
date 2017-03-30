//
//  MainWindow.swift
//  AppleDNS
//
//  Created by xjbeta on 2016/12/10.
//  Copyright © 2016年 xjbeta. All rights reserved.
//

import Cocoa

class MainWindow: NSWindowController {
	@IBOutlet var runButton: NSToolbarItem!
	@IBAction func runButton(_ sender: NSToolbarItem) {
		if let title1 = selectButton.titleOfSelectedItem,
			let title2 = selectNetworkButton.titleOfSelectedItem {
			DownloadFiles.shared.ping(title1, title2: title2)
		}
		
		
	}
	@IBOutlet var cleanDNSButton: NSButton!
	@IBAction func cleanDNSButton(_ sender: NSToolbarItem) {
		cleanDNS()
	}
	@IBOutlet var selectButton: NSPopUpButton!
	@IBOutlet var selectNetworkButton: NSPopUpButton!
	
	var downloadFiles: DownloadFiles!
    override func windowDidLoad() {
        super.windowDidLoad()
		initWindow()
		runButton.isEnabled = false
		DownloadFiles.shared.clearFiles()
		DownloadFiles.shared.setPath()
		DownloadFiles.shared.downloadFile()
    }
	
	func initWindow() {
		window?.titlebarAppearsTransparent = true
		window?.titleVisibility = .hidden
		window?.isMovableByWindowBackground = true
		
		window?.backgroundColor = NSColor(calibratedRed: 0.35, green: 0.85, blue: 1, alpha: 1)
		window?.contentView?.wantsLayer = true
	}
	
	func cleanDNS() {
		
		switch floor(NSAppKitVersionNumber) {
		case Double(NSAppKitVersionNumber10_10)...Double(NSAppKitVersionNumber10_10_3):
			doScriptWithAdmin("sudo discoveryutil mdnsflushcache")
		case 0..<Double(NSAppKitVersionNumber10_10): break
		default:
			doScriptWithAdmin("sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder")
		}
		
	}
	
	
	func doScriptWithAdmin(_ inScript: String){
		let script = "do shell script \"\(inScript)\" with administrator privileges"
		let appleScript = NSAppleScript(source: script)!
		let text = appleScript.executeAndReturnError(nil)
		
		if let str = text.stringValue {
			if str == "" {
				cleanDNSButton.title = "success"
			} else {
				cleanDNSButton.title = str
			}
		}
		
	}


}
