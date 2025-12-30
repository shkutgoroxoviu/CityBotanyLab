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
                VStack(spacing: 24) {
                    VStack(spacing: 16) {
                        ZStack { Circle().fill(AppTheme.softGradient).frame(width: 140, height: 140); Text(plant.icon).font(.system(size: 70)) }.padding(.top, 20)
                        VStack(spacing: 6) {
                            Text(plant.name).font(.system(size: 26, weight: .bold)).foregroundColor(AppTheme.textPrimary)
                            Text(plant.scientificName).font(.system(size: 16)).foregroundColor(AppTheme.textSecondary).italic()
                        }
                        HStack(spacing: 10) {
                            HStack(spacing: 4) { Text(plant.category.icon); Text(plant.category.rawValue) }.tagStyle(color: AppTheme.primaryGreen)
                            Text(plant.careLevel.rawValue + " Care").tagStyle(color: careLevelColor)
                        }
                    }.padding(.horizontal, 20)
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text("About").font(.system(size: 18, weight: .bold)).foregroundColor(AppTheme.textPrimary)
                        Text(plant.description).font(.system(size: 15)).foregroundColor(AppTheme.textSecondary).lineSpacing(4)
                    }.frame(maxWidth: .infinity, alignment: .leading).padding(20).cardStyle().padding(.horizontal, 16)
                    
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Quick Info").font(.system(size: 18, weight: .bold)).foregroundColor(AppTheme.textPrimary)
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                            InfoTile(icon: "drop.fill", title: "Water", value: plant.waterNeeds.rawValue, color: .blue)
                            InfoTile(icon: "sun.max.fill", title: "Sun", value: plant.sunRequirement.rawValue, color: .orange)
                            InfoTile(icon: "arrow.up.to.line", title: "Max Height", value: plant.maxHeight, color: AppTheme.primaryGreen)
                            InfoTile(icon: "chart.line.uptrend.xyaxis", title: "Growth", value: plant.growthRate.rawValue, color: AppTheme.accentPink)
                        }
                    }.padding(20).cardStyle().padding(.horizontal, 16)
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Urban Benefits").font(.system(size: 18, weight: .bold)).foregroundColor(AppTheme.textPrimary)
                        FlowLayout(spacing: 8) {
                            ForEach(plant.urbanBenefits, id: \.self) { benefit in
                                Text(benefit.rawValue).font(.system(size: 13, weight: .medium)).foregroundColor(AppTheme.primaryGreen)
                                    .padding(.horizontal, 12).padding(.vertical, 8).background(AppTheme.paleGreen).cornerRadius(12)
                            }
                        }
                    }.frame(maxWidth: .infinity, alignment: .leading).padding(20).cardStyle().padding(.horizontal, 16)
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Best Locations").font(.system(size: 18, weight: .bold)).foregroundColor(AppTheme.textPrimary)
                        FlowLayout(spacing: 8) {
                            ForEach(plant.bestLocations, id: \.self) { location in
                                Text(location.rawValue).font(.system(size: 13, weight: .medium)).foregroundColor(AppTheme.accentPink)
                                    .padding(.horizontal, 12).padding(.vertical, 8).background(AppTheme.softPink).cornerRadius(12)
                            }
                        }
                    }.frame(maxWidth: .infinity, alignment: .leading).padding(20).cardStyle().padding(.horizontal, 16)
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Planting Seasons").font(.system(size: 18, weight: .bold)).foregroundColor(AppTheme.textPrimary)
                        HStack(spacing: 12) {
                            ForEach(Season.allCases, id: \.self) { season in
                                SeasonBadge(season: season, isActive: plant.plantingSeasons.contains(season))
                            }
                        }
                    }.frame(maxWidth: .infinity, alignment: .leading).padding(20).cardStyle().padding(.horizontal, 16).padding(.bottom, 30)
                }
            }
            .background(AppTheme.background)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button { dismiss() } label: { Image(systemName: "xmark.circle.fill").font(.system(size: 24)).foregroundColor(AppTheme.textSecondary.opacity(0.5)) }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button { withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) { dataManager.toggleFavorite(plantId: plant.id) } } label: {
                        Image(systemName: dataManager.isFavorite(plantId: plant.id) ? "heart.fill" : "heart").font(.system(size: 22))
                            .foregroundColor(dataManager.isFavorite(plantId: plant.id) ? AppTheme.accentPink : AppTheme.textSecondary)
                    }
                }
            }
        }
    }
    
    private var careLevelColor: Color {
        switch plant.careLevel { case .low: return AppTheme.primaryGreen; case .medium: return .orange; case .high: return AppTheme.accentPink }
    }
}

struct InfoTile: View {
    let icon: String; let title: String; let value: String; let color: Color
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon).font(.system(size: 20)).foregroundColor(color)
            Text(title).font(.system(size: 12, weight: .medium)).foregroundColor(AppTheme.textSecondary)
            Text(value).font(.system(size: 14, weight: .semibold)).foregroundColor(AppTheme.textPrimary).multilineTextAlignment(.center)
        }.frame(maxWidth: .infinity).padding(.vertical, 12).background(color.opacity(0.08)).cornerRadius(12)
    }
}

struct SeasonBadge: View {
    let season: Season; let isActive: Bool
    var icon: String { switch season { case .spring: return "рџЊё"; case .summer: return "вЂпёЏ"; case .autumn: return "рџЌ‚"; case .winter: return "вќ„пёЏ" } }
    var body: some View {
        VStack(spacing: 6) {
            Text(icon).font(.system(size: 24)).opacity(isActive ? 1 : 0.3)
            Text(season.rawValue).font(.system(size: 11, weight: .medium)).foregroundColor(isActive ? AppTheme.textPrimary : AppTheme.textSecondary.opacity(0.5))
        }.frame(maxWidth: .infinity).padding(.vertical, 10).background(isActive ? AppTheme.mintGreen.opacity(0.3) : Color.gray.opacity(0.1)).cornerRadius(10)
    }
}

struct FlowLayout: Layout {
    var spacing: CGFloat = 8
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let result = FlowResult(in: proposal.width ?? 0, subviews: subviews, spacing: spacing)
        return CGSize(width: proposal.width ?? 0, height: result.height)
    }
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let result = FlowResult(in: bounds.width, subviews: subviews, spacing: spacing)
        for (index, subview) in subviews.enumerated() {
            let point = result.positions[index]
            subview.place(at: CGPoint(x: bounds.minX + point.x, y: bounds.minY + point.y), proposal: .unspecified)
        }
    }
    struct FlowResult {
        var positions: [CGPoint] = []; var height: CGFloat = 0
        init(in width: CGFloat, subviews: Subviews, spacing: CGFloat) {
            var x: CGFloat = 0; var y: CGFloat = 0; var rowHeight: CGFloat = 0
            for subview in subviews {
                let size = subview.sizeThatFits(.unspecified)
                if x + size.width > width && x > 0 { x = 0; y += rowHeight + spacing; rowHeight = 0 }
                positions.append(CGPoint(x: x, y: y)); rowHeight = max(rowHeight, size.height); x += size.width + spacing
            }
            height = y + rowHeight
        }
    }
}
