//
//  PreferencesWindow.swift
//  Red Ocher
//
//  Created by Ivo Gregurec on 12.05.2023..
//

import Foundation
import SwiftUI
import Cocoa

struct PreferencesWindow: View {
    var body: some View {
        TabView {
            ShortcutSettingsView()
                    .tabItem {
                        Label("Shortcut", systemImage: "keyboard")
                    }
                
            LanguageSettingsView()
                    .tabItem {
                        Label("Language", systemImage: "globe")
                    }
                
                }
                .frame(width: 500, height: 300)
                .padding(20)
        
    }
}

//--------------- shortcut settings ---------------//
struct ShortcutSettingsView: View {
    let options = ["Shift-Control-Command-0", "Control-Option-Command-0", "Control-Option-Command-O", "Custom"]
    
    @State var selectedOption = "Shift-Control-Command-0"
    @State var customOption = ""
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Select an option:")
                .font(.headline)
            RadioButtonsView(options: options, selectedOption: $selectedOption)
            if selectedOption == "Custom" {
                TextField("Custom option", text: $customOption)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
        }
        .padding(16)
    }
}

struct RadioButtonsView: View {
    var options: [String]
    @Binding var selectedOption: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ForEach(options, id: \.self) { option in
                RadioButton(text: option, selected: selectedOption == option) {
                    selectedOption = option
                }
            }
        }
    }
}

struct RadioButton: View {
    var text: String
    var selected: Bool
    var action: () -> Void
    
    @FocusState private var isFocused: Bool
    
    var body: some View {
        Button(action: action) {
            HStack {
                Circle()
                    .strokeBorder(selected ? Color.clear : Color.gray, lineWidth: 1)
                    .frame(width: 16, height: 16)
                    .background(Circle().fill(selected ? Color.accentColor : Color.white))
                    .overlay(Circle().fill(selected ? Color.white : Color.clear).frame(width: 6, height: 6))
                
                Text(text)
            }
            .foregroundColor(Color.primary)
        }
        .focusable(true)
        .buttonStyle(PlainButtonStyle())
        .overlay(
            Circle()
                .stroke(Color.accentColor, lineWidth: 2)
                .opacity(isFocused ? 1 : 0)
        )
    }
}
//--------------- language settings ---------------//
 
struct LanguageSettingsView: View {
    var body: some View {
        Text("Appearance Settings")
            .font(.title)
    }
}


struct PreferencesWindow_Previews: PreviewProvider {
    static var previews: some View {
        PreferencesWindow()
    }
}
