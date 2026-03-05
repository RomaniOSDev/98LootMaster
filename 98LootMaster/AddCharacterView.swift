import SwiftUI

struct AddCharacterView: View {
    @Environment(\.dismiss) private var dismiss
    
    @ObservedObject var viewModel: LootMasterViewModel
    
    @State private var name: String = ""
    @State private var selectedGameId: UUID?
    @State private var customGameName: String = ""
    @State private var className: String = ""
    @State private var isMain: Bool = false
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.lootBackground
                    .ignoresSafeArea()
                
                Form {
                    Section(header: Text("Character").foregroundColor(.lootRare)) {
                        TextField("Name", text: $name)
                            .foregroundColor(.white)
                            .accentColor(.lootRare)
                        
                        Picker("Game", selection: $selectedGameId) {
                            ForEach(viewModel.games) { game in
                                Text(game.name).tag(game.id as UUID?)
                            }
                            Text("Other").tag(nil as UUID?)
                        }
                        
                        if selectedGameId == nil {
                            TextField("Game name", text: $customGameName)
                                .foregroundColor(.white)
                                .accentColor(.lootRare)
                        }
                        
                        TextField("Class (optional)", text: $className)
                            .foregroundColor(.white)
                            .accentColor(.lootRare)
                        
                        Toggle("Main character", isOn: $isMain)
                            .tint(.lootRare)
                    }
                    .foregroundColor(.white)
                }
                .scrollContentBackground(.hidden)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("New character")
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
                        saveCharacter()
                    }
                    .disabled(name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
        }
        .accentColor(.lootRare)
    }
    
    private func saveCharacter() {
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedName.isEmpty else { return }
        
        let gameId: UUID?
        let gameName: String
        
        if let selectedId = selectedGameId,
           let game = viewModel.games.first(where: { $0.id == selectedId }) {
            gameId = game.id
            gameName = game.name
        } else {
            let name = customGameName.trimmingCharacters(in: .whitespacesAndNewlines)
            if name.isEmpty {
                gameId = nil
                gameName = "Unknown game"
            } else {
                gameId = nil
                gameName = name
            }
        }
        
        let cls = className.trimmingCharacters(in: .whitespacesAndNewlines)
        
        viewModel.addCharacter(
            name: trimmedName,
            gameId: gameId,
            gameName: gameName,
            className: cls.isEmpty ? nil : cls,
            isMain: isMain
        )
        
        dismiss()
    }
}

