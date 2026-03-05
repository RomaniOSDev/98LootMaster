import SwiftUI

struct LootFeedView: View {
    @ObservedObject var viewModel: LootMasterViewModel
    
    @State private var selectedDrop: LootDrop?
    @State private var isShowingAddDrop = false
    
    var body: some View {
        ZStack {
            Color.lootBackground
                .ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 16) {
                header
                statsSection
                filtersSection
                dropsList
            }
        }
        .sheet(isPresented: $isShowingAddDrop) {
            AddDropView(viewModel: viewModel)
        }
        .sheet(item: $selectedDrop) { drop in
            LootDropDetailView(viewModel: viewModel, drop: drop)
        }
        .searchable(text: $viewModel.searchText, placement: .navigationBarDrawer(displayMode: .automatic), prompt: "Search drops")
    }
    
    private var header: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Loot feed")
                .foregroundColor(.lootRare)
                .font(.largeTitle)
                .bold()
            
            Text("Track your latest drops and raid sessions.")
                .foregroundColor(.gray)
                .font(.subheadline)
        }
        .padding(.horizontal)
        .padding(.top)
    }
    
    private var statsSection: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                StatCard(
                    title: "Total drops",
                    value: "\(viewModel.totalDrops)",
                    icon: "archivebox",
                    color: .lootCommon
                )
                
                StatCard(
                    title: "Legendary",
                    value: "\(viewModel.legendaryCount)",
                    icon: "star.fill",
                    color: .lootRare
                )
                
                StatCard(
                    title: "Sessions",
                    value: "\(viewModel.totalSessions)",
                    icon: "rectangle.stack.fill",
                    color: .lootCommon
                )
                
                StatCard(
                    title: "Today",
                    value: "\(viewModel.todayDrops)",
                    icon: "calendar",
                    color: .lootRare
                )
            }
            .padding(.horizontal)
        }
    }
    
    private var filtersSection: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                FilterChip(
                    title: "All",
                    isSelected: viewModel.selectedRarity == nil,
                    color: .lootRare
                )
                .onTapGesture {
                    viewModel.selectedRarity = nil
                }
                
                FilterChip(
                    title: "Legendary",
                    isSelected: viewModel.selectedRarity == .legendary,
                    color: .lootRare
                )
                .onTapGesture {
                    viewModel.selectedRarity = .legendary
                }
                
                FilterChip(
                    title: "Epic",
                    isSelected: viewModel.selectedRarity == .epic,
                    color: .lootRare
                )
                .onTapGesture {
                    viewModel.selectedRarity = .epic
                }
                
                FilterChip(
                    title: "Rare",
                    isSelected: viewModel.selectedRarity == .rare,
                    color: .lootRare
                )
                .onTapGesture {
                    viewModel.selectedRarity = .rare
                }
                
                FilterChip(
                    title: "Common",
                    isSelected: viewModel.selectedRarity == .common,
                    color: .lootCommon
                )
                .onTapGesture {
                    viewModel.selectedRarity = .common
                }
            }
            .padding(.horizontal)
        }
    }
    
    private var dropsList: some View {
        ZStack(alignment: .bottomTrailing) {
            ScrollView {
                LazyVStack(spacing: 12) {
                    ForEach(viewModel.filteredDrops) { drop in
                        LootDropCard(drop: drop)
                            .onTapGesture {
                                selectedDrop = drop
                            }
                            .swipeActions {
                                Button(role: .destructive) {
                                    viewModel.deleteDrop(drop)
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                                
                                Button {
                                    viewModel.toggleFavoriteDrop(drop)
                                } label: {
                                    Label("Favorite", systemImage: "star")
                                }
                                .tint(.lootRare)
                            }
                    }
                }
                .padding()
            }
            
            Button {
                isShowingAddDrop = true
            } label: {
                Image(systemName: "plus.circle.fill")
                    .font(.system(size: 56))
                    .foregroundColor(.lootRare)
                    .shadow(radius: 8)
            }
            .padding()
        }
    }
}

struct LootDropCard: View {
    let drop: LootDrop
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: drop.itemRarity.icon)
                    .foregroundColor(drop.itemRarity.color)
                    .font(.title2)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(drop.itemName)
                        .foregroundColor(.white)
                        .font(.headline)
                    
                    Text(drop.itemType.rawValue)
                        .foregroundColor(.gray)
                        .font(.caption)
                }
                
                Spacer()
                
                if drop.quantity > 1 {
                    Text("x\(drop.quantity)")
                        .foregroundColor(drop.itemRarity.color)
                        .font(.title3)
                        .bold()
                }
                
                if drop.isFavorite {
                    Image(systemName: "star.fill")
                        .foregroundColor(.lootRare)
                        .font(.caption)
                }
            }
            
            Divider()
                .background(drop.itemRarity.color.opacity(0.3))
            
            HStack {
                Label {
                    Text(drop.sourceName)
                        .foregroundColor(.white)
                        .font(.caption)
                } icon: {
                    Image(systemName: "mappin")
                        .foregroundColor(.lootCommon)
                }
                
                Spacer()
                
                if let recipient = drop.recipientName {
                    Label {
                        Text(recipient)
                            .foregroundColor(.white)
                            .font(.caption)
                    } icon: {
                        Image(systemName: "person.fill")
                            .foregroundColor(.lootCommon)
                    }
                }
            }
            
            HStack {
                Label(formattedDate(drop.date), systemImage: "clock")
                    .foregroundColor(.gray)
                    .font(.caption2)
                
                Spacer()
                
                Text(drop.gameName)
                    .foregroundColor(drop.itemRarity.color)
                    .font(.caption2)
            }
        }
        .padding()
        .lootCard(borderColor: drop.itemRarity.color)
    }
}

