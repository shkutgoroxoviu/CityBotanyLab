//
//  JournalView.swift
//  CityBotanyLab
//

import SwiftUI

struct JournalView: View {
    @EnvironmentObject var dataManager: DataManager
    @State private var showingAddEntry = false
    @State private var selectedEntry: JournalEntry?
    @State private var filterActivity: CareActivity?
    
    var groupedEntries: [(String, [JournalEntry])] {
        let entries = filterActivity == nil ? dataManager.sortedJournalEntries : dataManager.sortedJournalEntries.filter { $0.activityType == filterActivity }
        let grouped = Dictionary(grouping: entries) { formatDateGroup($0.date) }
        return grouped.sorted { $0.key > $1.key }
    }
    
    private func formatDateGroup(_ date: Date) -> String {
        let calendar = Calendar.current
        if calendar.isDateInToday(date) { return "Today" }
        else if calendar.isDateInYesterday(date) { return "Yesterday" }
        else { let formatter = DateFormatter(); formatter.dateFormat = "MMMM d, yyyy"; return formatter.string(from: date) }
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                AppTheme.background.ignoresSafeArea()
                if dataManager.journalEntries.isEmpty {
                    EmptyJournalView { showingAddEntry = true }
                } else {
                    VStack(spacing: 0) {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 8) {
                                ActivityFilterChip(title: "All", icon: "рџ“‹", isSelected: filterActivity == nil) { filterActivity = nil }
                                ForEach(CareActivity.allCases, id: \.self) { activity in
                                    ActivityFilterChip(title: activity.rawValue, icon: activity.icon, isSelected: filterActivity == activity) {
                                        filterActivity = filterActivity == activity ? nil : activity
                                    }
                                }
                            }.padding(.horizontal, 16)
                        }.padding(.vertical, 12)
                        
                        ScrollView {
                            LazyVStack(spacing: 20, pinnedViews: [.sectionHeaders]) {
                                ForEach(groupedEntries, id: \.0) { group, entries in
                                    Section {
                                        VStack(spacing: 10) {
                                            ForEach(entries) { entry in JournalEntryCard(entry: entry).onTapGesture { selectedEntry = entry } }
                                        }
                                    } header: {
                                        HStack { Text(group).font(.system(size: 14, weight: .semibold)).foregroundColor(AppTheme.textSecondary); Spacer() }
                                            .padding(.horizontal, 16).padding(.vertical, 8).background(AppTheme.background)
                                    }
                                }
                            }.padding(.horizontal, 16).padding(.bottom, 20)
                        }
                    }
                }
            }
            .navigationTitle("Care Journal")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button { showingAddEntry = true } label: { Image(systemName: "plus.circle.fill").font(.system(size: 24)).foregroundColor(AppTheme.primaryGreen) }
                }
            }
            .sheet(isPresented: $showingAddEntry) { AddJournalEntryView() }
            .sheet(item: $selectedEntry) { entry in JournalEntryDetailView(entry: entry) }
        }
    }
}

struct EmptyJournalView: View {
    let onAdd: () -> Void
    var body: some View {
        VStack(spacing: 24) {
            ZStack { Circle().fill(AppTheme.softPink).frame(width: 120, height: 120); Text("рџ“ќ").font(.system(size: 50)) }
            VStack(spacing: 8) {
                Text("No Journal Entries").font(.system(size: 22, weight: .bold)).foregroundColor(AppTheme.textPrimary)
                Text("Start tracking your plant care activities").font(.system(size: 15)).foregroundColor(AppTheme.textSecondary).multilineTextAlignment(.center)
            }
            Button { onAdd() } label: {
                HStack { Image(systemName: "plus"); Text("Add Entry") }
                    .font(.system(size: 16, weight: .semibold)).foregroundColor(.white)
                    .padding(.horizontal, 32).padding(.vertical, 14).background(AppTheme.accentGradient).cornerRadius(14)
            }
        }.padding(40)
    }
}

struct ActivityFilterChip: View {
    let title: String; let icon: String; let isSelected: Bool; let action: () -> Void
    var body: some View {
        Button(action: action) {
            HStack(spacing: 4) { Text(icon).font(.system(size: 12)); if isSelected { Text(title).font(.system(size: 13, weight: .medium)) } }
                .foregroundColor(isSelected ? .white : AppTheme.textPrimary)
                .padding(.horizontal, isSelected ? 12 : 10).padding(.vertical, 8)
                .background(isSelected ? AppTheme.accentPink : Color.white)
                .cornerRadius(16).shadow(color: AppTheme.darkGreen.opacity(0.05), radius: 3, x: 0, y: 2)
        }
    }
}

struct JournalEntryCard: View {
    let entry: JournalEntry
    var body: some View {
        HStack(spacing: 14) {
            ZStack { Circle().fill(activityColor.opacity(0.15)).frame(width: 50, height: 50); Text(entry.activityType.icon).font(.system(size: 22)) }
            VStack(alignment: .leading, spacing: 4) {
                HStack { Text(entry.activityType.rawValue).font(.system(size: 16, weight: .semibold)).foregroundColor(AppTheme.textPrimary); Spacer(); Text(entry.date, style: .time).font(.system(size: 12)).foregroundColor(AppTheme.textSecondary.opacity(0.7)) }
                Text(entry.plantName).font(.system(size: 14)).foregroundColor(AppTheme.primaryGreen)
                if !entry.notes.isEmpty { Text(entry.notes).font(.system(size: 13)).foregroundColor(AppTheme.textSecondary).lineLimit(1) }
                if !entry.location.isEmpty { HStack(spacing: 4) { Image(systemName: "mappin").font(.system(size: 10)); Text(entry.location).font(.system(size: 12)) }.foregroundColor(AppTheme.textSecondary.opacity(0.7)) }
            }
            Image(systemName: "chevron.right").font(.system(size: 14, weight: .medium)).foregroundColor(AppTheme.textSecondary.opacity(0.3))
        }.padding(14).cardStyle()
    }
    
    private var activityColor: Color {
        switch entry.activityType {
        case .watering: return .blue; case .pruning: return .orange; case .fertilizing: return .purple; case .pestControl: return .red
        case .planting: return AppTheme.primaryGreen; case .transplanting: return .teal; case .mulching: return .brown
        case .inspection: return .indigo; case .soilTesting: return .cyan; case .generalMaintenance: return AppTheme.textSecondary
        }
    }
}
