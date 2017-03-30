//
//  ViewController.swift
//  AppleDNS
//
//  Created by xjbeta on 16/4/7.
//  Copyright © 2016年 xjbeta. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
	
    @IBOutlet var text: NSTextView!
	
    override func viewDidLoad() {
        super.viewDidLoad()
		downloadFilesHandle()
    }

	
	func downloadFilesHandle() {
		var text = "Downloading master from Github" + "\n"
				self.text.string = text
		DownloadFiles.shared.success = {
			text += "Download Success" + "\n"
			
			DispatchQueue.main.async {
				self.text.string = text
			}
			DownloadFiles.shared.unzip()
		}
		DownloadFiles.shared.error = {
			text += "Download Error" + "\n"
			DispatchQueue.main.async {
				self.text.string = text
			}
		}
		
		
		DownloadFiles.shared.notification = { str in
			text += str + "\n"
			DispatchQueue.main.async {
				self.text.string = text
				self.text.scrollRangeToVisible(NSMakeRange((self.text.string?.characters.count)!, 0))
			}
		}
		
		DownloadFiles.shared.export = { str in
			DispatchQueue.main.async {
				self.text.string = str
			}
		}
		
		
		
		DownloadFiles.shared.unzipSuccess = {
			text += "unzip Success" + "\n"
			DispatchQueue.main.async {
				self.text.string = text
				if let items = self.view.window?.toolbar?.items {
					for i in items {
						i.isEnabled = true
					}
				}
			}
			
		}
	}
	
}

