//
//  Plant.swift
//  CityBotanyLab
//

import Foundation

struct Plant: Identifiable, Codable, Hashable {
    let id: UUID
    let name: String
    let scientificName: String
    let category: PlantCategory
    let description: String
    let careLevel: CareLevel
    let waterNeeds: WaterNeeds
    let sunRequirement: SunRequirement
    let maxHeight: String
    let growthRate: GrowthRate
    let urbanBenefits: [UrbanBenefit]
    let bestLocations: [UrbanLocation]
    let plantingSeasons: [Season]
    let icon: String
    
    init(
        id: UUID = UUID(),
        name: String,
        scientificName: String,
        category: PlantCategory,
        description: String,
        careLevel: CareLevel,
        waterNeeds: WaterNeeds,
        sunRequirement: SunRequirement,
        maxHeight: String,
        growthRate: GrowthRate,
        urbanBenefits: [UrbanBenefit],
        bestLocations: [UrbanLocation],
        plantingSeasons: [Season],
        icon: String
    ) {
        self.id = id
        self.name = name
        self.scientificName = scientificName
        self.category = category
        self.description = description
        self.careLevel = careLevel
        self.waterNeeds = waterNeeds
        self.sunRequirement = sunRequirement
        self.maxHeight = maxHeight
        self.growthRate = growthRate
        self.urbanBenefits = urbanBenefits
        self.bestLocations = bestLocations
        self.plantingSeasons = plantingSeasons
        self.icon = icon
    }
}

enum PlantCategory: String, Codable, CaseIterable {
    case tree = "Tree"
    case shrub = "Shrub"
    case grass = "Grass"
    case flower = "Flower"
    case vine = "Vine"
    case groundCover = "Ground Cover"
    
    var icon: String {
        switch self {
        case .tree: return "tree"
        case .shrub: return "leaf"
        case .grass: return "wind"
        case .flower: return "camera.macro"
        case .vine: return "arrow.up.right"
        case .groundCover: return "leaf.fill"
        }
    }
}

enum CareLevel: String, Codable, CaseIterable {
    case low = "Low"
    case medium = "Medium"
    case high = "High"
}

enum WaterNeeds: String, Codable, CaseIterable {
    case low = "Low"
    case moderate = "Moderate"
    case high = "High"
    case veryHigh = "Very High"
}

enum SunRequirement: String, Codable, CaseIterable {
    case fullSun = "Full Sun"
    case partialShade = "Partial Shade"
    case fullShade = "Full Shade"
    case adaptable = "Adaptable"
}

enum GrowthRate: String, Codable, CaseIterable {
    case slow = "Slow"
    case moderate = "Moderate"
    case fast = "Fast"
}

enum UrbanBenefit: String, Codable, CaseIterable {
    case airPurification = "Air Purification"
    case noiseReduction = "Noise Reduction"
    case shadeCooling = "Shade & Cooling"
    case wildlifeHabitat = "Wildlife Habitat"
    case aesthetics = "Aesthetics"
    case erosionControl = "Erosion Control"
    case stormwaterManagement = "Stormwater Management"
}

enum UrbanLocation: String, Codable, CaseIterable {
    case streetside = "Streetside"
    case park = "Park"
    case plaza = "Plaza"
    case rooftop = "Rooftop"
    case verticalGarden = "Vertical Garden"
    case bikePath = "Bike Path"
    case highway = "Highway Buffer"
    case residential = "Residential Area"
}

enum Season: String, Codable, CaseIterable {
    case spring = "Spring"
    case summer = "Summer"
    case autumn = "Autumn"
    case winter = "Winter"
}