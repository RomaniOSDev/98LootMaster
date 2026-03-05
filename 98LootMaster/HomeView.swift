import SwiftUI

struct HomeView: View {
    @ObservedObject var viewModel: LootMasterViewModel
    @Binding var selectedTab: Int
    
    @State private var isShowingAddDrop = false
    @State private var isShowingAddSession = false
    
    var body: some View {
        ZStack {
            Color.lootBackground
                .ignoresSafeArea()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    header
                    statsGrid
                    quickActions
                    recentDropsSection
                }
                .padding()
            }
        }
        .sheet(isPresented: $isShowingAddDrop) {
            AddDropView(viewModel: viewModel)
        }
        .sheet(isPresented: $isShowingAddSession) {
            AddSessionView(viewModel: viewModel)
        }
    }
    
    private var header: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Welcome back")
                .foregroundColor(.lootRare)
                .font(.largeTitle)
                .bold()
            
            Text("Quick overview of your recent loot and runs.")
                .foregroundColor(.gray)
                .font(.subheadline)
        }
        .padding()
        .background(
            LinearGradient(
                colors: [Color.lootBackground.opacity(0.0), Color.lootBackground.opacity(0.6)],
                startPoint: .top,
                endPoint: .bottom
            )
        )
        .cornerRadius(20)
    }
    
    private var statsGrid: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
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
                title: "Today",
                value: "\(viewModel.todayDrops)",
                icon: "calendar",
                color: .lootRare
            )
            
            StatCard(
                title: "Sessions",
                value: "\(viewModel.totalSessions)",
                icon: "rectangle.stack.fill",
                color: .lootCommon
            )
        }
    }
    
    private var quickActions: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Quick actions")
                .foregroundColor(.lootRare)
                .font(.headline)
            
            HStack(spacing: 12) {
                primaryActionButton(
                    title: "Add drop",
                    icon: "plus.circle.fill",
                    action: { isShowingAddDrop = true }
                )
                
                primaryActionButton(
                    title: "Start session",
                    icon: "play.circle.fill",
                    action: { isShowingAddSession = true }
                )
            }
            
            HStack(spacing: 12) {
                secondaryActionButton(
                    title: "Loot feed",
                    icon: "archivebox",
                    targetTab: 1
                )
                
                secondaryActionButton(
                    title: "Items",
                    icon: "backpack.fill",
                    targetTab: 2
                )
            }
        }
    }
    
    private func primaryActionButton(title: String, icon: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                Text(title)
                    .bold()
            }
            .foregroundColor(.lootBackground)
            .frame(maxWidth: .infinity)
            .padding()
            .background(
                LinearGradient(
                    colors: [Color.lootRare, Color.lootCommon],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .cornerRadius(14)
            .shadow(color: Color.lootRare.opacity(0.6), radius: 14, x: 0, y: 8)
        }
    }
    
    private func secondaryActionButton(title: String, icon: String, targetTab: Int) -> some View {
        Button {
            selectedTab = targetTab
        } label: {
            HStack {
                Image(systemName: icon)
                Text(title)
            }
            .foregroundColor(.lootRare)
            .frame(maxWidth: .infinity)
            .padding()
            .background(
                LinearGradient(
                    colors: [Color.lootBackground.opacity(0.9), Color.lootBackground.opacity(0.5)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(Color.lootRare.opacity(0.6), lineWidth: 1)
            )
            .cornerRadius(14)
            .shadow(color: Color.lootRare.opacity(0.35), radius: 10, x: 0, y: 6)
        }
    }
    
    private var recentDropsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Recent drops")
                .foregroundColor(.lootRare)
                .font(.headline)
            
            if viewModel.filteredDrops.isEmpty {
                Text("No drops recorded yet. Start by adding your first drop.")
                    .foregroundColor(.gray)
                    .font(.caption)
            } else {
                let recent = Array(viewModel.filteredDrops.prefix(3))
                ForEach(recent) { drop in
                    LootDropCard(drop: drop)
                }
            }
        }
    }
}

