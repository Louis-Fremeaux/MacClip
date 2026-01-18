//
//  MacClipApp.swift
//  MacClip
//
//  Created by Louis FREMEAUX on 22/09/2025.
//

import SwiftUI

@main
struct MacClipApp: App {
    
    @StateObject private var clipboardManager = ClipboardManager()
    @State private var showAlert = false
    
    var body: some Scene {
        
        MenuBarExtra() {
            
            ForEach(Array(clipboardManager.history.prefix(10))) { item in
                Button(item.content.count > 30 ? String(item.content.prefix(27)) + "..." : item.content) {
                    NSPasteboard.general.clearContents()
                    NSPasteboard.general.setString(item.content, forType: .string)
                }
            }
            
            Divider()
            
            Button(){
                showAlert = true
            }label: {
                Label("Effacer l'historique", systemImage: "eraser")
            }
            
            Button(){
                quitApp()
            }label: {
                Label("Quitter MacClip", systemImage: "xmark.octagon")
            }
            
        }label: {
            Label("", systemImage: "clipboard")
        }
        
        AlertScene("Effacer l'historique?", isPresented: $showAlert) {
            Button("Annuler", role: .cancel) {}
            Button("Confirmer", role: .destructive) {clipboardManager.clear()}
        }message: {
            Text("Attention vous allez supprimer l'historique!")
        }
    }
    
    func quitApp() {
        NSApplication.shared.terminate(nil)
    }
}
