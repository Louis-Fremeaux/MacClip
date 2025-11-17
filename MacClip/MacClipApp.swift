//
//  MacClipApp.swift
//  MacClip
//
//  Created by Louis FREMEAUX on 22/09/2025.
//

import SwiftUI

@main
struct MacClipApp: App {
    var body: some Scene {
        //WindowGroup {
          //  ContentView()
        //}
        
        MenuBarExtra() {
            Button(){
                //copyAction
            }label: {
                Label("Copy", systemImage: "document.on.document")
            }.keyboardShortcut("c", modifiers: [.command])
            
            Button(){
                //pasteAction()
            }label: {
                Label("Paste", systemImage: "document.on.clipboard")
            }.keyboardShortcut("v", modifiers: [.command])
            
            Divider()
            
            Button(){
                quitApp()
            }label: {
                Label("Quitter MacClip", systemImage: "xmark.octagon")
            }
        }label: {
            Label("", systemImage: "clipboard")
        }
    }
    
    func quitApp() {
        NSApplication.shared.terminate(nil)
    }
}
