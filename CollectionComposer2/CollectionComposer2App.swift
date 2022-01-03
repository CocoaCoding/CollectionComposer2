//
//  CollectionComposer2App.swift
//  CollectionComposer2
//
//  Created by Holger Hinzberg on 03.01.22.
//

import SwiftUI

@main
struct CollectionComposer2App: App {
    
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
    
}

class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ notification: Notification)
    {
        FileBookmarkHandler.shared.loadBookmarks()
    }
}
