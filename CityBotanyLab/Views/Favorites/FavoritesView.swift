//
//  FavoritesView.swift
//  CityBotanyLab
//

import SwiftUI

struct FavoritesView: View {
    @EnvironmentObject var dataManager: DataManager
    @State private var selectedPlant: Plant?
    
    var favoritePlants: [Plant] {
        dataManager.plants.filter { dataManager.isFavorite($0) }
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                AppTheme.background
                    .ignoresSafeArea()
                
                if favoritePlants.isEmpty {
                    EmptyFavoritesView()
                } else {
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(favoritePlants) { plant in
                                FavoritePlantCard(plant: plant)
                                    .onTapGesture {
                                        selectedPlant = plant
                                    }
                            }
                        }
                        .padding(16)
                        .padding(.bottom, 100)
                    }
                }
            }
            .navigationTitle("Favorites")
            .sheet(item: $selectedPlant) { plant in
                PlantDetailView(plant: plant)
            }
        }
    }
}

struct EmptyFavoritesView: View {
    var body: some View {
        VStack(spacing: 24) {
            ZStack {
                Circle()
                    .fill(AppTheme.accentPink.opacity(0.1))
                    .frame(width: 120, height: 120)
                
                Image(systemName: "heart")
                    .font(.system(size: 50))
                    .foregroundColor(AppTheme.accentPink.opacity(0.5))
            }
            
            VStack(spacing: 8) {
                Text("No Favorites Yet")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(AppTheme.textPrimary)
                
                Text("Tap the heart icon on any plant\nto add it to your favorites")
                    .font(.body)
                    .foregroundColor(AppTheme.textSecondary)
                    .multilineTextAlignment(.center)
            }
        }
        .padding(32)
    }
}

struct FavoritePlantCard: View {
    let plant: Plant
    @EnvironmentObject var dataManager: DataManager
    
    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [AppTheme.primaryGreen.opacity(0.2), AppTheme.accentPink.opacity(0.1)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 70, height: 70)
                
                Image(systemName: plant.icon)
                    .font(.title)
                    .foregroundColor(AppTheme.primaryGreen)
            }
            
            VStack(alignment: .leading, spacing: 6) {
                Text(plant.name)
                    .font(.headline)
                    .foregroundColor(AppTheme.textPrimary)
                
                Text(plant.scientificName)
                    .font(.caption)
                    .foregroundColor(AppTheme.textSecondary)
                    .italic()
                
                HStack(spacing: 8) {
                    Label(plant.category.rawValue, systemImage: plant.category.icon)
                    Label(plant.careLevel.rawValue, systemImage: "leaf")
                }
                .font(.caption)
                .foregroundColor(AppTheme.textSecondary)
            }
            
            Spacer()
            
            Button(action: {
                withAnimation(.spring(response: 0.3)) {
                    dataManager.toggleFavorite(plant)
                }
            }) {
                Image(systemName: "heart.fill")
                    .font(.title2)
                    .foregroundColor(AppTheme.accentPink)
            }
        }
        .padding(16)
        .cardStyle()
    }
}

#Preview {
    FavoritesView()
        .environmentObject(DataManager())
}