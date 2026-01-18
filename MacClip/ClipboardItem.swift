import Foundation

struct ClipboardItem: Identifiable, Codable {
    let id: UUID
    let content: String
    let date: Date
}
