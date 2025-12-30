//
//  Project.swift
//  CityBotanyLab
//

import Foundation

struct Project: Identifiable, Codable {
    let id: UUID
    var name: String
    var projectDescription: String
    var locationType: UrbanLocation
    var area: Double
    var plants: [ProjectPlant]
    var createdDate: Date
    var targetCompletionDate: Date?
    var status: ProjectStatus
    var notes: String
    
    init(
        id: UUID = UUID(),
        name: String,
        projectDescription: String = "",
        locationType: UrbanLocation = .park,
        area: Double = 0,
        plants: [ProjectPlant] = [],
        createdDate: Date = Date(),
        targetCompletionDate: Date? = nil,
        status: ProjectStatus = .planning,
        notes: String = ""
    ) {
        self.id = id
        self.name = name
        self.projectDescription = projectDescription
        self.locationType = locationType
        self.area = area
        self.plants = plants
        self.createdDate = createdDate
        self.targetCompletionDate = targetCompletionDate
        self.status = status
        self.notes = notes
    }
}

struct ProjectPlant: Identifiable, Codable {
    let id: UUID
    let plantId: UUID
    let plantName: String
    var quantity: Int
    var isPlanted: Bool
    var plantedDate: Date?
    
    init(
        id: UUID = UUID(),
        plantId: UUID,
        plantName: String,
        quantity: Int = 1,
        isPlanted: Bool = false,
        plantedDate: Date? = nil
    ) {
        self.id = id
        self.plantId = plantId
        self.plantName = plantName
        self.quantity = quantity
        self.isPlanted = isPlanted
        self.plantedDate = plantedDate
    }
}

enum ProjectStatus: String, Codable, CaseIterable {
    case planning = "Planning"
    case inProgress = "In Progress"
    case completed = "Completed"
    case onHold = "On Hold"
    
    var icon: String {
        switch self {
        case .planning: return "рџ“‹"
        case .inProgress: return "рџ”§"
        case .completed: return "вњ…"
        case .onHold: return "вЏёпёЏ"
        }
    }
}
