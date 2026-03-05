import SwiftUI

struct SessionsView: View {
    @ObservedObject var viewModel: LootMasterViewModel
    
    @State private var isShowingAddSession = false
    @State private var selectedSession: LootSession?
    
    var body: some View {
        ZStack {
            Color.lootBackground
                .ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 16) {
                header
                sessionsList
            }
        }
        .sheet(isPresented: $isShowingAddSession) {
            AddSessionView(viewModel: viewModel)
        }
        .sheet(item: $selectedSession) { session in
            SessionDetailView(viewModel: viewModel, session: session)
        }
    }
    
    private var header: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Sessions")
                    .foregroundColor(.lootRare)
                    .font(.largeTitle)
                    .bold()
                
                Text("Track raid runs and loot sessions.")
                    .foregroundColor(.gray)
                    .font(.subheadline)
            }
            
            Spacer()
            
            Button {
                isShowingAddSession = true
            } label: {
                Image(systemName: "plus.circle.fill")
                    .font(.system(size: 32))
                    .foregroundColor(.lootRare)
            }
        }
        .padding(.horizontal)
        .padding(.top)
    }
    
    private var sessionsList: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(viewModel.sessions) { session in
                    SessionCard(session: session, viewModel: viewModel)
                        .onTapGesture {
                            selectedSession = session
                        }
                        .swipeActions {
                            Button(role: .destructive) {
                                viewModel.deleteSession(session)
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                }
            }
            .padding()
        }
    }
}

struct SessionCard: View {
    let session: LootSession
    @ObservedObject var viewModel: LootMasterViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text(session.locationName)
                        .foregroundColor(.white)
                        .font(.headline)
                    
                    Text(session.gameName)
                        .foregroundColor(.lootRare)
                        .font(.caption)
                }
                
                Spacer()
                
                Text(formattedDate(session.date))
                    .foregroundColor(.gray)
                    .font(.caption)
            }
            
            HStack {
                Label(session.sourceType.rawValue, systemImage: "mappin")
                    .foregroundColor(.lootCommon)
                    .font(.caption)
                
                Spacer()
                
                if let duration = session.duration {
                    Label("\(duration) min", systemImage: "clock")
                        .foregroundColor(.lootCommon)
                        .font(.caption)
                }
            }
            
            if !session.drops.isEmpty {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Drops: \(session.drops.count) items")
                        .foregroundColor(.lootRare)
                        .font(.caption)
                    
                    HStack {
                        ForEach(session.drops.prefix(3)) { drop in
                            HStack(spacing: 4) {
                                Image(systemName: drop.itemRarity.icon)
                                    .foregroundColor(drop.itemRarity.color)
                                    .font(.caption2)
                                
                                Text(drop.itemName)
                                    .foregroundColor(.white)
                                    .font(.caption2)
                                    .lineLimit(1)
                            }
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(drop.itemRarity.color.opacity(0.2))
                            .cornerRadius(4)
                        }
                        
                        if session.drops.count > 3 {
                            Text("+\(session.drops.count - 3)")
                                .foregroundColor(.gray)
                                .font(.caption2)
                        }
                    }
                }
            }
            
            if let participants = session.participants, !participants.isEmpty {
                Label("Participants: \(participants.joined(separator: ", "))", systemImage: "person.2")
                    .foregroundColor(.gray)
                    .font(.caption2)
            }
        }
        .padding()
        .lootCard(borderColor: .lootRare)
    }
}

