import SwiftUI

struct ItemDetailView: View {
    @Environment(\.dismiss) private var dismiss
    
    @ObservedObject var viewModel: LootMasterViewModel
    let item: LootItem
    
    var body: some View {
        ZStack {
            Color.lootBackground
                .ignoresSafeArea()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    header
                    infoSection
                    statsSection
                }
                .padding()
            }
        }
    }
    
    private var header: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: item.rarity.icon)
                .foregroundColor(item.rarity.color)
                .font(.largeTitle)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(item.name)
                    .foregroundColor(.white)
                    .font(.title2)
                    .bold()
                
                Text("\(item.type.rawValue) • \(item.rarity.rawValue)")
                    .foregroundColor(.gray)
                    .font(.subheadline)
            }
            
            Spacer()
        }
    }
    
    private var infoSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Item info")
                .foregroundColor(.lootRare)
                .font(.headline)
            
            if let ilvl = item.ilvl {
                HStack {
                    Label("Item level: \(ilvl)", systemImage: "arrow.up.circle")
                        .foregroundColor(.white)
                        .font(.caption)
                    Spacer()
                }
            }
            
            if let description = item.description, !description.isEmpty {
                Text(description)
                    .foregroundColor(.white)
                    .font(.body)
            }
        }
        .padding()
        .lootCard(borderColor: item.rarity.color)
    }
    
    private var statsSection: some View {
        let dropCount = viewModel.dropCount(for: item.id)
        
        return VStack(alignment: .leading, spacing: 8) {
            Text("Drop stats")
                .foregroundColor(.lootRare)
                .font(.headline)
            
            if dropCount == 0 {
                Text("No drops recorded for this item yet.")
                    .foregroundColor(.gray)
                    .font(.caption)
            } else {
                Text("Total drops: \(dropCount)")
                    .foregroundColor(.white)
                    .font(.body)
            }
        }
        .padding()
        .lootCard(borderColor: item.rarity.color)
    }
}

