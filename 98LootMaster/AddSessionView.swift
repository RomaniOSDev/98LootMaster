import SwiftUI

struct AddSessionView: View {
    @Environment(\.dismiss) private var dismiss
    
    @ObservedObject var viewModel: LootMasterViewModel
    
    @State private var selectedGameId: UUID?
    @State private var customGameName: String = ""
    @State private var locationName: String = ""
    @State private var sourceType: DropSource = .boss
    @State private var duration: Int = 60
    @State private var participantsText: String = ""
    @State private var notes: String = ""
    @State private var isFavorite: Bool = false
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.lootBackground
                    .ignoresSafeArea()
                
                Form {
                    Section(header: Text("Session").foregroundColor(.lootRare)) {
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
                        
                        TextField("Location", text: $locationName)
                            .foregroundColor(.white)
                            .accentColor(.lootRare)
                        
                        Picker("Source type", selection: $sourceType) {
                            ForEach(DropSource.allCases) { source in
                                Text(source.rawValue).tag(source)
                            }
                        }
                        
                        Stepper("Duration: \(duration) min", value: $duration, in: 10...600, step: 10)
                    }
                    .foregroundColor(.white)
                    
                    Section(header: Text("Participants").foregroundColor(.lootRare)) {
                        TextField("Comma-separated names", text: $participantsText)
                            .foregroundColor(.white)
                            .accentColor(.lootRare)
                    }
                    .foregroundColor(.white)
                    
                    Section(header: Text("Notes").foregroundColor(.lootRare)) {
                        TextEditor(text: $notes)
                            .frame(height: 100)
                            .foregroundColor(.white)
                            .accentColor(.lootRare)
                        
                        Toggle("Mark as favorite", isOn: $isFavorite)
                            .tint(.lootRare)
                    }
                    .foregroundColor(.white)
                }
                .scrollContentBackground(.hidden)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("New session")
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
                        saveSession()
                    }
                    .disabled(locationName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
        }
        .accentColor(.lootRare)
    }
    
    private func saveSession() {
        let trimmedLocation = locationName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedLocation.isEmpty else { return }
        
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
        
        let participants = participantsText
            .split(separator: ",")
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
        
        let session = LootSession(
            id: UUID(),
            date: Date(),
            gameId: gameId,
            gameName: gameName,
            locationId: nil,
            locationName: trimmedLocation,
            sourceType: sourceType,
            duration: duration,
            participants: participants.isEmpty ? nil : participants,
            drops: [],
            notes: notes.trimmingCharacters(in: .whitespacesAndNewlines),
            isFavorite: isFavorite
        )
        
        viewModel.addSession(session)
        dismiss()
    }
}

