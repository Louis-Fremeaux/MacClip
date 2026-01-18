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

    // 🔁 Surveillance du presse-papiers
    func startMonitoring() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { _ in
            self.checkPasteboard()
        }
    }

    private func checkPasteboard() {
        guard pasteboard.changeCount != lastChangeCount else { return }
        lastChangeCount = pasteboard.changeCount

        if let text = pasteboard.string(forType: .string) {
            saveNewItem(text)
        }
    }

    // 💾 Ajout + sauvegarde
    private func saveNewItem(_ text: String) {
        guard history.first?.content != text else { return }

        let item = ClipboardItem(id: UUID(), content: text, date: Date())
        history.insert(item, at: 0)
        save()
    }

    // 📂 Chemin fichier
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

    // 💾 Sauvegarde JSON
    private func save() {
        if let data = try? JSONEncoder().encode(history) {
            try? data.write(to: fileURL)
        }
    }

    // 📥 Chargement au démarrage
    private func load() {
        guard let data = try? Data(contentsOf: fileURL),
              let items = try? JSONDecoder().decode([ClipboardItem].self, from: data)
        else { return }

        history = items
    }
}
