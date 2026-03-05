import SwiftUI

struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(color)
                Text(title)
                    .foregroundColor(.gray)
                    .font(.caption)
            }
            
            Text(value)
                .foregroundColor(.white)
                .font(.title2)
                .bold()
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            LinearGradient(
                colors: [Color.lootBackground.opacity(0.9), Color.lootBackground.opacity(0.6)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(color.opacity(0.5), lineWidth: 1)
        )
        .cornerRadius(14)
        .shadow(color: color.opacity(0.35), radius: 12, x: 0, y: 8)
    }
}

struct FilterChip: View {
    let title: String
    let isSelected: Bool
    let color: Color
    
    var body: some View {
        Text(title)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(
                Group {
                    if isSelected {
                        LinearGradient(
                            colors: [color, color.opacity(0.6)],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    } else {
                        Color.lootBackground.opacity(0.8)
                    }
                }
            )
            .foregroundColor(isSelected ? .lootBackground : color)
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(color.opacity(isSelected ? 0.9 : 0.6), lineWidth: 1)
            )
            .shadow(color: color.opacity(isSelected ? 0.4 : 0.15), radius: 8, x: 0, y: 4)
    }
}

private struct LootCardModifier: ViewModifier {
    let borderColor: Color
    let cornerRadius: CGFloat
    
    func body(content: Content) -> some View {
        content
            .background(
                LinearGradient(
                    colors: [Color.lootBackground.opacity(0.95), Color.lootBackground.opacity(0.7)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(borderColor.opacity(0.6), lineWidth: 1)
            )
            .cornerRadius(cornerRadius)
            .shadow(color: borderColor.opacity(0.4), radius: 12, x: 0, y: 8)
    }
}

extension View {
    func lootCard(borderColor: Color, cornerRadius: CGFloat = 12) -> some View {
        modifier(LootCardModifier(borderColor: borderColor, cornerRadius: cornerRadius))
    }
}


