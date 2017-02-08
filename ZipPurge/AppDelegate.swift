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
        menu.addItem(NSMenuItem(title: "Purge", action: #selector(AppDelegate.zipPurge), keyEquivalent: "P"))
        menu.addItem(NSMenuItem(title: "Quit", action: #selector(AppDelegate.quit), keyEquivalent: "Q"))
        
        item?.menu = menu
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    func zipPurge() {
        print("Lets getem!")
        let panel: NSOpenPanel? = NSOpenPanel()
        
        panel?.allowsMultipleSelection = true
        panel?.canChooseFiles = false
        panel?.canChooseDirectories = true
        panel?.allowedFileTypes = ["zip"]
        
        panel?.runModal()
        
        if let chosenDirectories = panel?.urls {
           
            //print("Nice")
            //print("\(chosenDirectories)")
            for directory in chosenDirectories {
            
                print("\(directory)")
                do {
                   let contentArray =  try FileManager.default.contentsOfDirectory(at: directory, includingPropertiesForKeys: [], options: FileManager.DirectoryEnumerationOptions(rawValue: 0))
                    //print("\(contentArray)")
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
                
            }
        
        }
    }
    
    func quit() {
        NSApplication.shared().terminate(self)
    }

}

