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
    private var appDelegate

    var body: some Scene {
      
        WindowGroup {
            EmptyView()
                .frame(width: .zero)
        }
      
        WindowGroup {
            ContentView()
        }
        .handlesExternalEvents(matching: ["myScene"])
    }
}

import Foundation
//import AppKit
//import SwiftUI
import Cocoa



final class AppDelegate: NSObject, NSApplicationDelegate {
    
    private var menuExtrasConfigurator: MacExtrasConfigurator?
    
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
                captureItem.action = #selector(captureScreen)
                captureItem.keyEquivalent = "Ø"
                
                let aboutItem = NSMenuItem()
                aboutItem.title = "About"
                aboutItem.target = self
                aboutItem.action = #selector(openAbout)
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
        
        private func showPreferencesWindow(selectedTab: Int = 0) {
            if preferencesWindow == nil {
                let preferencesView = PreferencesWindow()
                let preferencesHostingView = NSHostingView(rootView: preferencesView)
                let preferencesFrame = NSRect(x: 0, y: 0, width: 400, height: 300)
                let styleMask: NSWindow.StyleMask = [.titled, .closable, .miniaturizable, .resizable]

                preferencesWindow = NSWindow(contentRect: preferencesFrame, styleMask: styleMask, backing: .buffered, defer: false)
                preferencesWindow?.title = "Preferences"
                preferencesWindow?.contentView = preferencesHostingView
            }

            if let tabView = preferencesWindow?.contentView?.subviews.first as? NSTabView {
                tabView.selectTabViewItem(at: selectedTab)
            }

            preferencesWindow?.makeKeyAndOrderFront(nil)
        }
        
        // MARK: - Actions
        
        @objc private func rootAction(_ sender: Any?) {
            openURL(URL(string: "myApp://myScene")!)
        }
        
        @objc private func captureScreen() {
            // activate the functionality from the tessarect app
        }
        //private var aboutWindow: NSWindow?

        @objc func openAbout() {
            let aboutWindow = AboutWindow()
                aboutWindow.makeKeyAndOrderFront(nil)
            }
        
        @objc private func preferencesAction(_ sender: Any?) {
            showPreferencesWindow(selectedTab: 0)
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
    }
}
