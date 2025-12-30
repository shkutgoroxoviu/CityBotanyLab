//
//  JournalView.swift
//  CityBotanyLab
//

import SwiftUI

struct JournalView: View {
    @EnvironmentObject var dataManager: DataManager
    @State private var showingAddEntry = false
    @State private var selectedEntry: JournalEntry?
    
    var groupedEntries: [(String, [JournalEntry])] {
        let grouped = Dictionary(grouping: dataManager.journalEntries) { entry in
            entry.date.formatted(date: .abbreviated, time: .omitted)
        }
        return grouped.sorted { $0.value[0].date > $1.value[0].date }
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                AppTheme.background
                    .ignoresSafeArea()
                
                if dataManager.journalEntries.isEmpty {
                    EmptyJournalView(showingAddEntry: $showingAddEntry)
                } else {
                    ScrollView {
                        LazyVStack(spacing: 24) {
                            ForEach(groupedEntries, id: \.0) { dateString, entries in
                                VStack(alignment: .leading, spacing: 12) {
                                    Text(dateString)
                                        .font(.headline)
                                        .foregroundColor(AppTheme.textPrimary)
                                        .padding(.horizontal, 16)
                                    
                                    ForEach(entries) { entry in
                                        JournalEntryCard(entry: entry)
                                            .onTapGesture {
                                                selectedEntry = entry
                                            }
                                    }
                                }
                            }
                        }
                        .padding(.vertical, 16)
                        .padding(.bottom, 100)
                    }
                }
            }
            .navigationTitle("Care Journal")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingAddEntry = true }) {
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(AppTheme.primaryGreen)
                    }
                }
            }
            .sheet(isPresented: $showingAddEntry) {
                AddJournalEntryView()
            }
            .sheet(item: $selectedEntry) { entry in
                JournalEntryDetailView(entry: entry)
            }
        }
    }
}

struct EmptyJournalView: View {
    @Binding var showingAddEntry: Bool
    
    var body: some View {
        VStack(spacing: 24) {
            Image(systemName: "book.closed")
                .font(.system(size: 60))
                .foregroundColor(AppTheme.textSecondary.opacity(0.5))
            
            VStack(spacing: 8) {
                Text("No Journal Entries")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(AppTheme.textPrimary)
                
                Text("Start documenting your plant care\nactivities and observations")
                    .font(.body)
                    .foregroundColor(AppTheme.textSecondary)
                    .multilineTextAlignment(.center)
            }
            
            Button(action: { showingAddEntry = true }) {
                HStack {
                    Image(systemName: "plus")
                    Text("Add Entry")
                }
                .primaryButtonStyle()
            }
        }
        .padding(32)
    }
}

struct JournalEntryCard: View {
    let entry: JournalEntry
    
    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(entry.activityType.color.opacity(0.15))
                    .frame(width: 50, height: 50)
                
                Image(systemName: entry.activityType.icon)
                    .font(.title3)
                    .foregroundColor(entry.activityType.color)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(entry.activityType.rawValue)
                    .font(.headline)
                    .foregroundColor(AppTheme.textPrimary)
                
                Text(entry.plantName)
                    .font(.subheadline)
                    .foregroundColor(AppTheme.textSecondary)
                
                if !entry.location.isEmpty {
                    Label(entry.location, systemImage: "mappin")
                        .font(.caption)
                        .foregroundColor(AppTheme.textSecondary)
                }
            }
            
            Spacer()
            
            Text(entry.date.formatted(date: .omitted, time: .shortened))
                .font(.caption)
                .foregroundColor(AppTheme.textSecondary)
        }
        .padding(16)
        .cardStyle()
        .padding(.horizontal, 16)
    }
}

#Preview {
    JournalView()
        .environmentObject(DataManager())
}