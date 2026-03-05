import Foundation
import SwiftUI

enum RarityLevel: String, CaseIterable, Codable, Identifiable {
    case common = "Common"
    case uncommon = "Uncommon"
    case rare = "Rare"
    case epic = "Epic"
    case legendary = "Legendary"
    case mythic = "Mythic"
    
    var id: String { rawValue }
    
    var color: Color {
        switch self {
        case .common, .uncommon:
            return .lootCommon
        case .rare, .epic, .legendary, .mythic:
            return .lootRare
        }
    }
    
    var icon: String {
        switch self {
        case .common: return "circle"
        case .uncommon: return "circle.fill"
        case .rare: return "diamond"
        case .epic: return "diamond.fill"
        case .legendary: return "star"
        case .mythic: return "star.fill"
        }
    }
}

enum ItemType: String, CaseIterable, Codable, Identifiable {
    case weapon = "Weapon"
    case armor = "Armor"
    case accessory = "Accessory"
    case consumable = "Consumable"
    case crafting = "Crafting material"
    case currency = "Currency"
    case quest = "Quest item"
    case other = "Other"
    
    var id: String { rawValue }
    
    var icon: String {
        switch self {
        case .weapon: return "shield.fill"
        case .armor: return "person.fill"
        case .accessory: return "circle.fill"
        case .consumable: return "flask.fill"
        case .crafting: return "hammer.fill"
        case .currency: return "bitcoinsign.circle"
        case .quest: return "questionmark.circle"
        case .other: return "archivebox"
        }
    }
}

enum DropSource: String, CaseIterable, Codable, Identifiable {
    case boss = "Boss"
    case chest = "Chest"
    case mob = "Mob"
    case quest = "Quest"
    case crafting = "Crafting"
    case vendor = "Vendor"
    case event = "Event"
    case other = "Other"
    
    var id: String { rawValue }
}

struct Game: Identifiable, Codable {
    let id: UUID
    var name: String
    var iconName: String?
    var isFavorite: Bool
}

struct Character: Identifiable, Codable {
    let id: UUID
    var name: String
    var gameId: UUID?
    var gameName: String
    var level: Int?
    var className: String?
    var isMain: Bool
}

struct DropLocation: Identifiable, Codable {
    let id: UUID
    var name: String
    var gameId: UUID?
    var gameName: String
    var sourceType: DropSource
    var difficulty: String?
    var notes: String?
}

struct LootItem: Identifiable, Codable {
    let id: UUID
    var name: String
    var type: ItemType
    var rarity: RarityLevel
    var value: Int?
    var ilvl: Int?
    var description: String?
    var iconName: String?
}

struct LootDrop: Identifiable, Codable {
    let id: UUID
    let date: Date
    
    var itemId: UUID
    var itemName: String
    var itemType: ItemType
    var itemRarity: RarityLevel
    var quantity: Int
    
    var sourceId: UUID?
    var sourceName: String
    var sourceType: DropSource
    var gameId: UUID?
    var gameName: String
    
    var recipientId: UUID?
    var recipientName: String?
    var recipientClass: String?
    
    var isBound: Bool
    var isTradable: Bool
    var notes: String?
    var screenshotName: String?
    
    var isFavorite: Bool
    let creationDate: Date
}

struct LootSession: Identifiable, Codable {
    let id: UUID
    let date: Date
    var gameId: UUID?
    var gameName: String
    var locationId: UUID?
    var locationName: String
    var sourceType: DropSource
    var duration: Int?
    var participants: [String]?
    var drops: [LootDrop]
    var notes: String?
    var isFavorite: Bool
}

