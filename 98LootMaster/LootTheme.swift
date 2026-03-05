import SwiftUI

extension Color {
    static let lootBackground = Color(red: 0.102, green: 0.173, blue: 0.220)
    static let lootRare = Color(red: 0.078, green: 0.459, blue: 0.882)
    static let lootCommon = Color(red: 0.086, green: 1.0, blue: 0.086)
}

func formattedDate(_ date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    formatter.timeStyle = .short
    return formatter.string(from: date)
}

func formattedShortDate(_ date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "dd.MM"
    return formatter.string(from: date)
}

