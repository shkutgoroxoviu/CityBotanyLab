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
    @State private var area: Double = 100
    @State private var targetDate = Date().addingTimeInterval(86400 * 30)
    @State private var notes = ""
    
    var isValid: Bool {
        !name.trimmingCharacters(in: .whitespaces).isEmpty
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Project Details") {
                    TextField("Project Name", text: $name)
                    
                    TextField("Description", text: $projectDescription, axis: .vertical)
                        .lineLimit(3...6)
                }
                
                Section("Location") {
                    Picker("Location Type", selection: $locationType) {
                        ForEach(UrbanLocation.allCases, id: \.self) { location in
                            Text(location.rawValue).tag(location)
                        }
                    }
                    
                    HStack {
                        Text("Area")
                        Spacer()
                        TextField("Area", value: $area, format: .number)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                            .frame(width: 100)
                        Text("sqm")
                            .foregroundColor(AppTheme.textSecondary)
                    }
                }
                
                Section("Timeline") {
                    DatePicker("Target Completion", selection: $targetDate, displayedComponents: .date)
                }
                
                Section("Notes") {
                    TextField("Additional notes...", text: $notes, axis: .vertical)
                        .lineLimit(3...6)
                }
            }
            .navigationTitle("New Project")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Create") {
                        createProject()
                    }
                    .disabled(!isValid)
                }
            }
        }
    }
    
    private func createProject() {
        let project = Project(
            name: name.trimmingCharacters(in: .whitespaces),
            projectDescription: projectDescription,
            locationType: locationType,
            area: area,
            plants: [],
            targetCompletionDate: targetDate,
            status: .planning,
            notes: notes
        )
        
        dataManager.addProject(project)
        dismiss()
    }
}

#Preview {
    AddProjectView()
        .environmentObject(DataManager())
}