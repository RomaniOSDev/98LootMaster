//
//  ContentView.swift
//  98LootMaster
//
//  Created by Роман Главацкий on 05.03.2026.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = LootMasterViewModel()
    @State private var selectedTab = 0
    @AppStorage("lootmaster_hasSeenOnboarding") private var hasSeenOnboarding: Bool = false
    
    var body: some View {
        Group {
            if hasSeenOnboarding {
                mainTabView
            } else {
                OnboardingView(hasSeenOnboarding: $hasSeenOnboarding)
            }
        }
        .preferredColorScheme(.dark)
        .onAppear {
            viewModel.loadFromUserDefaults()
        }
        .accentColor(.lootRare)
    }

    private var mainTabView: some View {
        TabView(selection: $selectedTab) {
            HomeView(viewModel: viewModel, selectedTab: $selectedTab)
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
                .tag(0)
            
            LootFeedView(viewModel: viewModel)
                .tabItem {
                    Label("Feed", systemImage: "archivebox")
                }
                .tag(1)
            
            SessionsView(viewModel: viewModel)
                .tabItem {
                    Label("Sessions", systemImage: "rectangle.stack.fill")
                }
                .tag(2)
            
            ItemsView(viewModel: viewModel)
                .tabItem {
                    Label("Items", systemImage: "backpack.fill")
                }
                .tag(3)
            
            CharactersView(viewModel: viewModel)
                .tabItem {
                    Label("Characters", systemImage: "person.fill")
                }
                .tag(4)
            
            StatsView(viewModel: viewModel)
                .tabItem {
                    Label("Stats", systemImage: "chart.bar.fill")
                }
                .tag(5)
            
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gearshape.fill")
                }
                .tag(6)
        }
    }
}

