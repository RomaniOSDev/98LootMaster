import SwiftUI

struct CharacterDetailView: View {
    @Environment(\.dismiss) private var dismiss
    
    @ObservedObject var viewModel: LootMasterViewModel
    let character: Character
    
    var body: some View {
        ZStack {
            Color.lootBackground
                .ignoresSafeArea()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    header
                    infoSection
                    dropsSection
                }
                .padding()
            }
        }
    }
    
    private var header: some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(character.isMain ? Color.lootRare : Color.lootCommon.opacity(0.3))
                    .frame(width: 60, height: 60)
                
                Text(String(character.name.prefix(1)).uppercased())
                    .foregroundColor(character.isMain ? .lootBackground : .white)
                    .font(.title)
                    .bold()
            }
            
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(character.name)
                        .foregroundColor(.white)
                        .font(.title2)
                        .bold()
                    
                    if character.isMain {
                        Image(systemName: "crown.fill")
                            .foregroundColor(.lootRare)
                            .font(.caption)
                    }
                }
                
                Text(character.gameName)
                    .foregroundColor(.gray)
                    .font(.subheadline)
                
                if let className = character.className {
                    Text(className)
                        .foregroundColor(.lootCommon)
                        .font(.caption)
                }
            }
            
            Spacer()
        }
    }
    
    private var infoSection: some View {
        let drops = viewModel.dropsForCharacter(character.id)
        let totalDrops = drops.count
        let lastDropDate = drops.map { $0.date }.max()
        
        return VStack(alignment: .leading, spacing: 8) {
            Text("Character stats")
                .foregroundColor(.lootRare)
                .font(.headline)
            
            Text("Total drops: \(totalDrops)")
                .foregroundColor(.white)
                .font(.body)
            
            if let lastDate = lastDropDate {
                Text("Last drop: \(formattedDate(lastDate))")
                    .foregroundColor(.gray)
                    .font(.caption)
            }
        }
        .padding()
        .lootCard(borderColor: character.isMain ? .lootRare : .lootCommon)
    }
    
    private var dropsSection: some View {
        let drops = viewModel.dropsForCharacter(character.id).sorted { $0.date > $1.date }
        
        return VStack(alignment: .leading, spacing: 8) {
            Text("Drops for this character")
                .foregroundColor(.lootRare)
                .font(.headline)
            
            if drops.isEmpty {
                Text("No drops recorded yet.")
                    .foregroundColor(.gray)
                    .font(.caption)
            } else {
                ForEach(drops) { drop in
                    LootDropCard(drop: drop)
                }
            }
        }
        .padding()
        .lootCard(borderColor: character.isMain ? .lootRare : .lootCommon)
    }
}

