//
//  JournalEntry.swift
//  CityBotanyLab
//

import Foundation

struct JournalEntry: Identifiable, Codable {
    let id: UUID
    var date: Date
    var activityType: CareActivity
    var plantName: String
    var projectName: String?
    var notes: String
    var location: String
    
    init(
        id: UUID = UUID(),
        date: Date = Date(),
        activityType: CareActivity,
        plantName: String,
        projectName: String? = nil,
        notes: String = "",
        location: String = ""
    ) {
        self.id = id
        self.date = date
        self.activityType = activityType
        self.plantName = plantName
        self.projectName = projectName
        self.notes = notes
        self.location = location
    }
}

enum CareActivity: String, Codable, CaseIterable {
    case watering = "Watering"
    case pruning = "Pruning"
    case fertilizing = "Fertilizing"
    case pestControl = "Pest Control"
    case planting = "Planting"
    case transplanting = "Transplanting"
    case mulching = "Mulching"
    case inspection = "Inspection"
    case soilTesting = "Soil Testing"
    case generalMaintenance = "General Maintenance"
    
    var icon: String {
        switch self {
        case .watering: return "рџ’§"
        case .pruning: return "вњ‚пёЏ"
        case .fertilizing: return "рџ§Є"
        case .pestControl: return "рџђ›"
        case .planting: return "рџЊ±"
        case .transplanting: return "рџ”„"
        case .mulching: return "рџЌ‚"
        case .inspection: return "рџ”Ќ"
        case .soilTesting: return "рџ§«"
        case .generalMaintenance: return "рџ› пёЏ"
        }
    }
}
