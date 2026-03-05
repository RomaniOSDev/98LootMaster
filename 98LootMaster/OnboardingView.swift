import SwiftUI

struct OnboardingView: View {
    @Binding var hasSeenOnboarding: Bool
    @State private var currentPage: Int = 0
    
    var body: some View {
        ZStack {
            Color.lootBackground
                .ignoresSafeArea()
            
            VStack(spacing: 24) {
                TabView(selection: $currentPage) {
                    OnboardingPage(
                        icon: "archivebox.fill",
                        title: "Track your drops",
                        description: "Log every item you loot, from common materials to legendary treasures."
                    )
                    .tag(0)
                    
                    OnboardingPage(
                        icon: "rectangle.stack.fill",
                        title: "Organize sessions",
                        description: "Group drops into raid sessions, record locations, difficulty and party members."
                    )
                    .tag(1)
                    
                    OnboardingPage(
                        icon: "chart.bar.fill",
                        title: "See your stats",
                        description: "View rarity distribution, top sources and daily activity in one place."
                    )
                    .tag(2)
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
                .indexViewStyle(.page(backgroundDisplayMode: .always))
                
                bottomControls
            }
            .padding()
        }
    }
    
    private var bottomControls: some View {
        HStack {
            Button {
                hasSeenOnboarding = true
            } label: {
                Text("Skip")
                    .foregroundColor(.lootCommon)
                    .font(.subheadline)
            }
            
            Spacer()
            
            Button {
                if currentPage < 2 {
                    currentPage += 1
                } else {
                    hasSeenOnboarding = true
                }
            } label: {
                HStack {
                    Text(currentPage == 2 ? "Start tracking" : "Next")
                        .bold()
                    Image(systemName: currentPage == 2 ? "checkmark.circle.fill" : "chevron.right")
                }
                .foregroundColor(.lootBackground)
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                .background(
                    LinearGradient(
                        colors: [Color.lootRare, Color.lootCommon],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .cornerRadius(20)
                .shadow(color: Color.lootRare.opacity(0.6), radius: 10, x: 0, y: 6)
            }
        }
    }
}

private struct OnboardingPage: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        VStack(spacing: 20) {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [Color.lootRare, Color.lootCommon],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 120, height: 120)
                    .shadow(color: Color.lootRare.opacity(0.7), radius: 16, x: 0, y: 10)
                
                Image(systemName: icon)
                    .foregroundColor(.lootBackground)
                    .font(.system(size: 48, weight: .bold))
            }
            
            Text(title)
                .foregroundColor(.white)
                .font(.title2)
                .bold()
                .multilineTextAlignment(.center)
            
            Text(description)
                .foregroundColor(.gray)
                .font(.body)
                .multilineTextAlignment(.center)
        }
        .padding()
    }
}

