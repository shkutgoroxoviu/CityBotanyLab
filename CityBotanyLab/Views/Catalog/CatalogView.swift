//
//  CatalogView.swift
//  CityBotanyLab
//

import SwiftUI

struct CatalogView: View {
    @EnvironmentObject var dataManager: DataManager
    @State private var searchText = ""
    @State private var selectedCategory: PlantCategory?
    @State private var selectedPlant: Plant?
    @State private var showingFilters = false
    @State private var selectedCareLevel: CareLevel?
    @State private var selectedSunRequirement: SunRequirement?
    
    var filteredPlants: [Plant] {
        var plants = dataManager.plants
        if !searchText.isEmpty {
            plants = plants.filter { $0.name.localizedCaseInsensitiveContains(searchText) || $0.scientificName.localizedCaseInsensitiveContains(searchText) }
        }
        if let category = selectedCategory { plants = plants.filter { $0.category == category } }
        if let careLevel = selectedCareLevel { plants = plants.filter { $0.careLevel == careLevel } }
        if let sunRequirement = selectedSunRequirement { plants = plants.filter { $0.sunRequirement == sunRequirement } }
        return plants
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                AppTheme.background.ignoresSafeArea()
                VStack(spacing: 0) {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 10) {
                            CategoryChip(title: "All", icon: "рџЊЌ", isSelected: selectedCategory == nil) {
                                withAnimation { selectedCategory = nil }
                            }
                            ForEach(PlantCategory.allCases, id: \.self) { category in
                                CategoryChip(title: category.rawValue, icon: category.icon, isSelected: selectedCategory == category) {
                                    withAnimation { selectedCategory = category }
                                }
                            }
                        }.padding(.horizontal, 16)
                    }.padding(.vertical, 12)
                    
                    if selectedCareLevel != nil || selectedSunRequirement != nil {
                        HStack {
                            Text("Filters active").font(.system(size: 13, weight: .medium)).foregroundColor(AppTheme.accentPink)
                            Spacer()
                            Button("Clear all") { withAnimation { selectedCareLevel = nil; selectedSunRequirement = nil } }
                                .font(.system(size: 13, weight: .medium)).foregroundColor(AppTheme.primaryGreen)
                        }.padding(.horizontal, 16).padding(.bottom, 8)
                    }
                    
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(filteredPlants) { plant in
                                PlantCard(plant: plant).onTapGesture { selectedPlant = plant }
                            }
                        }.padding(.horizontal, 16).padding(.bottom, 20)
                    }
                }
            }
            .navigationTitle("Plant Catalog")
            .searchable(text: $searchText, prompt: "Search plants...")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button { showingFilters = true } label: {
                        Image(systemName: "slider.horizontal.3").foregroundColor(AppTheme.primaryGreen)
                    }
                }
            }
            .sheet(item: $selectedPlant) { plant in PlantDetailView(plant: plant) }
            .sheet(isPresented: $showingFilters) {
                FilterView(selectedCareLevel: $selectedCareLevel, selectedSunRequirement: $selectedSunRequirement).presentationDetents([.medium])
            }
        }
    }
}

struct CategoryChip: View {
    let title: String; let icon: String; let isSelected: Bool; let action: () -> Void
    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) { Text(icon).font(.system(size: 14)); Text(title).font(.system(size: 14, weight: .medium)) }
                .foregroundColor(isSelected ? .white : AppTheme.textPrimary)
                .padding(.horizontal, 14).padding(.vertical, 10)
                .background(isSelected ? AppTheme.primaryGreen : Color.white)
                .cornerRadius(20).shadow(color: AppTheme.darkGreen.opacity(0.08), radius: 4, x: 0, y: 2)
        }
    }
}

struct PlantCard: View {
    let plant: Plant
    @EnvironmentObject var dataManager: DataManager
    
    var body: some View {
        HStack(spacing: 14) {
            ZStack { Circle().fill(AppTheme.paleGreen).frame(width: 60, height: 60); Text(plant.icon).font(.system(size: 28)) }
            VStack(alignment: .leading, spacing: 4) {
                Text(plant.name).font(.system(size: 17, weight: .semibold)).foregroundColor(AppTheme.textPrimary)
                Text(plant.scientificName).font(.system(size: 13)).foregroundColor(AppTheme.textSecondary).italic()
                HStack(spacing: 8) {
                    Text(plant.category.rawValue).tagStyle(color: AppTheme.primaryGreen)
                    Text(plant.careLevel.rawValue).tagStyle(color: careLevelColor)
                }.padding(.top, 4)
            }
            Spacer()
            Button { withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) { dataManager.toggleFavorite(plantId: plant.id) } } label: {
                Image(systemName: dataManager.isFavorite(plantId: plant.id) ? "heart.fill" : "heart")
                    .font(.system(size: 20)).foregroundColor(dataManager.isFavorite(plantId: plant.id) ? AppTheme.accentPink : AppTheme.textSecondary)
            }
            Image(systemName: "chevron.right").font(.system(size: 14, weight: .medium)).foregroundColor(AppTheme.textSecondary.opacity(0.5))
        }.padding(16).cardStyle()
    }
    
    private var careLevelColor: Color {
        switch plant.careLevel { case .low: return AppTheme.primaryGreen; case .medium: return .orange; case .high: return AppTheme.accentPink }
    }
}

struct FilterView: View {
    @Binding var selectedCareLevel: CareLevel?
    @Binding var selectedSunRequirement: SunRequirement?
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Care Level") {
                    ForEach(CareLevel.allCases, id: \.self) { level in
                        HStack { Text(level.rawValue); Spacer(); if selectedCareLevel == level { Image(systemName: "checkmark").foregroundColor(AppTheme.primaryGreen) } }
                            .contentShape(Rectangle()).onTapGesture { selectedCareLevel = selectedCareLevel == level ? nil : level }
                    }
                }
                Section("Sun Requirement") {
                    ForEach(SunRequirement.allCases, id: \.self) { req in
                        HStack { Text(req.rawValue); Spacer(); if selectedSunRequirement == req { Image(systemName: "checkmark").foregroundColor(AppTheme.primaryGreen) } }
                            .contentShape(Rectangle()).onTapGesture { selectedSunRequirement = selectedSunRequirement == req ? nil : req }
                    }
                }
            }
            .navigationTitle("Filters").navigationBarTitleDisplayMode(.inline)
            .toolbar { ToolbarItem(placement: .navigationBarTrailing) { Button("Done") { dismiss() }.foregroundColor(AppTheme.primaryGreen) } }
        }
    }
}
