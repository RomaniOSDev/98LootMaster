import SwiftUI

struct SessionDetailView: View {
    @Environment(\.dismiss) private var dismiss
    
    @ObservedObject var viewModel: LootMasterViewModel
    let session: LootSession
    
    @State private var isShowingAddDrop = false
    
    var body: some View {
        ZStack {
            Color.lootBackground
                .ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 16) {
                header
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        infoSection
                        dropsSection
                        notesSection
                    }
                    .padding(.horizontal)
                }
                
                addDropButton
                    .padding()
            }
        }
        .sheet(isPresented: $isShowingAddDrop) {
            AddDropView(viewModel: viewModel, sessionId: session.id)
        }
    }
    
    private var header: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(session.locationName)
                .foregroundColor(.lootRare)
                .font(.title2)
                .bold()
            
            Text(session.gameName)
                .foregroundColor(.gray)
                .font(.subheadline)
        }
        .padding([.top, .horizontal])
    }
    
    private var infoSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Session info")
                .foregroundColor(.lootRare)
                .font(.headline)
            
            HStack {
                Label("Date: \(formattedDate(session.date))", systemImage: "clock")
                    .foregroundColor(.white)
                    .font(.caption)
                Spacer()
            }
            
            HStack {
                Label("Source: \(session.sourceType.rawValue)", systemImage: "mappin")
                    .foregroundColor(.white)
                    .font(.caption)
                Spacer()
            }
            
            if let duration = session.duration {
                HStack {
                    Label("Duration: \(duration) min", systemImage: "timer")
                        .foregroundColor(.white)
                        .font(.caption)
                    Spacer()
                }
            }
            
            if let participants = session.participants, !participants.isEmpty {
                HStack(alignment: .top) {
                    Image(systemName: "person.2")
                        .foregroundColor(.lootCommon)
                    Text(participants.joined(separator: ", "))
                        .foregroundColor(.white)
                        .font(.caption)
                    Spacer()
                }
            }
        }
        .padding()
        .lootCard(borderColor: .lootRare)
    }
    
    private var dropsSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Drops in this session")
                .foregroundColor(.lootRare)
                .font(.headline)
            
            if session.drops.isEmpty {
                Text("No drops recorded yet.")
                    .foregroundColor(.gray)
                    .font(.caption)
            } else {
                ForEach(session.drops) { drop in
                    LootDropCard(drop: drop)
                }
            }
        }
        .padding()
        .lootCard(borderColor: .lootRare)
    }
    
    private var notesSection: some View {
        Group {
            if let notes = session.notes, !notes.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Notes")
                        .foregroundColor(.lootRare)
                        .font(.headline)
                    
                    Text(notes)
                        .foregroundColor(.white)
                        .font(.body)
                }
                .padding()
                .lootCard(borderColor: .lootRare)
            }
        }
    }
    
    private var addDropButton: some View {
        Button {
            isShowingAddDrop = true
        } label: {
            HStack {
                Image(systemName: "plus.circle.fill")
                Text("Add drop to session")
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
            .cornerRadius(12)
            .shadow(color: Color.lootRare.opacity(0.6), radius: 12, x: 0, y: 8)
        }
    }
}

