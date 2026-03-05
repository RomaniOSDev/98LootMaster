import SwiftUI

struct AddDropView: View {
    @Environment(\.dismiss) private var dismiss
    
    @ObservedObject var viewModel: LootMasterViewModel
    let sessionId: UUID?
    
    // Item
    @State private var itemName: String = ""
    @State private var itemType: ItemType = .weapon
    @State private var itemRarity: RarityLevel = .rare
    @State private var quantity: Int = 1
    @State private var isFavorite: Bool = false
    
    // Source
    @State private var selectedGameId: UUID?
    @State private var customGame: String = ""
    @State private var sourceType: DropSource = .boss
    @State private var sourceName: String = ""
    @State private var difficulty: String = ""
    
    // Recipient
    @State private var selectedCharacterId: UUID?
    @State private var recipientName: String = ""
    @State private var recipientClass: String = ""
    @State private var isBound: Bool = false
    @State private var isTradable: Bool = true
    
    // Notes
    @State private var notes: String = ""
    
    init(viewModel: LootMasterViewModel, sessionId: UUID? = nil) {
        self.viewModel = viewModel
        self.sessionId = sessionId
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.lootBackground
                    .ignoresSafeArea()
                
                Form {
                    itemSection
                    sourceSection
                    recipientSection
                    notesSection
                }
                .scrollContentBackground(.hidden)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("New drop")
                        .foregroundColor(.lootRare)
                        .bold()
                }
                
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(.lootCommon)
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveDrop()
                    }
                    .disabled(itemName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ||
                              sourceName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
        }
        .accentColor(.lootRare)
    }
    
    private var itemSection: some View {
        Section(header: Text("Item").foregroundColor(.lootRare)) {
            TextField("Item name", text: $itemName)
                .foregroundColor(.white)
                .accentColor(.lootRare)
            
            Picker("Item type", selection: $itemType) {
                ForEach(ItemType.allCases) { type in
                    Text(type.rawValue).tag(type)
                }
            }
            
            Picker("Rarity", selection: $itemRarity) {
                ForEach(RarityLevel.allCases) { rarity in
                    Text(rarity.rawValue).tag(rarity)
                }
            }
            
            HStack {
                Text("Quantity")
                Spacer()
                Stepper("\(quantity)", value: $quantity, in: 1...999)
                    .foregroundColor(.lootRare)
            }
            
            if itemRarity == .legendary || itemRarity == .mythic {
                Toggle("Add to favorites", isOn: $isFavorite)
                    .tint(.lootRare)
            }
        }
        .foregroundColor(.white)
    }
    
    private var sourceSection: some View {
        Section(header: Text("Source").foregroundColor(.lootRare)) {
            Picker("Game", selection: $selectedGameId) {
                ForEach(viewModel.games) { game in
                    Text(game.name).tag(game.id as UUID?)
                }
                Text("Other").tag(nil as UUID?)
            }
            
            if selectedGameId == nil {
                TextField("Game name", text: $customGame)
                    .foregroundColor(.white)
                    .accentColor(.lootRare)
            }
            
            Picker("Source type", selection: $sourceType) {
                ForEach(DropSource.allCases) { source in
                    Text(source.rawValue).tag(source)
                }
            }
            
            TextField("Source name", text: $sourceName)
                .foregroundColor(.white)
                .accentColor(.lootRare)
            
            TextField("Difficulty (optional)", text: $difficulty)
                .foregroundColor(.white)
                .accentColor(.lootRare)
        }
        .foregroundColor(.white)
    }
    
    private var recipientSection: some View {
        Section(header: Text("Recipient").foregroundColor(.lootRare)) {
            Picker("Character", selection: $selectedCharacterId) {
                Text("—").tag(nil as UUID?)
                ForEach(viewModel.characters) { character in
                    Text(character.name).tag(character.id as UUID?)
                }
            }
            
            if selectedCharacterId == nil {
                TextField("Character name", text: $recipientName)
                    .foregroundColor(.white)
                    .accentColor(.lootRare)
                
                TextField("Class", text: $recipientClass)
                    .foregroundColor(.white)
                    .accentColor(.lootRare)
            }
            
            Toggle("Bound to character", isOn: $isBound)
                .tint(.lootRare)
            
            Toggle("Can be traded", isOn: $isTradable)
                .tint(.lootRare)
        }
        .foregroundColor(.white)
    }
    
    private var notesSection: some View {
        Section(header: Text("Notes").foregroundColor(.lootRare)) {
            TextEditor(text: $notes)
                .frame(height: 100)
                .foregroundColor(.white)
                .accentColor(.lootRare)
        }
        .foregroundColor(.white)
    }
    
    private func saveDrop() {
        let trimmedItemName = itemName.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedSourceName = sourceName.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !trimmedItemName.isEmpty, !trimmedSourceName.isEmpty else { return }
        
        let gameId: UUID?
        let gameName: String
        
        if let selectedId = selectedGameId,
           let game = viewModel.games.first(where: { $0.id == selectedId }) {
            gameId = game.id
            gameName = game.name
        } else {
            let name = customGame.trimmingCharacters(in: .whitespacesAndNewlines)
            if name.isEmpty {
                gameId = nil
                gameName = "Unknown game"
            } else {
                gameId = nil
                gameName = name
            }
        }
        
        var finalRecipientId: UUID?
        var finalRecipientName: String?
        var finalRecipientClass: String?
        
        if let characterId = selectedCharacterId,
           let character = viewModel.characters.first(where: { $0.id == characterId }) {
            finalRecipientId = character.id
            finalRecipientName = character.name
            finalRecipientClass = character.className
        } else {
            let name = recipientName.trimmingCharacters(in: .whitespacesAndNewlines)
            let cls = recipientClass.trimmingCharacters(in: .whitespacesAndNewlines)
            if !name.isEmpty {
                finalRecipientName = name
            }
            if !cls.isEmpty {
                finalRecipientClass = cls
            }
        }
        
        let now = Date()
        
        let item = viewModel.addItem(
            name: trimmedItemName,
            type: itemType,
            rarity: itemRarity
        )
        
        let drop = LootDrop(
            id: UUID(),
            date: now,
            itemId: item.id,
            itemName: trimmedItemName,
            itemType: itemType,
            itemRarity: itemRarity,
            quantity: quantity,
            sourceId: nil,
            sourceName: trimmedSourceName,
            sourceType: sourceType,
            gameId: gameId,
            gameName: gameName,
            recipientId: finalRecipientId,
            recipientName: finalRecipientName,
            recipientClass: finalRecipientClass,
            isBound: isBound,
            isTradable: isTradable,
            notes: notes.trimmingCharacters(in: .whitespacesAndNewlines),
            screenshotName: nil,
            isFavorite: isFavorite || itemRarity == .legendary || itemRarity == .mythic,
            creationDate: now
        )
        
        if let sessionId {
            viewModel.addDrop(to: sessionId, drop: drop)
        } else {
            viewModel.addDrop(drop)
        }
        dismiss()
    }
}

