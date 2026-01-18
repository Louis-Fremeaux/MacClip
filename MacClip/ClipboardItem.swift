//
//  ClipboardItem.swift
//  MacClip
//
//  Created by Louis FREMEAUX on 18/01/2026.
//


import Foundation

struct ClipboardItem: Identifiable, Codable {
    let id: UUID
    let content: String
    let date: Date
}
