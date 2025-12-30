//
//  MainTabView.swift
//  CityBotanyLab
//

import SwiftUI

struct MainTabView: View {
    @EnvironmentObject var dataManager: DataManager
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            CatalogView()
                .tabItem {
                    Image(systemName: selectedTab == 0 ? "leaf.fill" : "leaf")
                    Text("Catalog")
                }
                .tag(0)
            
            ProjectsView()
                .tabItem {
                    Image(systemName: selectedTab == 1 ? "folder.fill" : "folder")
                    Text("Projects")
                }
                .tag(1)
            
            JournalView()
                .tabItem {
                    Image(systemName: selectedTab == 2 ? "book.fill" : "book")
                    Text("Journal")
                }
                .tag(2)
            
            CalculatorView()
                .tabItem {
                    Image(systemName: selectedTab == 3 ? "function" : "function")
                    Text("Calculate")
                }
                .tag(3)
            
            FavoritesView()
                .tabItem {
                    Image(systemName: selectedTab == 4 ? "heart.fill" : "heart")
                    Text("Favorites")
                }
                .tag(4)
        }
        .tint(AppTheme.primaryGreen)
        .onAppear {
            configureTabBarAppearance()
        }
    }
    
    private func configureTabBarAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(AppTheme.cardBackground)
        
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
}

#Preview {
    MainTabView()
        .environmentObject(DataManager())
}