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
        projectDescription: String,
        locationType: UrbanLocation,
        area: Double,
        plants: [ProjectPlant],
        targetCompletionDate: Date?,
        status: ProjectStatus,
        notes: String
    ) {
        self.id = id
        self.name = name
        self.projectDescription = projectDescription
        self.locationType = locationType
        self.area = area
        self.plants = plants
        self.createdDate = Date()
        self.targetCompletionDate = targetCompletionDate
        self.status = status
        self.notes = notes
    }
}

struct ProjectPlant: Identifiable, Codable {
    let id: UUID
    let plantId: UUID
    var quantity: Int
    
    init(id: UUID = UUID(), plantId: UUID, quantity: Int) {
        self.id = id
        self.plantId = plantId
        self.quantity = quantity
    }
}

enum ProjectStatus: String, Codable, CaseIterable {
    case planning = "Planning"
    case inProgress = "In Progress"
    case completed = "Completed"
    case onHold = "On Hold"
}