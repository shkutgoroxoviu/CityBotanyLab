//
//  PlantDetailView.swift
//  CityBotanyLab
//

import SwiftUI

struct PlantDetailView: View {
    let plant: Plant
    @EnvironmentObject var dataManager: DataManager
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    // Header
                    VStack(spacing: 16) {
                        ZStack {
                            Circle()
                                .fill(
                                    LinearGradient(
                                        colors: [AppTheme.primaryGreen.opacity(0.2), AppTheme.accentPink.opacity(0.1)],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: 120, height: 120)
                            
                            Image(systemName: plant.icon)
                                .font(.system(size: 50))
                                .foregroundColor(AppTheme.primaryGreen)
                        }
                        
                        VStack(spacing: 4) {
                            Text(plant.name)
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(AppTheme.textPrimary)
                            
                            Text(plant.scientificName)
                                .font(.subheadline)
                                .foregroundColor(AppTheme.textSecondary)
                                .italic()
                        }
                        
                        Button(action: {
                            dataManager.toggleFavorite(plant)
                        }) {
                            HStack {
                                Image(systemName: dataManager.isFavorite(plant) ? "heart.fill" : "heart")
                                Text(dataManager.isFavorite(plant) ? "Remove from Favorites" : "Add to Favorites")
                            }
                            .accentButtonStyle()
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.top, 16)
                    
                    // Description
                    VStack(alignment: .leading, spacing: 8) {
                        Text("About")
                            .font(.headline)
                            .foregroundColor(AppTheme.textPrimary)
                        
                        Text(plant.description)
                            .font(.body)
                            .foregroundColor(AppTheme.textSecondary)
                            .lineSpacing(4)
                    }
                    .padding(.horizontal, 16)
                    
                    // Quick Info
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                        InfoCard(title: "Category", value: plant.category.rawValue, icon: plant.category.icon)
                        InfoCard(title: "Care Level", value: plant.careLevel.rawValue, icon: "leaf")
                        InfoCard(title: "Water Needs", value: plant.waterNeeds.rawValue, icon: "drop.fill")
                        InfoCard(title: "Sun", value: plant.sunRequirement.rawValue, icon: "sun.max.fill")
                        InfoCard(title: "Max Height", value: plant.maxHeight, icon: "arrow.up")
                        InfoCard(title: "Growth Rate", value: plant.growthRate.rawValue, icon: "chart.line.uptrend.xyaxis")
                    }
                    .padding(.horizontal, 16)
                    
                    // Urban Benefits
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Urban Benefits")
                            .font(.headline)
                            .foregroundColor(AppTheme.textPrimary)
                        
                        FlowLayout(spacing: 8) {
                            ForEach(plant.urbanBenefits, id: \.self) { benefit in
                                Text(benefit.rawValue)
                                    .tagStyle()
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                    
                    // Best Locations
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Best Locations")
                            .font(.headline)
                            .foregroundColor(AppTheme.textPrimary)
                        
                        FlowLayout(spacing: 8) {
                            ForEach(plant.bestLocations, id: \.self) { location in
                                HStack(spacing: 4) {
                                    Image(systemName: "mappin.circle.fill")
                                        .foregroundColor(AppTheme.accentPink)
                                    Text(location.rawValue)
                                }
                                .tagStyle()
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                    
                    // Planting Seasons
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Planting Seasons")
                            .font(.headline)
                            .foregroundColor(AppTheme.textPrimary)
                        
                        HStack(spacing: 12) {
                            ForEach(plant.plantingSeasons, id: \.self) { season in
                                HStack(spacing: 4) {
                                    Image(systemName: seasonIcon(for: season))
                                        .foregroundColor(AppTheme.primaryGreen)
                                    Text(season.rawValue)
                                }
                                .tagStyle()
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 32)
                }
            }
            .background(AppTheme.background)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
    
    func seasonIcon(for season: Season) -> String {
        switch season {
        case .spring: return "leaf"
        case .summer: return "sun.max.fill"
        case .autumn: return "leaf.fill"
        case .winter: return "snowflake"
        }
    }
}

struct InfoCard: View {
    let title: String
    let value: String
    let icon: String
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(AppTheme.primaryGreen)
            
            Text(title)
                .font(.caption)
                .foregroundColor(AppTheme.textSecondary)
            
            Text(value)
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(AppTheme.textPrimary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .cardStyle()
    }
}

struct FlowLayout: Layout {
    var spacing: CGFloat = 8
    
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let result = FlowResult(in: proposal.width ?? 0, subviews: subviews, spacing: spacing)
        return result.size
    }
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let result = FlowResult(in: bounds.width, subviews: subviews, spacing: spacing)
        for (index, subview) in subviews.enumerated() {
            subview.place(at: CGPoint(x: bounds.minX + result.positions[index].x,
                                      y: bounds.minY + result.positions[index].y),
                         proposal: .unspecified)
        }
    }
    
    struct FlowResult {
        var size: CGSize = .zero
        var positions: [CGPoint] = []
        
        init(in maxWidth: CGFloat, subviews: Subviews, spacing: CGFloat) {
            var currentX: CGFloat = 0
            var currentY: CGFloat = 0
            var lineHeight: CGFloat = 0
            
            for subview in subviews {
                let size = subview.sizeThatFits(.unspecified)
                
                if currentX + size.width > maxWidth && currentX > 0 {
                    currentX = 0
                    currentY += lineHeight + spacing
                    lineHeight = 0
                }
                
                positions.append(CGPoint(x: currentX, y: currentY))
                lineHeight = max(lineHeight, size.height)
                currentX += size.width + spacing
                self.size.width = max(self.size.width, currentX)
            }
            
            self.size.height = currentY + lineHeight
        }
    }
}

#Preview {
    PlantDetailView(plant: PlantDatabase.allPlants[0])
        .environmentObject(DataManager())
}