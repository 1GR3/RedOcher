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
                
            DonationView()
                    .tabItem {
                        Label("Donate", systemImage: "gift")
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
 
//--------------- donate settings ---------------//
 
struct DonationView: View {
    let amounts = ["$1", "$5", "$10"]
    
    @State var selectedAmount: String = ""
    @State var customAmount: String = ""
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("You've been using Red Ocher XX times. If you like it, consider donating for maintainance and further development.")
                .font(.headline)
            
            HStack(spacing: 10) {
                ForEach(amounts, id: \.self) { amount in
                    Button(action: {
                        selectedAmount = amount
                    }) {
                        HStack {
                            Text(amount)
                                .foregroundColor(selectedAmount == amount ? .white : .primary)
                                .font(.headline)
                            
                            Spacer()
                            
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(selectedAmount == amount ? .white : .clear)
                        }
                        .padding()
                        .background(selectedAmount == amount ? Color.accentColor : Color.gray.opacity(0.2))
                        .cornerRadius(8)
                    }
                    .buttonStyle(BorderlessButtonStyle())
                }
            }

            
            HStack {
                Button(action: {
                    selectedAmount = ""
                }) {
                    HStack {
                        Image(systemName: "circle")
                            .foregroundColor(selectedAmount.isEmpty ? .accentColor : .clear)
                        
                        Text("Custom")
                            .foregroundColor(.primary)
                            .font(.headline)
                    }
                    .padding()
                    .background(selectedAmount.isEmpty ? Color.accentColor.opacity(0.1) : Color.gray.opacity(0.1))
                    .cornerRadius(8)
                }
                .buttonStyle(BorderlessButtonStyle())
                
                TextField("Enter custom amount", text: $customAmount)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(width: 100)
                    .disabled(selectedAmount != "")
            }
            
            Button(action: {
                //TODO: Integrate with PayPal
            }) {
                Text("Donate")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.accentColor)
                    .cornerRadius(8)
            }
            .disabled(selectedAmount.isEmpty && customAmount.isEmpty)
        }
        .padding(16)
    }
}


struct PreferencesWindow_Previews: PreviewProvider {
    static var previews: some View {
        PreferencesWindow()
    }
}
