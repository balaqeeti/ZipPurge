//
//  AppDelegate.swift
//  ZipPurge
//
//  Created by admin on 2/8/17.
//  Copyright © 2017 Jett Raines. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    var item : NSStatusItem? = nil


    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        
        item = NSStatusBar.system().statusItem(withLength: NSVariableStatusItemLength)
        item?.title = "ZipPurge"
        item?.action = #selector(AppDelegate.zipPurge)
        
        let menu = NSMenu()
        menu.addItem(NSMenuItem(title: "Select Directories", action: #selector(AppDelegate.zipPurge), keyEquivalent: "S"))
        menu.addItem(NSMenuItem(title: "Quit", action: #selector(AppDelegate.quit), keyEquivalent: "Q"))
        
        item?.menu = menu
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    func zipPurge() {
        print("Lets getem!")
        let panel: NSOpenPanel? = NSOpenPanel()
        panel?.title = "Select Directory to delete all ZIP files from"
        panel?.allowsMultipleSelection = true
        panel?.canChooseFiles = false
        panel?.canChooseDirectories = true
        panel?.allowedFileTypes = ["zip"]
        
        panel?.begin(completionHandler: { (result) in
            if result == NSFileHandlingPanelOKButton {
                
                // Alert user that they are about to delete files
                let answer = self.warning(question: "Are you sure?", text: "You are about to delete all '.zip' files from the specified directories")
                
                if answer == true {
                if let chosenDirectories = panel?.urls {
                    
                    // Iterate through the multiple directories selected
                    for directory in chosenDirectories {
                        
                        print("\(directory)")
                        do {
                            let contentArray =  try FileManager.default.contentsOfDirectory(at: directory, includingPropertiesForKeys: [], options: FileManager.DirectoryEnumerationOptions(rawValue: 0))
                            
                            // Iterate through specific file paths of the directory
                            for url in contentArray {
                                if url.absoluteString.contains("zip") {
                                    print(url)
                                    do {
                                        try FileManager.default.removeItem(at: url)
                                        print("Deleted!")
                                    } catch {
                                        print("Items not deleted")
                                    }
                                }
                                
                            }
                        } catch {
                            print ("Directory not selected")
                        }
                        print("Purge Complete, no more ZIP files here")
                        
                    }
                    
                }
                } else {
                    print("secondary dialogue box canceled")
                }
            } else {
                panel?.close()
                print("Canceled")
            }

            
        })
        
        
    }
    
    func quit() {
        NSApplication.shared().terminate(self)
    }
    
    func warning(question: String, text: String) -> Bool {
        let myPopup: NSAlert = NSAlert()
        myPopup.messageText = question
        myPopup.informativeText = text
        myPopup.alertStyle = NSAlertStyle.warning
        myPopup.addButton(withTitle: "Purge!")
        myPopup.addButton(withTitle: "Cancel")
        return myPopup.runModal() == NSAlertFirstButtonReturn
    }

}

