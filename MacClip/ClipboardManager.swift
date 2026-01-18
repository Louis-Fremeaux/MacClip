//
//  ClipboardManager.swift
//  MacClip
//
//  Created by Louis FREMEAUX on 18/01/2026.
//


import AppKit
import Combine

class ClipboardManager: ObservableObject {

    @Published var history: [ClipboardItem] = []

    private let pasteboard = NSPasteboard.general
    private var lastChangeCount: Int
    private var timer: Timer?

    init() {
        lastChangeCount = pasteboard.changeCount
        load()
        startMonitoring()
    }

    func startMonitoring() {
        timer = Timer(timeInterval: 1, repeats: true) { _ in
            self.checkPasteboard()
        }
        RunLoop.main.add(timer!, forMode: .common)
    }

    private func checkPasteboard() {
        guard pasteboard.changeCount != lastChangeCount else { return }
        lastChangeCount = pasteboard.changeCount

        if let text = pasteboard.string(forType: .string) {
            saveNewItem(text)
        }
    }

    private func saveNewItem(_ text: String) {
        guard history.first?.content != text else { return }

        let item = ClipboardItem(id: UUID(), content: text, date: Date())
        history.insert(item, at: 0)
        save()
    }

    private var fileURL: URL {
        let dir = FileManager.default.urls(
            for: .applicationSupportDirectory,
            in: .userDomainMask
        ).first!

        let folder = dir.appendingPathComponent("MacClip", isDirectory: true)
        if !FileManager.default.fileExists(atPath: folder.path) {
            try? FileManager.default.createDirectory(at: folder, withIntermediateDirectories: true)
        }

        return folder.appendingPathComponent("clipboard.json")
    }

    private func save() {
        if let data = try? JSONEncoder().encode(history) {
            try? data.write(to: fileURL)
        }
    }

    private func load() {
        guard let data = try? Data(contentsOf: fileURL),
              let items = try? JSONDecoder().decode([ClipboardItem].self, from: data)
        else { return }

        history = items
    }
    
    public func clear() {
        try? FileManager.default.removeItem(at: fileURL)
        history.removeAll()
    }
}
