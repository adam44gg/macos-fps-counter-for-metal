//
//  AppDelegate.swift
//  metalfpsenabler
//
//  Created by Adam S on 12/1/22.
//

import Cocoa

class AppDelegate: NSObject, NSApplicationDelegate {
    
    private var statusItem: NSStatusItem!
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        
        if let button = statusItem.button {
            button.image = NSImage(systemSymbolName: "gamecontroller", accessibilityDescription: nil)
        }
        
        setupMenus()
    }
    
    func setupMenus() {
        let menu = NSMenu()
        
        let enabler = NSMenuItem(title: "Enable FPS Counter", action: #selector(didTapOne) , keyEquivalent: "1")
        if(!getenvMTL()) {
            enabler.title = "Enable FPS Counter"
        }
        else if (getenvMTL()) {
            enabler.title = "Disable FPS Counter"
        }
        menu.addItem(enabler)
        
        menu.addItem(NSMenuItem.separator())
        
        menu.addItem(NSMenuItem(title: "Quit", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q"))
        
        statusItem.menu = menu
    }
    
    @objc func didTapOne() {
        let task = Process()
        task.executableURL = URL(filePath: "/bin/launchctl")
        if (getenvMTL()) {
            task.arguments = [ "setenv", "MTL_HUD_ENABLED", "0"]
        }
        else if (!getenvMTL()) {
            task.arguments = [ "setenv", "MTL_HUD_ENABLED", "1"]
        }
        try! task.run()
        task.waitUntilExit()
        setupMenus()
    }
    
    func getenvMTL() -> Bool {    //Returns True if HUD Enabled, False if Disabled
        let getenv = Process()
        let output = Pipe()
        getenv.executableURL = URL(filePath: "/bin/launchctl")
        getenv.arguments = ["getenv", "MTL_HUD_ENABLED"]
        getenv.standardOutput = output
        try! getenv.run()
        getenv.waitUntilExit()
        let outputData = try! output.fileHandleForReading.readToEnd()
        let outputString = String(decoding: outputData!, as: UTF8.self)
        if(outputString.contains("0")) {
            return false;
        }
        else if (outputString.contains("1")){
            return true;
        }
        return true;
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        return true
    }


}

