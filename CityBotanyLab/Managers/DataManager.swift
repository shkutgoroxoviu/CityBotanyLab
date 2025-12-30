//
//  DataManager.swift
//  CityBotanyLab
//

import Foundation
import SwiftUI

class DataManager: ObservableObject {
    @Published var projects: [Project] = []
    @Published var journalEntries: [JournalEntry] = []
    @Published var favoritePlantIds: Set<UUID> = []
    
    private let projectsKey = "savedProjects"
    private let journalKey = "savedJournalEntries"
    private let favoritesKey = "favoritePlantIds"
    
    let plants: [Plant] = PlantDatabase.allPlants
    
    init() {
        loadData()
    }
    
    private func loadData() {
        loadProjects()
        loadJournalEntries()
        loadFavorites()
    }
    
    private func loadProjects() {
        if let data = UserDefaults.standard.data(forKey: projectsKey),
           let decoded = try? JSONDecoder().decode([Project].self, from: data) {
            projects = decoded
        }
    }
    
    private func loadJournalEntries() {
        if let data = UserDefaults.standard.data(forKey: journalKey),
           let decoded = try? JSONDecoder().decode([JournalEntry].self, from: data) {
            journalEntries = decoded
        }
    }
    
    private func loadFavorites() {
        if let data = UserDefaults.standard.data(forKey: favoritesKey),
           let decoded = try? JSONDecoder().decode(Set<UUID>.self, from: data) {
            favoritePlantIds = decoded
        }
    }
    
    private func saveProjects() {
        if let encoded = try? JSONEncoder().encode(projects) {
            UserDefaults.standard.set(encoded, forKey: projectsKey)
        }
    }
    
    private func saveJournalEntries() {
        if let encoded = try? JSONEncoder().encode(journalEntries) {
            UserDefaults.standard.set(encoded, forKey: journalKey)
        }
    }
    
    private func saveFavorites() {
        if let encoded = try? JSONEncoder().encode(favoritePlantIds) {
            UserDefaults.standard.set(encoded, forKey: favoritesKey)
        }
    }
    
    func addProject(_ project: Project) {
        projects.append(project)
        saveProjects()
    }
    
    func updateProject(_ project: Project) {
        if let index = projects.firstIndex(where: { $0.id == project.id }) {
            projects[index] = project
            saveProjects()
        }
    }
    
    func deleteProject(_ project: Project) {
        projects.removeAll { $0.id == project.id }
        saveProjects()
    }
    
    func deleteProject(at offsets: IndexSet) {
        projects.remove(atOffsets: offsets)
        saveProjects()
    }
    
    func addJournalEntry(_ entry: JournalEntry) {
        journalEntries.insert(entry, at: 0)
        saveJournalEntries()
    }
    
    func updateJournalEntry(_ entry: JournalEntry) {
        if let index = journalEntries.firstIndex(where: { $0.id == entry.id }) {
            journalEntries[index] = entry
            saveJournalEntries()
        }
    }
    
    func deleteJournalEntry(_ entry: JournalEntry) {
        journalEntries.removeAll { $0.id == entry.id }
        saveJournalEntries()
    }
    
    func deleteJournalEntry(at offsets: IndexSet) {
        journalEntries.remove(atOffsets: offsets)
        saveJournalEntries()
    }
    
    func toggleFavorite(plantId: UUID) {
        if favoritePlantIds.contains(plantId) {
            favoritePlantIds.remove(plantId)
        } else {
            favoritePlantIds.insert(plantId)
        }
        saveFavorites()
    }
    
    func isFavorite(plantId: UUID) -> Bool {
        favoritePlantIds.contains(plantId)
    }
    
    var favoritePlants: [Plant] {
        plants.filter { favoritePlantIds.contains($0.id) }
    }
    
    func plant(for id: UUID) -> Plant? {
        plants.first { $0.id == id }
    }
    
    var sortedJournalEntries: [JournalEntry] {
        journalEntries.sorted { $0.date > $1.date }
    }
    
    var recentProjects: [Project] {
        Array(projects.sorted { $0.createdDate > $1.createdDate }.prefix(5))
    }
    
    var activeProjects: [Project] {
        projects.filter { $0.status == .inProgress || $0.status == .planning }
    }
}
