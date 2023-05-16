//
//  AboutView.swift
//  Red Ocher
//
//  Created by Ivo Gregurec on 16.05.2023..
//

import Cocoa

class AboutWindow: NSWindow {
    
    static var shared: AboutWindow?
    
    init() {
        let contentRect = NSRect(x: 0, y: 0, width: 400, height: 300)
        super.init(contentRect: contentRect, styleMask: [.titled, .closable], backing: .buffered, defer: false)
        AboutWindow.shared = self
        
        self.title = "About"
        self.center()
        self.contentView = NSView(frame: contentRect)
        self.contentView?.wantsLayer = true
        
        // Calculate the horizontal center
        let centerX = contentRect.width / 2
        
        // Add the app icon image view
        let appIconImageView = NSImageView(frame: NSRect(x: centerX - 50, y: 170, width: 100, height: 100))
        appIconImageView.image = NSApplication.shared.applicationIconImage
        appIconImageView.alignment = .center
        self.contentView?.addSubview(appIconImageView)
        
        // Add the app logo image view
        let appLogoImageView = NSImageView(frame: NSRect(x: centerX - 142, y: 60, width: 285, height: 120))
        appLogoImageView.image = NSImage(named: "RedOcher-logo.png")
        appLogoImageView.alignment = .center
        self.contentView?.addSubview(appLogoImageView)
        
        // Add the explanation label
        let explanationLabel = NSTextField(labelWithString: "Simple way to get a precise and robust OCR out of screenshot")
        explanationLabel.frame = NSRect(x: 0, y: 60, width: contentRect.width, height: 20)
        explanationLabel.alignment = .center
        self.contentView?.addSubview(explanationLabel)
        
        // Add the version label
        let versionLabel = NSTextField(labelWithString: "Version 1.0")
        versionLabel.frame = NSRect(x: 0, y: 40, width: contentRect.width, height: 20)
        versionLabel.alignment = .center
        self.contentView?.addSubview(versionLabel)
        
        // Add the website link button
        let websiteLinkButton = NSButton(frame: NSRect(x: 0, y: 20, width: contentRect.width, height: 20))
        websiteLinkButton.title = "www.gregurec.info"
        websiteLinkButton.isBordered = false
        websiteLinkButton.attributedTitle = NSAttributedString(string: websiteLinkButton.title, attributes: [.link: "http://www.gregurec.info"])
        websiteLinkButton.alignment = .center
        websiteLinkButton.target = self
        websiteLinkButton.action = #selector(websiteLinkButtonClicked(_:))
        self.contentView?.addSubview(websiteLinkButton)
        
//        // Add the copyright label
//        let currentYear = Calendar.current.component(.year, from: Date())
//        let copyrightLabel = NSTextField(labelWithString: "© Your Company \(currentYear)")
//        copyrightLabel.frame = NSRect(x: 0, y: 20, width: contentRect.width, height: 20)
//        copyrightLabel.alignment = .center
//        self.contentView?.addSubview(copyrightLabel)
        
        self.delegate = self
    }
    
    @objc private func websiteLinkButtonClicked(_ sender: Any) {
        if let url = URL(string: "http://www.gregurec.info") {
            NSWorkspace.shared.open(url)
        }
    }
    
    override var canBecomeKey: Bool {
        return true
    }
    
    override var canBecomeMain: Bool {
        return true
    }
    
    
    
}

extension AboutWindow: NSWindowDelegate {
    func windowWillClose(_ notification: Notification) {
        // Release the shared reference to the AboutWindow instance
        AboutWindow.shared = nil
    }
}
