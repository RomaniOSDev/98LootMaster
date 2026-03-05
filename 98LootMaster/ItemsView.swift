import SwiftUI

struct ItemsView: View {
    @ObservedObject var viewModel: LootMasterViewModel
    
    @State private var selectedItem: LootItem?
    @State private var isShowingAddItem = false
    
    var body: some View {
        ZStack {
            Color.lootBackground
                .ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 16) {
                header
                itemsGrid
            }
        }
        .sheet(isPresented: $isShowingAddItem) {
            AddItemView(viewModel: viewModel)
        }
        .sheet(item: $selectedItem) { item in
            ItemDetailView(viewModel: viewModel, item: item)
        }
    }
    
    private var header: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Items")
                    .foregroundColor(.lootRare)
                    .font(.largeTitle)
                    .bold()
                
                Text("Your personal loot collection.")
                    .foregroundColor(.gray)
                    .font(.subheadline)
            }
            
            Spacer()
            
            Button {
                isShowingAddItem = true
            } label: {
                Image(systemName: "plus.circle.fill")
                    .font(.system(size: 32))
                    .foregroundColor(.lootRare)
            }
        }
        .padding(.horizontal)
        .padding(.top)
    }
    
    private var itemsGrid: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                ForEach(viewModel.items) { item in
                    ItemCard(item: item, dropCount: viewModel.dropCount(for: item.id))
                        .onTapGesture {
                            selectedItem = item
                        }
                        .contextMenu {
                            Button("Add drop") {
                                selectedItem = item
                            }
                            Button("Delete", role: .destructive) {
                                if let index = viewModel.items.firstIndex(where: { $0.id == item.id }) {
                                    viewModel.items.remove(at: index)
                                    viewModel.saveToUserDefaults()
                                }
                            }
                        }
                }
            }
            .padding()
        }
    }
}

struct ItemCard: View {
    let item: LootItem
    let dropCount: Int
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Image(systemName: item.rarity.icon)
                    .foregroundColor(item.rarity.color)
                    .font(.title2)
                
                Spacer()
                
                if let ilvl = item.ilvl {
                    Text("\(ilvl)")
                        .foregroundColor(item.rarity.color)
                        .font(.caption)
                        .padding(.horizontal, 4)
                        .padding(.vertical, 2)
                        .background(item.rarity.color.opacity(0.2))
                        .cornerRadius(4)
                }
            }
            
            Text(item.name)
                .foregroundColor(.white)
                .font(.headline)
                .lineLimit(1)
            
            Text(item.type.rawValue)
                .foregroundColor(.gray)
                .font(.caption)
            
            Spacer()
            
            if dropCount > 0 {
                HStack {
                    Image(systemName: "archivebox")
                        .font(.caption2)
                    Text("\(dropCount)")
                        .font(.caption2)
                }
                .foregroundColor(item.rarity.color)
            }
        }
        .padding()
        .frame(height: 120)
        .lootCard(borderColor: item.rarity.color)
    }
}

