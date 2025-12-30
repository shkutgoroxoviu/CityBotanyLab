//
//  AddProjectView.swift
//  CityBotanyLab
//

import SwiftUI

struct AddProjectView: View {
    @EnvironmentObject var dataManager: DataManager
    @Environment(\.dismiss) var dismiss
    @State private var name = ""
    @State private var projectDescription = ""
    @State private var locationType: UrbanLocation = .park
    @State private var area: String = ""
    @State private var status: ProjectStatus = .planning
    @State private var targetDate = Date()
    @State private var hasTargetDate = false
    @State private var notes = ""
    @State private var showingPlantPicker = false
    @State private var selectedPlants: [ProjectPlant] = []
    
    private var isValid: Bool { !name.trimmingCharacters(in: .whitespaces).isEmpty }
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Project Info") {
                    TextField("Project Name", text: $name)
                    TextField("Description (optional)", text: $projectDescription, axis: .vertical).lineLimit(3...6)
                    Picker("Location Type", selection: $locationType) {
                        ForEach(UrbanLocation.allCases, id: \.self) { Text($0.rawValue).tag($0) }
                    }
                    HStack {
                        Text("Area"); Spacer()
                        TextField("0", text: $area).keyboardType(.decimalPad).multilineTextAlignment(.trailing).frame(width: 80)
                        Text("mВІ").foregroundColor(AppTheme.textSecondary)
                    }
                    Picker("Status", selection: $status) {
                        ForEach(ProjectStatus.allCases, id: \.self) { HStack { Text($0.icon); Text($0.rawValue) }.tag($0) }
                    }
                }
                Section("Target Date") {
                    Toggle("Set Target Date", isOn: $hasTargetDate)
                    if hasTargetDate { DatePicker("Target Completion", selection: $targetDate, displayedComponents: .date) }
                }
                Section {
                    Button { showingPlantPicker = true } label: {
                        HStack {
                            Text("Add Plants"); Spacer()
                            Text("\(selectedPlants.count) selected").foregroundColor(AppTheme.textSecondary)
                            Image(systemName: "chevron.right").font(.system(size: 14)).foregroundColor(AppTheme.textSecondary.opacity(0.5))
                        }
                    }.foregroundColor(AppTheme.textPrimary)
                    if !selectedPlants.isEmpty {
                        ForEach(selectedPlants) { pp in
                            HStack {
                                if let plant = dataManager.plant(for: pp.plantId) { Text(plant.icon) }
                                Text(pp.plantName); Spacer(); Text("Г—\(pp.quantity)").foregroundColor(AppTheme.textSecondary)
                            }
                        }.onDelete { selectedPlants.remove(atOffsets: $0) }
                    }
                } header: { Text("Plants") }
                Section("Notes") { TextField("Additional notes...", text: $notes, axis: .vertical).lineLimit(4...8) }
            }
            .navigationTitle("New Project").navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) { Button("Cancel") { dismiss() }.foregroundColor(AppTheme.textSecondary) }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") { saveProject() }.font(.system(size: 16, weight: .semibold))
                        .foregroundColor(isValid ? AppTheme.primaryGreen : AppTheme.textSecondary).disabled(!isValid)
                }
            }
            .sheet(isPresented: $showingPlantPicker) { PlantPickerView(selectedPlants: $selectedPlants) }
        }
    }
    
    private func saveProject() {
        let project = Project(name: name.trimmingCharacters(in: .whitespaces), projectDescription: projectDescription.trimmingCharacters(in: .whitespaces),
            locationType: locationType, area: Double(area) ?? 0, plants: selectedPlants, createdDate: Date(),
            targetCompletionDate: hasTargetDate ? targetDate : nil, status: status, notes: notes.trimmingCharacters(in: .whitespaces))
        dataManager.addProject(project); dismiss()
    }
}

struct PlantPickerView: View {
    @Binding var selectedPlants: [ProjectPlant]
    @EnvironmentObject var dataManager: DataManager
    @Environment(\.dismiss) var dismiss
    @State private var searchText = ""
    
    var filteredPlants: [Plant] {
        if searchText.isEmpty { return dataManager.plants }
        return dataManager.plants.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
    }
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(filteredPlants) { plant in
                    HStack {
                        Text(plant.icon).font(.system(size: 24))
                        VStack(alignment: .leading, spacing: 2) {
                            Text(plant.name).font(.system(size: 16, weight: .medium))
                            Text(plant.category.rawValue).font(.system(size: 13)).foregroundColor(AppTheme.textSecondary)
                        }
                        Spacer()
                        if let existing = selectedPlants.first(where: { $0.plantId == plant.id }) {
                            Stepper(value: Binding(
                                get: { existing.quantity },
                                set: { newValue in
                                    if newValue <= 0 { selectedPlants.removeAll { $0.plantId == plant.id } }
                                    else if let index = selectedPlants.firstIndex(where: { $0.plantId == plant.id }) {
                                        selectedPlants[index] = ProjectPlant(id: existing.id, plantId: plant.id, plantName: plant.name, quantity: newValue)
                                    }
                                }
                            ), in: 0...999) { Text("\(existing.quantity)").font(.system(size: 14, weight: .semibold)).frame(width: 30) }
                        } else {
                            Button { selectedPlants.append(ProjectPlant(plantId: plant.id, plantName: plant.name, quantity: 1)) } label: {
                                Image(systemName: "plus.circle.fill").font(.system(size: 24)).foregroundColor(AppTheme.primaryGreen)
                            }
                        }
                    }.padding(.vertical, 4)
                }
            }
            .searchable(text: $searchText, prompt: "Search plants...")
            .navigationTitle("Select Plants").navigationBarTitleDisplayMode(.inline)
            .toolbar { ToolbarItem(placement: .navigationBarTrailing) { Button("Done") { dismiss() }.font(.system(size: 16, weight: .semibold)).foregroundColor(AppTheme.primaryGreen) } }
        }
    }
}
