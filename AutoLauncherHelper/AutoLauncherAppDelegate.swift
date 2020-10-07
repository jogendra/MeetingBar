//
//  AppDelegate.swift
//  AutoLauncherHelper
//
//  Created by Jogendra on 07/10/20.
//  Copyright © 2020 Andrii Leitsius. All rights reserved.
//

import Cocoa

extension Notification.Name {
    static let killLauncher = Notification.Name("killLauncher")
}

class AutoLauncherAppDelegate: NSObject, NSApplicationDelegate {
    
    struct Constants {
        static let mainAppBundleID = "leits.MeetingBar"
    }
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        let runningApps = NSWorkspace.shared.runningApplications
        let isRunning = !runningApps.filter { $0.bundleIdentifier == Constants.mainAppBundleID }.isEmpty
        
        if !isRunning {
            DistributedNotificationCenter.default().addObserver(self, selector: #selector(self.terminate), name: .killLauncher, object: Constants.mainAppBundleID)
            
            let path = Bundle.main.bundlePath as NSString
            var components = path.pathComponents
            components.removeLast()
            components.removeLast()
            components.removeLast()
            components.append("MacOS")
            components.append("MeetingBar") //main app name
            
            let newPath = NSString.path(withComponents: components)
            
            NSWorkspace.shared.launchApplication(newPath)
        }
        else {
            self.terminate()
        }
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    @objc func terminate() {
        NSApp.terminate(nil)
    }
}

