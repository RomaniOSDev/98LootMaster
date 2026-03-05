import SwiftUI

struct LootDropDetailView: View {
    @Environment(\.dismiss) private var dismiss
    
    @ObservedObject var viewModel: LootMasterViewModel
    let drop: LootDrop
    
    var body: some View {
        ZStack {
            Color.lootBackground
                .ignoresSafeArea()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    header
                    detailsSection
                    notesSection
                    actionsSection
                }
                .padding()
            }
        }
    }
    
    private var header: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: drop.itemRarity.icon)
                .foregroundColor(drop.itemRarity.color)
                .font(.largeTitle)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(drop.itemName)
                    .foregroundColor(.white)
                    .font(.title2)
                    .bold()
                
                Text("\(drop.itemType.rawValue) • \(drop.itemRarity.rawValue)")
                    .foregroundColor(.gray)
                    .font(.subheadline)
            }
            
            Spacer()
        }
    }
    
    private var detailsSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Details")
                .foregroundColor(.lootRare)
                .font(.headline)
            
            HStack {
                Label("Source: \(drop.sourceName)", systemImage: "mappin")
                    .foregroundColor(.white)
                    .font(.caption)
                Spacer()
            }
            
            if let recipient = drop.recipientName {
                HStack {
                    Label("Recipient: \(recipient)", systemImage: "person.fill")
                        .foregroundColor(.white)
                        .font(.caption)
                    Spacer()
                }
            }
            
            HStack {
                Label("Game: \(drop.gameName)", systemImage: "gamecontroller")
                    .foregroundColor(.white)
                    .font(.caption)
                Spacer()
            }
            
            HStack {
                Label("Date: \(formattedDate(drop.date))", systemImage: "clock")
                    .foregroundColor(.gray)
                    .font(.caption2)
                Spacer()
            }
            
            HStack {
                Label("Quantity: \(drop.quantity)", systemImage: "number.circle")
                    .foregroundColor(.white)
                    .font(.caption)
                Spacer()
            }
            
            HStack {
                Label(drop.isBound ? "Soulbound" : "Not bound", systemImage: "lock.fill")
                    .foregroundColor(.white)
                    .font(.caption)
                
                Spacer()
                
                Label(drop.isTradable ? "Tradable" : "Not tradable", systemImage: "arrow.left.arrow.right")
                    .foregroundColor(.white)
                    .font(.caption)
            }
        }
        .padding()
        .lootCard(borderColor: .lootRare)
    }
    
    private var notesSection: some View {
        Group {
            if let notes = drop.notes, !notes.isEmpty {
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
    
    private var actionsSection: some View {
        VStack(spacing: 12) {
            Button {
                viewModel.toggleFavoriteDrop(drop)
                dismiss()
            } label: {
                HStack {
                    Image(systemName: drop.isFavorite ? "star.slash" : "star.fill")
                    Text(drop.isFavorite ? "Remove from favorites" : "Add to favorites")
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
            
            Button(role: .destructive) {
                viewModel.deleteDrop(drop)
                dismiss()
            } label: {
                HStack {
                    Image(systemName: "trash")
                    Text("Delete drop")
                }
                .frame(maxWidth: .infinity)
                .padding()
                .foregroundColor(.red)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.red.opacity(0.6), lineWidth: 1)
                )
            }
        }
        .padding(.top)
    }
}

