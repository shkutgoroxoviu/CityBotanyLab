//
//  JournalEntry.swift
//  CityBotanyLab
//

import Foundation
import SwiftUI

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
        projectName: String?,
        notes: String,
        location: String
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
    case planting = "Planting"
    case inspection = "Inspection"
    case pestControl = "Pest Control"
    case mulching = "Mulching"
    case transplanting = "Transplanting"
    case other = "Other"
    
    var icon: String {
        switch self {
        case .watering: return "drop.fill"
        case .pruning: return "scissors"
        case .fertilizing: return "leaf.arrow.triangle.circlepath"
        case .planting: return "leaf.fill"
        case .inspection: return "eye.fill"
        case .pestControl: return "ladybug.fill"
        case .mulching: return "square.stack.3d.up.fill"
        case .transplanting: return "arrow.left.arrow.right"
        case .other: return "ellipsis.circle.fill"
        }
    }
    
    var color: Color {
        switch self {
        case .watering: return .blue
        case .pruning: return .orange
        case .fertilizing: return .green
        case .planting: return Color(red: 0.18, green: 0.55, blue: 0.34)
        case .inspection: return .purple
        case .pestControl: return .red
        case .mulching: return .brown
        case .transplanting: return .teal
        case .other: return .gray
        }
    }
}