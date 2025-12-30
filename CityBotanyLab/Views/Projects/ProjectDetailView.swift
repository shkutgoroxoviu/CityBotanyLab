//
//  ProjectDetailView.swift
//  CityBotanyLab
//

import SwiftUI

struct ProjectDetailView: View {
    @EnvironmentObject var dataManager: DataManager
    @Environment(\.dismiss) var dismiss
    @State var project: Project
    @State private var showingAddPlant = false
    @State private var showingEditStatus = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    // Header
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text(project.name)
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(AppTheme.textPrimary)
                            
                            Spacer()
                            
                            Button(action: { showingEditStatus = true }) {
                                StatusBadge(status: project.status)
                            }
                        }
                        
                        Text(project.locationType.rawValue)
                            .font(.subheadline)
                            .foregroundColor(AppTheme.textSecondary)
                    }
                    .padding(.horizontal, 16)
                    
                    // Description
                    if !project.projectDescription.isEmpty {
                        Text(project.projectDescription)
                            .font(.body)
                            .foregroundColor(AppTheme.textSecondary)
                            .padding(.horizontal, 16)
                    }
                    
                    // Stats
                    HStack(spacing: 16) {
                        StatCard(title: "Area", value: "\(Int(project.area))", unit: "sqm", icon: "square.dashed")
                        StatCard(title: "Plants", value: "\(project.plants.count)", unit: "types", icon: "leaf")
                        StatCard(title: "Total", value: "\(project.plants.reduce(0) { $0 + $1.quantity })", unit: "units", icon: "number")
                    }
                    .padding(.horizontal, 16)
                    
                    // Timeline
                    if let targetDate = project.targetCompletionDate {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Timeline")
                                .font(.headline)
                                .foregroundColor(AppTheme.textPrimary)
                            
                            HStack {
                                Label("Created", systemImage: "calendar")
                                Spacer()
                                Text(project.createdDate.formatted(date: .abbreviated, time: .omitted))
                            }
                            .font(.subheadline)
                            .foregroundColor(AppTheme.textSecondary)
                            
                            HStack {
                                Label("Target", systemImage: "flag.fill")
                                Spacer()
                                Text(targetDate.formatted(date: .abbreviated, time: .omitted))
                            }
                            .font(.subheadline)
                            .foregroundColor(AppTheme.textSecondary)
                        }
                        .padding(16)
                        .cardStyle()
                        .padding(.horizontal, 16)
                    }
                    
                    // Plants
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Text("Plants")
                                .font(.headline)
                                .foregroundColor(AppTheme.textPrimary)
                            
                            Spacer()
                            
                            Button(action: { showingAddPlant = true }) {
                                Image(systemName: "plus.circle.fill")
                                    .foregroundColor(AppTheme.primaryGreen)
                            }
                        }
                        
                        if project.plants.isEmpty {
                            Text("No plants added yet")
                                .font(.subheadline)
                                .foregroundColor(AppTheme.textSecondary)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 24)
                        } else {
                            ForEach(project.plants) { plantEntry in
                                ProjectPlantRow(
                                    plantEntry: plantEntry,
                                    onDelete: {
                                        removePlant(plantEntry)
                                    }
                                )
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                    
                    // Notes
                    if !project.notes.isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Notes")
                                .font(.headline)
                                .foregroundColor(AppTheme.textPrimary)
                            
                            Text(project.notes)
                                .font(.body)
                                .foregroundColor(AppTheme.textSecondary)
                        }
                        .padding(.horizontal, 16)
                    }
                    
                    // Delete Button
                    Button(action: deleteProject) {
                        HStack {
                            Image(systemName: "trash")
                            Text("Delete Project")
                        }
                        .foregroundColor(.red)
                        .frame(maxWidth: .infinity)
                        .padding()
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 32)
                }
                .padding(.top, 16)
            }
            .background(AppTheme.background)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") { dismiss() }
                }
            }
            .sheet(isPresented: $showingAddPlant) {
                AddPlantToProjectView(project: $project, onSave: saveProject)
            }
            .confirmationDialog("Update Status", isPresented: $showingEditStatus) {
                ForEach(ProjectStatus.allCases, id: \.self) { status in
                    Button(status.rawValue) {
                        project.status = status
                        saveProject()
                    }
                }
                Button("Cancel", role: .cancel) {}
            }
        }
    }
    
    private func removePlant(_ plantEntry: ProjectPlant) {
        project.plants.removeAll { $0.id == plantEntry.id }
        saveProject()
    }
    
    private func saveProject() {
        dataManager.updateProject(project)
    }
    
    private func deleteProject() {
        dataManager.deleteProject(project)
        dismiss()
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let unit: String
    let icon: String
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(AppTheme.primaryGreen)
            
            Text(value)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(AppTheme.textPrimary)
            
            Text(unit)
                .font(.caption)
                .foregroundColor(AppTheme.textSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .cardStyle()
    }
}

struct ProjectPlantRow: View {
    let plantEntry: ProjectPlant
    let onDelete: () -> Void
    
    var plant: Plant? {
        PlantDatabase.allPlants.first { $0.id == plantEntry.plantId }
    }
    
    var body: some View {
        HStack(spacing: 12) {
            if let plant = plant {
                Image(systemName: plant.icon)
                    .font(.title3)
                    .foregroundColor(AppTheme.primaryGreen)
                    .frame(width: 40)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(plant.name)
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(AppTheme.textPrimary)
                    
                    Text("Qty: \(plantEntry.quantity)")
                        .font(.caption)
                        .foregroundColor(AppTheme.textSecondary)
                }
            }
            
            Spacer()
            
            Button(action: onDelete) {
                Image(systemName: "xmark.circle.fill")
                    .foregroundColor(AppTheme.textSecondary)
            }
        }
        .padding(12)
        .background(AppTheme.cardBackground.opacity(0.5))
        .cornerRadius(8)
    }
}

struct AddPlantToProjectView: View {
    @Binding var project: Project
    let onSave: () -> Void
    @Environment(\.dismiss) var dismiss
    
    @State private var selectedPlant: Plant?
    @State private var quantity = 1
    @State private var searchText = ""
    
    var filteredPlants: [Plant] {
        if searchText.isEmpty {
            return PlantDatabase.allPlants
        }
        return PlantDatabase.allPlants.filter {
            $0.name.localizedCaseInsensitiveContains(searchText)
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                if let plant = selectedPlant {
                    // Selected plant
                    VStack(spacing: 16) {
                        HStack(spacing: 12) {
                            Image(systemName: plant.icon)
                                .font(.title)
                                .foregroundColor(AppTheme.primaryGreen)
                            
                            VStack(alignment: .leading) {
                                Text(plant.name)
                                    .font(.headline)
                                Text(plant.scientificName)
                                    .font(.caption)
                                    .foregroundColor(AppTheme.textSecondary)
                            }
                            
                            Spacer()
                            
                            Button(action: { selectedPlant = nil }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(AppTheme.textSecondary)
                            }
                        }
                        .padding()
                        .cardStyle()
                        
                        Stepper("Quantity: \(quantity)", value: $quantity, in: 1...1000)
                            .padding()
                    }
                    .padding()
                    
                    Spacer()
                } else {
                    // Plant picker
                    List(filteredPlants) { plant in
                        Button(action: {
                            selectedPlant = plant
                        }) {
                            HStack(spacing: 12) {
                                Image(systemName: plant.icon)
                                    .foregroundColor(AppTheme.primaryGreen)
                                
                                VStack(alignment: .leading) {
                                    Text(plant.name)
                                        .foregroundColor(AppTheme.textPrimary)
                                    Text(plant.category.rawValue)
                                        .font(.caption)
                                        .foregroundColor(AppTheme.textSecondary)
                                }
                            }
                        }
                    }
                    .searchable(text: $searchText, prompt: "Search plants...")
                }
            }
            .navigationTitle("Add Plant")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") {
                        if let plant = selectedPlant {
                            let projectPlant = ProjectPlant(plantId: plant.id, quantity: quantity)
                            project.plants.append(projectPlant)
                            onSave()
                            dismiss()
                        }
                    }
                    .disabled(selectedPlant == nil)
                }
            }
        }
    }
}

#Preview {
    ProjectDetailView(project: Project(
        name: "Central Park Renovation",
        projectDescription: "Renovating the east side gardens",
        locationType: .park,
        area: 500,
        plants: [],
        targetCompletionDate: Date(),
        status: .planning,
        notes: "Focus on native species"
    ))
    .environmentObject(DataManager())
}