import Foundation
import Combine

final class LootMasterViewModel: ObservableObject {
    // MARK: - Published properties
    @Published var drops: [LootDrop] = []
    @Published var sessions: [LootSession] = []
    @Published var items: [LootItem] = []
    @Published var characters: [Character] = []
    @Published var games: [Game] = []
    @Published var locations: [DropLocation] = []
    
    @Published var selectedRarity: RarityLevel?
    @Published var selectedGameId: UUID?
    @Published var selectedCharacterId: UUID?
    @Published var searchText: String = ""
    
    // MARK: - Computed properties
    var filteredDrops: [LootDrop] {
        var result = drops
        
        if let rarity = selectedRarity {
            result = result.filter { $0.itemRarity == rarity }
        }
        
        if let gameId = selectedGameId {
            result = result.filter { $0.gameId == gameId }
        }
        
        if let characterId = selectedCharacterId {
            result = result.filter { $0.recipientId == characterId }
        }
        
        if !searchText.isEmpty {
            result = result.filter {
                $0.itemName.localizedCaseInsensitiveContains(searchText) ||
                $0.sourceName.localizedCaseInsensitiveContains(searchText) ||
                $0.recipientName?.localizedCaseInsensitiveContains(searchText) == true
            }
        }
        
        return result.sorted { $0.date > $1.date }
    }
    
    var totalDrops: Int { drops.count }
    
    var legendaryCount: Int {
        drops.filter { $0.itemRarity == .legendary }.count
    }
    
    var epicCount: Int {
        drops.filter { $0.itemRarity == .epic }.count
    }
    
    var rareCount: Int {
        drops.filter { $0.itemRarity == .rare }.count
    }
    
    var commonCount: Int {
        drops.filter { $0.itemRarity == .common || $0.itemRarity == .uncommon }.count
    }
    
    var totalSessions: Int { sessions.count }
    
    var todayDrops: Int {
        let calendar = Calendar.current
        let today = Date()
        return drops.filter { calendar.isDate($0.date, inSameDayAs: today) }.count
    }
    
    var dropsByRarity: [RarityLevel: Int] {
        Dictionary(grouping: drops, by: { $0.itemRarity })
            .mapValues { $0.count }
    }
    
    var topSources: [(id: UUID?, name: String, count: Int)] {
        let sourceGroups = Dictionary(grouping: drops, by: { $0.sourceId ?? UUID() })
        let sourceCounts = sourceGroups.mapValues { $0.count }
        
        return sourceCounts.map { sourceId, count in
            let drop = drops.first { $0.sourceId == sourceId }
            return (id: sourceId, name: drop?.sourceName ?? "Unknown source", count: count)
        }
        .sorted { $0.count > $1.count }
    }
    
    var maxDropsPerDay: Int {
        let calendar = Calendar.current
        let grouped = Dictionary(grouping: drops) { drop in
            calendar.startOfDay(for: drop.date)
        }
        return grouped.map { $0.value.count }.max() ?? 0
    }
    
    // MARK: - CRUD operations
    func addGame(name: String) {
        let newGame = Game(id: UUID(), name: name, iconName: nil, isFavorite: false)
        games.append(newGame)
        saveToUserDefaults()
    }
    
    func addCharacter(name: String, gameId: UUID?, gameName: String, className: String?, isMain: Bool) {
        let newCharacter = Character(
            id: UUID(),
            name: name,
            gameId: gameId,
            gameName: gameName,
            level: nil,
            className: className,
            isMain: isMain
        )
        
        if isMain {
            for index in characters.indices {
                characters[index].isMain = false
            }
        }
        
        characters.append(newCharacter)
        saveToUserDefaults()
    }
    
    func addItem(name: String, type: ItemType, rarity: RarityLevel, ilvl: Int? = nil, description: String? = nil) -> LootItem {
        if let existing = items.first(where: { $0.name == name && $0.type == type && $0.rarity == rarity }) {
            return existing
        }
        
        let newItem = LootItem(
            id: UUID(),
            name: name,
            type: type,
            rarity: rarity,
            value: nil,
            ilvl: ilvl,
            description: description,
            iconName: nil
        )
        items.append(newItem)
        saveToUserDefaults()
        return newItem
    }
    
    func addDrop(_ drop: LootDrop) {
        drops.append(drop)
        
        if !items.contains(where: { $0.id == drop.itemId }) {
            let _ = addItem(
                name: drop.itemName,
                type: drop.itemType,
                rarity: drop.itemRarity
            )
        }
        
        saveToUserDefaults()
    }
    
    func addDrop(to sessionId: UUID, drop: LootDrop) {
        if let index = sessions.firstIndex(where: { $0.id == sessionId }) {
            sessions[index].drops.append(drop)
        }
        addDrop(drop)
    }
    
    func addSession(_ session: LootSession) {
        sessions.append(session)
        
        for drop in session.drops {
            if !drops.contains(where: { $0.id == drop.id }) {
                drops.append(drop)
            }
        }
        
        saveToUserDefaults()
    }
    
    func deleteDrop(_ drop: LootDrop) {
        drops.removeAll { $0.id == drop.id }
        for index in sessions.indices {
            sessions[index].drops.removeAll { $0.id == drop.id }
        }
        saveToUserDefaults()
    }
    
    func deleteSession(_ session: LootSession) {
        sessions.removeAll { $0.id == session.id }
        saveToUserDefaults()
    }
    
    func toggleFavoriteDrop(_ drop: LootDrop) {
        if let index = drops.firstIndex(where: { $0.id == drop.id }) {
            drops[index].isFavorite.toggle()
            saveToUserDefaults()
        }
    }
    
    func toggleMainCharacter(_ character: Character) {
        for index in characters.indices {
            characters[index].isMain = (characters[index].id == character.id)
        }
        saveToUserDefaults()
    }
    
    func dropsForCharacter(_ characterId: UUID) -> [LootDrop] {
        drops.filter { $0.recipientId == characterId }
    }
    
    func dropCount(for itemId: UUID) -> Int {
        drops.filter { $0.itemId == itemId }.count
    }
    
    func dropsOnDate(_ date: Date) -> Int {
        let calendar = Calendar.current
        return drops.filter { calendar.isDate($0.date, inSameDayAs: date) }.count
    }
    
    // MARK: - Persistence
    private let dropsKey = "lootmaster_drops"
    private let sessionsKey = "lootmaster_sessions"
    private let itemsKey = "lootmaster_items"
    private let charactersKey = "lootmaster_characters"
    private let gamesKey = "lootmaster_games"
    private let locationsKey = "lootmaster_locations"
    
    func saveToUserDefaults() {
        let encoder = JSONEncoder()
        
        if let encoded = try? encoder.encode(drops) {
            UserDefaults.standard.set(encoded, forKey: dropsKey)
        }
        if let encoded = try? encoder.encode(sessions) {
            UserDefaults.standard.set(encoded, forKey: sessionsKey)
        }
        if let encoded = try? encoder.encode(items) {
            UserDefaults.standard.set(encoded, forKey: itemsKey)
        }
        if let encoded = try? encoder.encode(characters) {
            UserDefaults.standard.set(encoded, forKey: charactersKey)
        }
        if let encoded = try? encoder.encode(games) {
            UserDefaults.standard.set(encoded, forKey: gamesKey)
        }
        if let encoded = try? encoder.encode(locations) {
            UserDefaults.standard.set(encoded, forKey: locationsKey)
        }
    }
    
    func loadFromUserDefaults() {
        let decoder = JSONDecoder()
        if let data = UserDefaults.standard.data(forKey: dropsKey),
           let decoded = try? decoder.decode([LootDrop].self, from: data) {
            drops = decoded
        }
        
        if let data = UserDefaults.standard.data(forKey: sessionsKey),
           let decoded = try? decoder.decode([LootSession].self, from: data) {
            sessions = decoded
        }
        
        if let data = UserDefaults.standard.data(forKey: itemsKey),
           let decoded = try? decoder.decode([LootItem].self, from: data) {
            items = decoded
        }
        
        if let data = UserDefaults.standard.data(forKey: charactersKey),
           let decoded = try? decoder.decode([Character].self, from: data) {
            characters = decoded
        }
        
        if let data = UserDefaults.standard.data(forKey: gamesKey),
           let decoded = try? decoder.decode([Game].self, from: data) {
            games = decoded
        }
        
        if let data = UserDefaults.standard.data(forKey: locationsKey),
           let decoded = try? decoder.decode([DropLocation].self, from: data) {
            locations = decoded
        }
        
        if drops.isEmpty && sessions.isEmpty && items.isEmpty {
            loadDemoData()
        }
    }
    
    private func loadDemoData() {
        let game1 = Game(id: UUID(), name: "Eternal Realms", iconName: nil, isFavorite: true)
        let game2 = Game(id: UUID(), name: "Skyfall Online", iconName: nil, isFavorite: false)
        games = [game1, game2]
        
        let char1 = Character(
            id: UUID(),
            name: "Shadowblade",
            gameId: game1.id,
            gameName: game1.name,
            level: 80,
            className: "Knight",
            isMain: true
        )
        
        let char2 = Character(
            id: UUID(),
            name: "Starlight",
            gameId: game2.id,
            gameName: game2.name,
            level: 60,
            className: "Ranger",
            isMain: false
        )
        
        characters = [char1, char2]
        
        let item1 = LootItem(
            id: UUID(),
            name: "Obsidian Greatsword",
            type: .weapon,
            rarity: .legendary,
            value: nil,
            ilvl: 80,
            description: "Legendary two-handed sword",
            iconName: nil
        )
        
        let item2 = LootItem(
            id: UUID(),
            name: "Void Shard",
            type: .crafting,
            rarity: .epic,
            value: nil,
            ilvl: nil,
            description: "Rare crafting material",
            iconName: nil
        )
        
        items = [item1, item2]
        
        let drop1 = LootDrop(
            id: UUID(),
            date: Date().addingTimeInterval(-86400),
            itemId: item1.id,
            itemName: item1.name,
            itemType: item1.type,
            itemRarity: item1.rarity,
            quantity: 1,
            sourceId: nil,
            sourceName: "Ashen Colossus",
            sourceType: .boss,
            gameId: game1.id,
            gameName: game1.name,
            recipientId: char1.id,
            recipientName: char1.name,
            recipientClass: char1.className,
            isBound: true,
            isTradable: false,
            notes: "Dropped on the fifth run.",
            screenshotName: nil,
            isFavorite: true,
            creationDate: Date()
        )
        
        let drop2 = LootDrop(
            id: UUID(),
            date: Date().addingTimeInterval(-172800),
            itemId: item2.id,
            itemName: item2.name,
            itemType: item2.type,
            itemRarity: item2.rarity,
            quantity: 5,
            sourceId: nil,
            sourceName: "Crystal Spire",
            sourceType: .boss,
            gameId: game2.id,
            gameName: game2.name,
            recipientId: char2.id,
            recipientName: char2.name,
            recipientClass: char2.className,
            isBound: false,
            isTradable: true,
            notes: nil,
            screenshotName: nil,
            isFavorite: false,
            creationDate: Date()
        )
        
        drops = [drop1, drop2]
        
        let session = LootSession(
            id: UUID(),
            date: Date().addingTimeInterval(-86400),
            gameId: game1.id,
            gameName: game1.name,
            locationId: nil,
            locationName: "Molten Citadel",
            sourceType: .boss,
            duration: 90,
            participants: [char1.name, char2.name],
            drops: [drop1],
            notes: "Great raid run with solid loot.",
            isFavorite: true
        )
        
        sessions = [session]
    }
}

