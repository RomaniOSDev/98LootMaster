import SwiftUI

struct StatsView: View {
    @ObservedObject var viewModel: LootMasterViewModel
    
    var body: some View {
        ZStack {
            Color.lootBackground
                .ignoresSafeArea()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    header
                    overallStats
                    raritySection
                    topSourcesSection
                    activitySection
                }
                .padding(.bottom)
            }
        }
    }
    
    private var header: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Statistics")
                .foregroundColor(.lootRare)
                .font(.largeTitle)
                .bold()
            
            Text("See how your loot is distributed.")
                .foregroundColor(.gray)
                .font(.subheadline)
        }
        .padding(.horizontal)
        .padding(.top)
    }
    
    private var overallStats: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())]) {
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
                title: "Epic",
                value: "\(viewModel.epicCount)",
                icon: "diamond.fill",
                color: .lootRare
            )
            
            StatCard(
                title: "Sessions",
                value: "\(viewModel.totalSessions)",
                icon: "rectangle.stack.fill",
                color: .lootCommon
            )
        }
        .padding(.horizontal)
    }
    
    private var raritySection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("By rarity")
                .foregroundColor(.lootRare)
                .font(.headline)
                .padding(.horizontal)
            
            ForEach(RarityLevel.allCases) { rarity in
                let count = viewModel.dropsByRarity[rarity] ?? 0
                let percentage = viewModel.totalDrops > 0 ? Double(count) / Double(viewModel.totalDrops) * 100 : 0
                
                if count > 0 {
                    HStack {
                        Image(systemName: rarity.icon)
                            .foregroundColor(rarity.color)
                            .frame(width: 24)
                        
                        Text(rarity.rawValue)
                            .foregroundColor(.white)
                        
                        Spacer()
                        
                        Text("\(count)")
                            .foregroundColor(.gray)
                        
                        Text("(\(Int(percentage))%)")
                            .foregroundColor(rarity.color)
                            .font(.caption)
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 4)
                }
            }
        }
        .padding()
        .lootCard(borderColor: .lootRare)
        .padding(.horizontal)
    }
    
    private var topSourcesSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Top sources")
                .foregroundColor(.lootRare)
                .font(.headline)
                .padding(.horizontal)
            
            ForEach(Array(viewModel.topSources.prefix(5)), id: \.id) { source in
                HStack {
                    Image(systemName: "mappin")
                        .foregroundColor(.lootCommon)
                    
                    Text(source.name)
                        .foregroundColor(.white)
                        .lineLimit(1)
                    
                    Spacer()
                    
                    Text("\(source.count)")
                        .foregroundColor(.lootRare)
                    
                    Text("drops")
                        .foregroundColor(.gray)
                        .font(.caption)
                }
                .padding(.horizontal)
                .padding(.vertical, 4)
            }
        }
        .padding()
        .lootCard(borderColor: .lootRare)
        .padding(.horizontal)
    }
    
    private var activitySection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Daily activity")
                .foregroundColor(.lootRare)
                .font(.headline)
                .padding(.horizontal)
            
            let calendar = Calendar.current
            let today = Date()
            
            HStack(alignment: .bottom) {
                ForEach(0..<7) { dayOffset in
                    if let date = calendar.date(byAdding: .day, value: -dayOffset, to: today) {
                        let count = viewModel.dropsOnDate(date)
                        let maxCount = max(viewModel.maxDropsPerDay, 1)
                        let barHeight = CGFloat(count) / CGFloat(maxCount) * 80
                        
                        VStack {
                            RoundedRectangle(cornerRadius: 4)
                                .fill(count > 0 ? Color.lootRare : Color.gray.opacity(0.3))
                                .frame(height: barHeight)
                                .frame(maxHeight: 80, alignment: .bottom)
                            
                            Text(dayOffset == 0 ? "Today" : formattedShortDate(date))
                                .foregroundColor(.gray)
                                .font(.caption2)
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
            }
            .padding()
        }
        .lootCard(borderColor: .lootRare)
        .padding(.horizontal)
    }
}

