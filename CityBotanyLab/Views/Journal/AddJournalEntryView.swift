//
//  AddJournalEntryView.swift
//  CityBotanyLab
//

import SwiftUI

struct AddJournalEntryView: View {
    @EnvironmentObject var dataManager: DataManager
    @Environment(\.dismiss) var dismiss
    @State private var date = Date()
    @State private var activityType: CareActivity = .watering
    @State private var plantName = ""
    @State private var selectedPlantFromCatalog: Plant?
    @State private var projectName = ""
    @State private var notes = ""
    @State private var location = ""
    @State private var showPlantPicker = false
    
    private var isValid: Bool { !plantName.trimmingCharacters(in: .whitespaces).isEmpty }
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Activity Type") {
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                        ForEach(CareActivity.allCases, id: \.self) { activity in
                            ActivityTypeButton(activity: activity, isSelected: activityType == activity) { activityType = activity }
                        }
                    }.padding(.vertical, 8)
                }
                Section("Plant") {
                    TextField("Plant Name", text: $plantName)
                    Button { showPlantPicker = true } label: {
                        HStack {
                            Text("Choose from Catalog"); Spacer()
                            if let plant = selectedPlantFromCatalog { Text(plant.icon) }
                            Image(systemName: "chevron.right").font(.system(size: 14)).foregroundColor(AppTheme.textSecondary.opacity(0.5))
                        }
                    }.foregroundColor(AppTheme.primaryGreen)
                }
                Section("Date & Time") { DatePicker("Date", selection: $date) }
                Section("Location (Optional)") {
                    TextField("e.g., Main Street, Central Park", text: $location)
                    if !dataManager.projects.isEmpty {
                        Picker("Link to Project", selection: $projectName) {
                            Text("None").tag(""); ForEach(dataManager.projects) { Text($0.name).tag($0.name) }
                        }
                    }
                }
                Section("Notes (Optional)") { TextField("Add any observations...", text: $notes, axis: .vertical).lineLimit(4...8) }
            }
            .navigationTitle("Log Activity").navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) { Button("Cancel") { dismiss() }.foregroundColor(AppTheme.textSecondary) }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") { saveEntry() }.font(.system(size: 16, weight: .semibold))
                        .foregroundColor(isValid ? AppTheme.primaryGreen : AppTheme.textSecondary).disabled(!isValid)
                }
            }
            .sheet(isPresented: $showPlantPicker) { CatalogPlantPicker(selectedPlant: $selectedPlantFromCatalog, plantName: $plantName) }
        }
    }
    
    private func saveEntry() {
        let entry = JournalEntry(date: date, activityType: activityType, plantName: plantName.trimmingCharacters(in: .whitespaces),
            projectName: projectName.isEmpty ? nil : projectName, notes: notes.trimmingCharacters(in: .whitespaces), location: location.trimmingCharacters(in: .whitespaces))
        dataManager.addJournalEntry(entry); dismiss()
    }
}

struct ActivityTypeButton: View {
    let activity: CareActivity; let isSelected: Bool; let action: () -> Void
    var body: some View {
        Button(action: action) {
            VStack(spacing: 6) { Text(activity.icon).font(.system(size: 24)); Text(activity.rawValue).font(.system(size: 10, weight: .medium)).lineLimit(1).minimumScaleFactor(0.8) }
                .foregroundColor(isSelected ? .white : AppTheme.textPrimary)
                .frame(maxWidth: .infinity).padding(.vertical, 12)
                .background(isSelected ? AppTheme.primaryGreen : Color.gray.opacity(0.1)).cornerRadius(12)
        }
    }
}

struct CatalogPlantPicker: View {
    @Binding var selectedPlant: Plant?; @Binding var plantName: String
    @EnvironmentObject var dataManager: DataManager; @Environment(\.dismiss) var dismiss; @State private var searchText = ""
    
    var filteredPlants: [Plant] { searchText.isEmpty ? dataManager.plants : dataManager.plants.filter { $0.name.localizedCaseInsensitiveContains(searchText) } }
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(filteredPlants) { plant in
                    Button { selectedPlant = plant; plantName = plant.name; dismiss() } label: {
                        HStack {
                            Text(plant.icon).font(.system(size: 24))
                            VStack(alignment: .leading, spacing: 2) {
                                Text(plant.name).font(.system(size: 16, weight: .medium)).foregroundColor(AppTheme.textPrimary)
                                Text(plant.scientificName).font(.system(size: 13)).foregroundColor(AppTheme.textSecondary).italic()
                            }
                            Spacer()
                            if selectedPlant?.id == plant.id { Image(systemName: "checkmark").foregroundColor(AppTheme.primaryGreen) }
                        }
                    }
                }
            }
            .searchable(text: $searchText, prompt: "Search plants...")
            .navigationTitle("Select Plant").navigationBarTitleDisplayMode(.inline)
            .toolbar { ToolbarItem(placement: .navigationBarTrailing) { Button("Done") { dismiss() }.foregroundColor(AppTheme.primaryGreen) } }
        }
    }
}
