//
//  FavoritesView.swift
//  CityBotanyLab
//

import SwiftUI

struct FavoritesView: View {
    @EnvironmentObject var dataManager: DataManager
    @State private var selectedPlant: Plant?
    @State private var sortOption: FavoritesSortOption = .name
    
    var sortedFavorites: [Plant] {
        let favorites = dataManager.favoritePlants
        switch sortOption {
        case .name: return favorites.sorted { $0.name < $1.name }
        case .category: return favorites.sorted { $0.category.rawValue < $1.category.rawValue }
        case .careLevel: return favorites.sorted { careLevelOrder($0.careLevel) < careLevelOrder($1.careLevel) }
        }
    }
    
    private func careLevelOrder(_ level: CareLevel) -> Int { switch level { case .low: return 0; case .medium: return 1; case .high: return 2 } }
    
    var body: some View {
        NavigationStack {
            ZStack {
                AppTheme.background.ignoresSafeArea()
                if dataManager.favoritePlants.isEmpty {
                    EmptyFavoritesView()
                } else {
                    VStack(spacing: 0) {
                        HStack {
                            Text("Sort by:").font(.system(size: 14)).foregroundColor(AppTheme.textSecondary)
                            Picker("Sort", selection: $sortOption) { ForEach(FavoritesSortOption.allCases, id: \.self) { Text($0.rawValue).tag($0) } }.pickerStyle(.segmented)
                        }.padding(.horizontal, 16).padding(.vertical, 12)
                        
                        HStack { Text("\(dataManager.favoritePlants.count) favorites").font(.system(size: 14, weight: .medium)).foregroundColor(AppTheme.accentPink); Spacer() }
                            .padding(.horizontal, 16).padding(.bottom, 8)
                        
                        ScrollView {
                            LazyVGrid(columns: [GridItem(.flexible(), spacing: 12), GridItem(.flexible(), spacing: 12)], spacing: 12) {
                                ForEach(sortedFavorites) { plant in FavoritePlantCard(plant: plant).onTapGesture { selectedPlant = plant } }
                            }.padding(.horizontal, 16).padding(.bottom, 20)
                        }
                    }
                }
            }
            .navigationTitle("Favorites")
            .sheet(item: $selectedPlant) { plant in PlantDetailView(plant: plant) }
        }
    }
}

enum FavoritesSortOption: String, CaseIterable { case name = "Name"; case category = "Category"; case careLevel = "Care" }

struct EmptyFavoritesView: View {
    var body: some View {
        VStack(spacing: 24) {
            ZStack { Circle().fill(AppTheme.softPink).frame(width: 120, height: 120); Image(systemName: "heart").font(.system(size: 50)).foregroundColor(AppTheme.accentPink) }
            VStack(spacing: 8) {
                Text("No Favorites Yet").font(.system(size: 22, weight: .bold)).foregroundColor(AppTheme.textPrimary)
                Text("Browse the catalog and tap the heart\nicon to add plants to your favorites").font(.system(size: 15)).foregroundColor(AppTheme.textSecondary).multilineTextAlignment(.center).lineSpacing(4)
            }
            HStack(spacing: 4) { Text("Tip: Tap").foregroundColor(AppTheme.textSecondary); Image(systemName: "heart").foregroundColor(AppTheme.accentPink); Text("on any plant card").foregroundColor(AppTheme.textSecondary) }.font(.system(size: 14))
        }.padding(40)
    }
}

struct FavoritePlantCard: View {
    let plant: Plant
    @EnvironmentObject var dataManager: DataManager
    
    var body: some View {
        VStack(spacing: 12) {
            ZStack { Circle().fill(AppTheme.softGradient).frame(width: 70, height: 70); Text(plant.icon).font(.system(size: 36)) }
            VStack(spacing: 4) {
                Text(plant.name).font(.system(size: 15, weight: .semibold)).foregroundColor(AppTheme.textPrimary).lineLimit(1)
                Text(plant.category.rawValue).font(.system(size: 12)).foregroundColor(AppTheme.textSecondary)
            }
            HStack(spacing: 4) {
                ForEach(0..<3) { index in Circle().fill(index < careLevelDots ? careLevelColor : Color.gray.opacity(0.2)).frame(width: 8, height: 8) }
            }
            Button { withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) { dataManager.toggleFavorite(plantId: plant.id) } } label: {
                HStack(spacing: 4) { Image(systemName: "heart.fill").font(.system(size: 12)); Text("Remove").font(.system(size: 12, weight: .medium)) }
                    .foregroundColor(AppTheme.accentPink).padding(.horizontal, 12).padding(.vertical, 6).background(AppTheme.softPink).cornerRadius(12)
            }
        }.padding(16).frame(maxWidth: .infinity).background(Color.white).cornerRadius(16).shadow(color: AppTheme.darkGreen.opacity(0.08), radius: 8, x: 0, y: 4)
    }
    
    private var careLevelDots: Int { switch plant.careLevel { case .low: return 1; case .medium: return 2; case .high: return 3 } }
    private var careLevelColor: Color { switch plant.careLevel { case .low: return AppTheme.primaryGreen; case .medium: return .orange; case .high: return AppTheme.accentPink } }
}
