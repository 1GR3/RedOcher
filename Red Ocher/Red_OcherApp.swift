//
//  Red_OcherApp.swift
//  Red Ocher
//
//  Created by Ivo Gregurec on 12.05.2023..
//

import SwiftUI
import AppKit

@main
struct Red_OcherApp: App {
    
    @NSApplicationDelegateAdaptor(AppDelegate.self)
    var appDelegate: AppDelegate

    var body: some Scene {
      
        WindowGroup {
            EmptyView()
                .frame(width: .zero)
        }
      
//        WindowGroup {
//            ContentView()
//        }
        .handlesExternalEvents(matching: ["myScene"])
    }
}

import Foundation
//import AppKit
//import SwiftUI
import Cocoa



final class AppDelegate: NSObject, NSApplicationDelegate {
    
    private var menuExtrasConfigurator: MacExtrasConfigurator?
    private var eventMonitor: Any?
    
    static var shared: AppDelegate!
    
    
    final private class MacExtrasConfigurator: NSObject {
        
        private var statusBar: NSStatusBar
        private var statusItem: NSStatusItem
        private var mainView: NSView
        
        
        private struct MenuView: View {
            var body: some View {
                HStack {
                    Text("Hello from SwiftUI View")
                    Spacer()
                }
                .background(Color.blue)
                .padding()
            }
        }
        
        @Environment(\.openURL) private var openURL
        
        private var preferencesWindow: NSWindow?
        private var aboutWindow: NSWindow?
        
        
            
        
        // MARK: - Lifecycle
        
        override init() {
            statusBar = NSStatusBar.system
            statusItem = statusBar.statusItem(withLength: NSStatusItem.squareLength)
            mainView = NSHostingView(rootView: MenuView())
            mainView.frame = NSRect(x: 0, y: 0, width: 300, height: 250)
            
            super.init()
            
            createMenu()
        }
        
        // MARK: - Private
        
        // MARK: - MenuConfig
        
        private func createMenu() {
            if let statusBarButton = statusItem.button {
                statusBarButton.image = NSImage(named: "menuBarIcon-B@2x.png")
                statusBarButton.image?.isTemplate = true
                
                let captureItem = NSMenuItem()
                captureItem.title = "Capture!"
                captureItem.target = self
                captureItem.action = #selector(captureFromMenu)
                captureItem.keyEquivalent = "Ø"
                
                let aboutItem = NSMenuItem()
                aboutItem.title = "About"
                aboutItem.target = self
                aboutItem.action = #selector(openAbout(_:))
                aboutItem.keyEquivalent = "a"
                
                let preferencesItem = NSMenuItem()
                preferencesItem.title = "Preferences"
                preferencesItem.target = self
                preferencesItem.action = #selector(Self.preferencesAction(_:))
                preferencesItem.keyEquivalent = ","
                
                let donateItem = NSMenuItem()
                donateItem.title = "Donate"
                donateItem.target = self
                donateItem.action = #selector(openDonate)
                donateItem.keyEquivalent = "d"
                
                let quitItem = NSMenuItem()
                quitItem.title = "Quit"
                quitItem.target = self
                quitItem.keyEquivalent = "q"
                quitItem.action = #selector(quitApplication(_:))
                
                
                let mainMenu = NSMenu()
                mainMenu.addItem(captureItem)
                mainMenu.addItem(NSMenuItem.separator())
                mainMenu.addItem(aboutItem)
                mainMenu.addItem(preferencesItem)
                mainMenu.addItem(donateItem)
                mainMenu.addItem(NSMenuItem.separator())
                mainMenu.addItem(quitItem)
                
                statusItem.menu = mainMenu
            }
        }
        
        
        // MARK: - Actions
        
        @objc private func rootAction(_ sender: Any?) {
            openURL(URL(string: "myApp://myScene")!)
        }
        
        @objc private func captureFromMenu() {
            // activate the functionality from the tessarect app
            print("captured from menu")
            CaptureHelper.captureScreen()
        }
        //private var aboutWindow: NSWindow?

        @objc func openAbout(_ sender: Any?) {
            let aboutWindow = AboutWindow()
                aboutWindow.makeKeyAndOrderFront(nil)
        }
        
        @objc private func preferencesAction(_ sender: Any?) {
            if preferencesWindow == nil {
                let preferencesView = PreferencesWindow()
                let preferencesHostingView = NSHostingView(rootView: preferencesView)
                let preferencesFrame = NSRect(x: 500, y: 500, width: 400, height: 300)
                let styleMask: NSWindow.StyleMask = [.titled, .closable, .miniaturizable, .resizable]

                preferencesWindow = NSWindow(contentRect: preferencesFrame, styleMask: styleMask, backing: .buffered, defer: false)
                preferencesWindow?.title = "Preferences"
                preferencesWindow?.contentView = preferencesHostingView
            }

            preferencesWindow?.makeKeyAndOrderFront(nil)
        }
                
        @objc private func openDonate(_ sender: Any?) {
            let url = URL(string: "https://ivo.gregurec.info")!
            if NSWorkspace.shared.open(url) {
                print("default browser was successfully opened")

            }
        }
        
        @objc private func quitApplication(_ sender: Any?) {
            NSApp.terminate(nil)
        }
    }
    
    // MARK: - NSApplicationDelegate
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        menuExtrasConfigurator = .init()
        registerGlobalShortcut()
    }
    
    
    
    // -------------- global shortcut listener --------------- //
    
    
    func applicationWillTerminate(_ notification: Notification) {
        unregisterGlobalShortcut()
    }
    
    private func registerGlobalShortcut() {
        print("registerGlobalShortcut")
        let keyMask: NSEvent.ModifierFlags = [.command, .control, .option]
        let keyCode: UInt16 = 7 // Example keycode for "X" key
        
        eventMonitor = NSEvent.addGlobalMonitorForEvents(matching: .keyDown) { (event) in
            if event.modifierFlags.contains(keyMask) && (event.keyCode == keyCode) {
                self.captureShortcutHandler()
            }
        }
    }
    
    private func unregisterGlobalShortcut() {
        if let eventMonitor = eventMonitor {
            NSEvent.removeMonitor(eventMonitor)
            self.eventMonitor = nil
        }
    }
    

    
    @objc private func captureShortcutHandler() {
        // Handle the global shortcut event here
        // Perform any action or trigger any functionality when the shortcut is pressed
        print("captured with shortcut")
        // Display a notification
        CaptureHelper.captureScreen()
    }
    
    
}

final class CaptureHelper {
    
    struct CaptureWindow: View {
        var body: some View {
            VStack {
                Text("Capture Window")
                    .font(.title)
                    .padding()
                Button("Close") {
                    NSApp.keyWindow?.close()
                }
                .padding()
            }
        }
    }
    
    static func captureScreen() {
        print("ŠKLJOC!")
        // Add your capture screen functionality here
        
        let captureWindow = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 300, height: 200),
            styleMask: [.titled, .closable],
            backing: .buffered,
            defer: false
        )
        captureWindow.center()
        captureWindow.contentView = NSHostingView(rootView: CaptureWindow())
        captureWindow.makeKeyAndOrderFront(nil)
    }
}
