import SwiftUI

struct AddItemView: View {
    @Environment(\.dismiss) private var dismiss
    
    @ObservedObject var viewModel: LootMasterViewModel
    
    @State private var name: String = ""
    @State private var type: ItemType = .weapon
    @State private var rarity: RarityLevel = .rare
    @State private var ilvlText: String = ""
    @State private var description: String = ""
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.lootBackground
                    .ignoresSafeArea()
                
                Form {
                    Section(header: Text("Item").foregroundColor(.lootRare)) {
                        TextField("Item name", text: $name)
                            .foregroundColor(.white)
                            .accentColor(.lootRare)
                        
                        Picker("Type", selection: $type) {
                            ForEach(ItemType.allCases) { it in
                                Text(it.rawValue).tag(it)
                            }
                        }
                        
                        Picker("Rarity", selection: $rarity) {
                            ForEach(RarityLevel.allCases) { r in
                                Text(r.rawValue).tag(r)
                            }
                        }
                        
                        TextField("Item level (optional)", text: $ilvlText)
                            .keyboardType(.numberPad)
                            .foregroundColor(.white)
                            .accentColor(.lootRare)
                    }
                    .foregroundColor(.white)
                    
                    Section(header: Text("Description").foregroundColor(.lootRare)) {
                        TextEditor(text: $description)
                            .frame(height: 100)
                            .foregroundColor(.white)
                            .accentColor(.lootRare)
                    }
                    .foregroundColor(.white)
                }
                .scrollContentBackground(.hidden)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("New item")
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
                        saveItem()
                    }
                    .disabled(name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
        }
        .accentColor(.lootRare)
    }
    
    private func saveItem() {
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedName.isEmpty else { return }
        
        let ilvl = Int(ilvlText.trimmingCharacters(in: .whitespacesAndNewlines))
        let desc = description.trimmingCharacters(in: .whitespacesAndNewlines)
        
        _ = viewModel.addItem(
            name: trimmedName,
            type: type,
            rarity: rarity,
            ilvl: ilvl,
            description: desc.isEmpty ? nil : desc
        )
        
        dismiss()
    }
}

