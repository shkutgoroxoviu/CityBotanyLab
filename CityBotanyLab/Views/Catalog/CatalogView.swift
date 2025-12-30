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
        
        if let category = selectedCategory {
            plants = plants.filter { $0.category == category }
        }
        
        if let careLevel = selectedCareLevel {
            plants = plants.filter { $0.careLevel == careLevel }
        }
        
        if let sunReq = selectedSunRequirement {
            plants = plants.filter { $0.sunRequirement == sunReq }
        }
        
        if !searchText.isEmpty {
            plants = plants.filter {
                $0.name.localizedCaseInsensitiveContains(searchText) ||
                $0.scientificName.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        return plants
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                AppTheme.background
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Category filter
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            CategoryChip(
                                title: "All",
                                isSelected: selectedCategory == nil,
                                action: { selectedCategory = nil }
                            )
                            
                            ForEach(PlantCategory.allCases, id: \.self) { category in
                                CategoryChip(
                                    title: category.rawValue,
                                    icon: category.icon,
                                    isSelected: selectedCategory == category,
                                    action: { selectedCategory = category }
                                )
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                    }
                    
                    // Active filters indicator
                    if selectedCareLevel != nil || selectedSunRequirement != nil {
                        HStack {
                            Image(systemName: "line.3.horizontal.decrease.circle.fill")
                                .foregroundColor(AppTheme.accentPink)
                            Text("Filters active")
                                .font(.caption)
                                .foregroundColor(AppTheme.textSecondary)
                            Spacer()
                            Button("Clear") {
                                selectedCareLevel = nil
                                selectedSunRequirement = nil
                            }
                            .font(.caption)
                            .foregroundColor(AppTheme.accentPink)
                        }
                        .padding(.horizontal, 16)
                        .padding(.bottom, 8)
                    }
                    
                    // Plants list
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(filteredPlants) { plant in
                                PlantCard(plant: plant)
                                    .onTapGesture {
                                        selectedPlant = plant
                                    }
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.bottom, 100)
                    }
                }
            }
            .navigationTitle("Plant Catalog")
            .searchable(text: $searchText, prompt: "Search plants...")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingFilters = true }) {
                        Image(systemName: "slider.horizontal.3")
                            .foregroundColor(AppTheme.primaryGreen)
                    }
                }
            }
            .sheet(item: $selectedPlant) { plant in
                PlantDetailView(plant: plant)
            }
            .sheet(isPresented: $showingFilters) {
                FilterView(
                    selectedCareLevel: $selectedCareLevel,
                    selectedSunRequirement: $selectedSunRequirement
                )
            }
        }
    }
}

struct CategoryChip: View {
    let title: String
    var icon: String?
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                if let icon = icon {
                    Image(systemName: icon)
                        .font(.caption)
                }
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.medium)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(isSelected ? AppTheme.primaryGreen : AppTheme.cardBackground)
            .foregroundColor(isSelected ? .white : AppTheme.textPrimary)
            .cornerRadius(20)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(isSelected ? Color.clear : AppTheme.textSecondary.opacity(0.2), lineWidth: 1)
            )
        }
    }
}

struct PlantCard: View {
    let plant: Plant
    @EnvironmentObject var dataManager: DataManager
    
    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(AppTheme.primaryGreen.opacity(0.15))
                    .frame(width: 60, height: 60)
                
                Image(systemName: plant.icon)
                    .font(.title2)
                    .foregroundColor(AppTheme.primaryGreen)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(plant.name)
                    .font(.headline)
                    .foregroundColor(AppTheme.textPrimary)
                
                Text(plant.scientificName)
                    .font(.caption)
                    .foregroundColor(AppTheme.textSecondary)
                    .italic()
                
                HStack(spacing: 8) {
                    Label(plant.careLevel.rawValue, systemImage: "leaf")
                        .tagStyle()
                    
                    Label(plant.category.rawValue, systemImage: plant.category.icon)
                        .tagStyle()
                }
            }
            
            Spacer()
            
            Button(action: {
                dataManager.toggleFavorite(plant)
            }) {
                Image(systemName: dataManager.isFavorite(plant) ? "heart.fill" : "heart")
                    .foregroundColor(dataManager.isFavorite(plant) ? AppTheme.accentPink : AppTheme.textSecondary)
            }
        }
        .padding(16)
        .cardStyle()
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
                        Button(action: {
                            if selectedCareLevel == level {
                                selectedCareLevel = nil
                            } else {
                                selectedCareLevel = level
                            }
                        }) {
                            HStack {
                                Text(level.rawValue)
                                    .foregroundColor(AppTheme.textPrimary)
                                Spacer()
                                if selectedCareLevel == level {
                                    Image(systemName: "checkmark")
                                        .foregroundColor(AppTheme.primaryGreen)
                                }
                            }
                        }
                    }
                }
                
                Section("Sun Requirement") {
                    ForEach(SunRequirement.allCases, id: \.self) { req in
                        Button(action: {
                            if selectedSunRequirement == req {
                                selectedSunRequirement = nil
                            } else {
                                selectedSunRequirement = req
                            }
                        }) {
                            HStack {
                                Text(req.rawValue)
                                    .foregroundColor(AppTheme.textPrimary)
                                Spacer()
                                if selectedSunRequirement == req {
                                    Image(systemName: "checkmark")
                                        .foregroundColor(AppTheme.primaryGreen)
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Filters")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { dismiss() }
                }
            }
        }
        .presentationDetents([.medium])
    }
}

#Preview {
    CatalogView()
        .environmentObject(DataManager())
}