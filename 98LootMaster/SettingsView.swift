import SwiftUI
import StoreKit
import UIKit

struct SettingsView: View {
    var body: some View {
        ZStack {
            Color.lootBackground
                .ignoresSafeArea()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    header
                    rateSection
                    legalSection
                }
                .padding()
            }
        }
    }
    
    private var header: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Settings")
                .foregroundColor(.lootRare)
                .font(.largeTitle)
                .bold()
            
            Text("Manage your experience and app links.")
                .foregroundColor(.gray)
                .font(.subheadline)
        }
    }
    
    private var rateSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Enjoying the app?")
                .foregroundColor(.lootRare)
                .font(.headline)
            
            Text("Let other players know what you think.")
                .foregroundColor(.gray)
                .font(.caption)
            
            Button {
                rateApp()
            } label: {
                HStack {
                    Image(systemName: "star.fill")
                    Text("Rate us")
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
                .shadow(color: Color.lootRare.opacity(0.6), radius: 12, x: 0, y: 8)
            }
        }
        .padding()
        .lootCard(borderColor: .lootRare)
    }
    
    private var legalSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Legal")
                .foregroundColor(.lootRare)
                .font(.headline)
            
            VStack(spacing: 10) {
                settingsRow(
                    title: "Privacy Policy",
                    icon: "lock.shield",
                    action: openPrivacyPolicy
                )
                
                Divider().background(Color.lootBackground)
                
                settingsRow(
                    title: "Terms of Use",
                    icon: "doc.text",
                    action: openTermsOfUse
                )
            }
        }
        .padding()
        .lootCard(borderColor: .lootRare)
    }
    
    private func settingsRow(title: String, icon: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(.lootCommon)
                    .frame(width: 24)
                
                Text(title)
                    .foregroundColor(.white)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundColor(.gray)
                    .font(.caption)
            }
            .padding(.vertical, 4)
        }
    }
    
    // MARK: - Actions
    
    private func openPrivacyPolicy() {
        if let url = URL(string: "https://www.termsfeed.com/live/2eed985c-8210-45e8-bcd5-59eccd8bbe07") {
            UIApplication.shared.open(url)
        }
    }
    
    private func openTermsOfUse() {
        if let url = URL(string: "https://www.termsfeed.com/live/d4cffd8a-7a84-45fa-a9de-0aae3457cce6") {
            UIApplication.shared.open(url)
        }
    }
    
    private func rateApp() {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            SKStoreReviewController.requestReview(in: windowScene)
        }
    }
}

