//
//  AppDelegate.swift
//  metalfpsenabler
//
//  Created by Adam S on 12/1/22.
//

import Cocoa

class AppDelegate: NSObject, NSApplicationDelegate {

    private var statusItem: NSStatusItem!
    private var isEnabled: Bool!
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        
        if let button = statusItem.button {
            button.image = NSImage(systemSymbolName: "gamecontroller", accessibilityDescription: nil)
        }
            
        setupMenus()
        isEnabled = true    //Metal FPS counter should be disabled before App is opened
        didTapOne()  //Disables Metal FPS Counter if it is enabled before opening app.
    }

    func setupMenus() {
        let menu = NSMenu()
        
        let enabler = NSMenuItem(title: "Enable FPS Counter", action: #selector(didTapOne) , keyEquivalent: "1")
        if(isEnabled == false) {
            enabler.title = "Enable FPS Counter"
        }
        else {
            enabler.title = "Disable FPS Counter"
        }
        menu.addItem(enabler)
        
        menu.addItem(NSMenuItem.separator())
        
        menu.addItem(NSMenuItem(title: "Quit", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q"))
        
        statusItem.menu = menu
    }
            
    @objc func didTapOne() {
        let task = Process()
        task.launchPath = "/bin/launchctl"
        if (isEnabled) {
            task.arguments = [ "setenv", "MTL_HUD_ENABLED", "0"]
            isEnabled = false
        }
        else if (!isEnabled) {
            task.arguments = [ "setenv", "MTL_HUD_ENABLED", "1"]
            isEnabled = true
            
        }
        task.launch()
        setupMenus()
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
        if (isEnabled) {
            didTapOne()
        }
    }

    func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        return true
    }


}

