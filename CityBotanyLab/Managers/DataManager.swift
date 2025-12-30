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
    
    // MARK: - Data Persistence
    
    private func loadData() {
        // Load projects
        if let data = UserDefaults.standard.data(forKey: projectsKey),
           let decoded = try? JSONDecoder().decode([Project].self, from: data) {
            projects = decoded
        }
        
        // Load journal entries
        if let data = UserDefaults.standard.data(forKey: journalKey),
           let decoded = try? JSONDecoder().decode([JournalEntry].self, from: data) {
            journalEntries = decoded
        }
        
        // Load favorites
        if let data = UserDefaults.standard.data(forKey: favoritesKey),
           let decoded = try? JSONDecoder().decode([UUID].self, from: data) {
            favoritePlantIds = Set(decoded)
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
        if let encoded = try? JSONEncoder().encode(Array(favoritePlantIds)) {
            UserDefaults.standard.set(encoded, forKey: favoritesKey)
        }
    }
    
    // MARK: - Projects CRUD
    
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
    
    // MARK: - Journal CRUD
    
    func addJournalEntry(_ entry: JournalEntry) {
        journalEntries.append(entry)
        journalEntries.sort { $0.date > $1.date }
        saveJournalEntries()
    }
    
    func deleteJournalEntry(_ entry: JournalEntry) {
        journalEntries.removeAll { $0.id == entry.id }
        saveJournalEntries()
    }
    
    // MARK: - Favorites
    
    func isFavorite(_ plant: Plant) -> Bool {
        favoritePlantIds.contains(plant.id)
    }
    
    func toggleFavorite(_ plant: Plant) {
        if favoritePlantIds.contains(plant.id) {
            favoritePlantIds.remove(plant.id)
        } else {
            favoritePlantIds.insert(plant.id)
        }
        saveFavorites()
    }
}