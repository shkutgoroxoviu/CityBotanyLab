//
//  JournalEntryDetailView.swift
//  CityBotanyLab
//

import SwiftUI

struct JournalEntryDetailView: View {
    @EnvironmentObject var dataManager: DataManager
    @Environment(\.dismiss) var dismiss
    let entry: JournalEntry
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    // Header
                    VStack(spacing: 16) {
                        ZStack {
                            Circle()
                                .fill(entry.activityType.color.opacity(0.15))
                                .frame(width: 80, height: 80)
                            
                            Image(systemName: entry.activityType.icon)
                                .font(.system(size: 35))
                                .foregroundColor(entry.activityType.color)
                        }
                        
                        VStack(spacing: 4) {
                            Text(entry.activityType.rawValue)
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(AppTheme.textPrimary)
                            
                            Text(entry.date.formatted(date: .abbreviated, time: .shortened))
                                .font(.subheadline)
                                .foregroundColor(AppTheme.textSecondary)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.top, 16)
                    
                    // Details
                    VStack(spacing: 16) {
                        DetailRow(icon: "leaf", title: "Plant", value: entry.plantName)
                        
                        if let projectName = entry.projectName, !projectName.isEmpty {
                            DetailRow(icon: "folder", title: "Project", value: projectName)
                        }
                        
                        if !entry.location.isEmpty {
                            DetailRow(icon: "mappin", title: "Location", value: entry.location)
                        }
                    }
                    .padding(16)
                    .cardStyle()
                    .padding(.horizontal, 16)
                    
                    // Notes
                    if !entry.notes.isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Notes")
                                .font(.headline)
                                .foregroundColor(AppTheme.textPrimary)
                            
                            Text(entry.notes)
                                .font(.body)
                                .foregroundColor(AppTheme.textSecondary)
                                .lineSpacing(4)
                        }
                        .padding(.horizontal, 16)
                    }
                    
                    // Delete Button
                    Button(action: deleteEntry) {
                        HStack {
                            Image(systemName: "trash")
                            Text("Delete Entry")
                        }
                        .foregroundColor(.red)
                        .frame(maxWidth: .infinity)
                        .padding()
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 32)
                }
            }
            .background(AppTheme.background)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
    
    private func deleteEntry() {
        dataManager.deleteJournalEntry(entry)
        dismiss()
    }
}

struct DetailRow: View {
    let icon: String
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Label(title, systemImage: icon)
                .foregroundColor(AppTheme.textSecondary)
            
            Spacer()
            
            Text(value)
                .foregroundColor(AppTheme.textPrimary)
                .fontWeight(.medium)
        }
    }
}

#Preview {
    JournalEntryDetailView(entry: JournalEntry(
        date: Date(),
        activityType: .watering,
        plantName: "London Plane",
        projectName: "Park Project",
        notes: "Gave it a good watering after the dry spell",
        location: "Central Park"
    ))
    .environmentObject(DataManager())
}