//
//  AddJournalEntryView.swift
//  CityBotanyLab
//

import SwiftUI

struct AddJournalEntryView: View {
    @EnvironmentObject var dataManager: DataManager
    @Environment(\.dismiss) var dismiss
    
    @State private var activityType: CareActivity = .watering
    @State private var plantName = ""
    @State private var projectName = ""
    @State private var location = ""
    @State private var notes = ""
    @State private var date = Date()
    
    var isValid: Bool {
        !plantName.trimmingCharacters(in: .whitespaces).isEmpty
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Activity") {
                    Picker("Activity Type", selection: $activityType) {
                        ForEach(CareActivity.allCases, id: \.self) { activity in
                            Label(activity.rawValue, systemImage: activity.icon)
                                .tag(activity)
                        }
                    }
                    
                    DatePicker("Date & Time", selection: $date)
                }
                
                Section("Plant") {
                    TextField("Plant Name", text: $plantName)
                    
                    Picker("Project (Optional)", selection: $projectName) {
                        Text("None").tag("")
                        ForEach(dataManager.projects) { project in
                            Text(project.name).tag(project.name)
                        }
                    }
                }
                
                Section("Location") {
                    TextField("Location", text: $location)
                }
                
                Section("Notes") {
                    TextField("Notes...", text: $notes, axis: .vertical)
                        .lineLimit(3...6)
                }
            }
            .navigationTitle("New Entry")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveEntry()
                    }
                    .disabled(!isValid)
                }
            }
        }
    }
    
    private func saveEntry() {
        let entry = JournalEntry(
            date: date,
            activityType: activityType,
            plantName: plantName.trimmingCharacters(in: .whitespaces),
            projectName: projectName.isEmpty ? nil : projectName,
            notes: notes,
            location: location
        )
        
        dataManager.addJournalEntry(entry)
        dismiss()
    }
}

#Preview {
    AddJournalEntryView()
        .environmentObject(DataManager())
}