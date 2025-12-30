//
//  JournalEntryDetailView.swift
//  CityBotanyLab
//

import SwiftUI

struct JournalEntryDetailView: View {
    @State var entry: JournalEntry
    @EnvironmentObject var dataManager: DataManager
    @Environment(\.dismiss) var dismiss
    @State private var showingEditSheet = false
    @State private var showingDeleteAlert = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    VStack(spacing: 16) {
                        ZStack { Circle().fill(activityColor.opacity(0.15)).frame(width: 100, height: 100); Text(entry.activityType.icon).font(.system(size: 50)) }
                        Text(entry.activityType.rawValue).font(.system(size: 24, weight: .bold)).foregroundColor(AppTheme.textPrimary)
                        Text(entry.date.formatted(date: .complete, time: .shortened)).font(.system(size: 15)).foregroundColor(AppTheme.textSecondary)
                    }.padding(.top, 20)
                    
                    VStack(alignment: .leading, spacing: 12) {
                        HStack { Image(systemName: "leaf.fill").foregroundColor(AppTheme.primaryGreen); Text("Plant").font(.system(size: 16, weight: .bold)).foregroundColor(AppTheme.textPrimary) }
                        Text(entry.plantName).font(.system(size: 18, weight: .medium)).foregroundColor(AppTheme.primaryGreen).padding(.leading, 28)
                    }.frame(maxWidth: .infinity, alignment: .leading).padding(20).cardStyle().padding(.horizontal, 16)
                    
                    if !entry.location.isEmpty || entry.projectName != nil {
                        VStack(alignment: .leading, spacing: 12) {
                            HStack { Image(systemName: "mappin.circle.fill").foregroundColor(.orange); Text("Location").font(.system(size: 16, weight: .bold)).foregroundColor(AppTheme.textPrimary) }
                            VStack(alignment: .leading, spacing: 8) {
                                if !entry.location.isEmpty { Text(entry.location).font(.system(size: 16)).foregroundColor(AppTheme.textPrimary).padding(.leading, 28) }
                                if let projectName = entry.projectName {
                                    HStack { Text("Project:").font(.system(size: 14)).foregroundColor(AppTheme.textSecondary); Text(projectName).font(.system(size: 14, weight: .medium)).foregroundColor(AppTheme.accentPink) }.padding(.leading, 28)
                                }
                            }
                        }.frame(maxWidth: .infinity, alignment: .leading).padding(20).cardStyle().padding(.horizontal, 16)
                    }
                    
                    if !entry.notes.isEmpty {
                        VStack(alignment: .leading, spacing: 12) {
                            HStack { Image(systemName: "note.text").foregroundColor(.blue); Text("Notes").font(.system(size: 16, weight: .bold)).foregroundColor(AppTheme.textPrimary) }
                            Text(entry.notes).font(.system(size: 15)).foregroundColor(AppTheme.textSecondary).lineSpacing(4).padding(.leading, 28)
                        }.frame(maxWidth: .infinity, alignment: .leading).padding(20).cardStyle().padding(.horizontal, 16)
                    }
                    
                    Button { showingDeleteAlert = true } label: {
                        HStack { Image(systemName: "trash"); Text("Delete Entry") }
                            .font(.system(size: 16, weight: .medium)).foregroundColor(.red)
                            .frame(maxWidth: .infinity).padding(.vertical, 14).background(Color.red.opacity(0.1)).cornerRadius(12)
                    }.padding(.horizontal, 16).padding(.bottom, 30)
                }
            }
            .background(AppTheme.background).navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) { Button { dismiss() } label: { Image(systemName: "xmark.circle.fill").font(.system(size: 24)).foregroundColor(AppTheme.textSecondary.opacity(0.5)) } }
                ToolbarItem(placement: .navigationBarTrailing) { Button { showingEditSheet = true } label: { Text("Edit").font(.system(size: 16, weight: .medium)).foregroundColor(AppTheme.primaryGreen) } }
            }
            .alert("Delete Entry?", isPresented: $showingDeleteAlert) {
                Button("Cancel", role: .cancel) {}; Button("Delete", role: .destructive) { dataManager.deleteJournalEntry(entry); dismiss() }
            } message: { Text("This action cannot be undone.") }
            .sheet(isPresented: $showingEditSheet) { EditJournalEntryView(entry: $entry) }
        }
    }
    
    private var activityColor: Color {
        switch entry.activityType {
        case .watering: return .blue; case .pruning: return .orange; case .fertilizing: return .purple; case .pestControl: return .red
        case .planting: return AppTheme.primaryGreen; case .transplanting: return .teal; case .mulching: return .brown
        case .inspection: return .indigo; case .soilTesting: return .cyan; case .generalMaintenance: return AppTheme.textSecondary
        }
    }
}

struct EditJournalEntryView: View {
    @Binding var entry: JournalEntry; @EnvironmentObject var dataManager: DataManager; @Environment(\.dismiss) var dismiss
    @State private var date = Date(); @State private var activityType: CareActivity = .watering; @State private var plantName = ""; @State private var notes = ""; @State private var location = ""
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Activity Type") { Picker("Activity", selection: $activityType) { ForEach(CareActivity.allCases, id: \.self) { HStack { Text($0.icon); Text($0.rawValue) }.tag($0) } } }
                Section("Plant") { TextField("Plant Name", text: $plantName) }
                Section("Date & Time") { DatePicker("Date", selection: $date) }
                Section("Location") { TextField("Location", text: $location) }
                Section("Notes") { TextField("Notes...", text: $notes, axis: .vertical).lineLimit(4...8) }
            }
            .onAppear { date = entry.date; activityType = entry.activityType; plantName = entry.plantName; notes = entry.notes; location = entry.location }
            .navigationTitle("Edit Entry").navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) { Button("Cancel") { dismiss() } }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") { entry.date = date; entry.activityType = activityType; entry.plantName = plantName; entry.notes = notes; entry.location = location; dataManager.updateJournalEntry(entry); dismiss() }
                        .font(.system(size: 16, weight: .semibold)).foregroundColor(AppTheme.primaryGreen)
                }
            }
        }
    }
}
