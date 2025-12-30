//
//  CalculatorView.swift
//  CityBotanyLab
//

import SwiftUI

struct CalculatorView: View {
    @State private var selectedCalculator = 0
    
    var body: some View {
        NavigationStack {
            ZStack {
                AppTheme.background
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Calculator selector
                    Picker("Calculator", selection: $selectedCalculator) {
                        Text("Plant Spacing").tag(0)
                        Text("Area Coverage").tag(1)
                        Text("Water Needs").tag(2)
                    }
                    .pickerStyle(.segmented)
                    .padding(16)
                    
                    ScrollView {
                        switch selectedCalculator {
                        case 0:
                            PlantSpacingCalculator()
                        case 1:
                            AreaCoverageCalculator()
                        case 2:
                            WaterNeedsCalculator()
                        default:
                            PlantSpacingCalculator()
                        }
                    }
                }
            }
            .navigationTitle("Calculator")
        }
    }
}

struct PlantSpacingCalculator: View {
    @State private var areaLength: Double = 10
    @State private var areaWidth: Double = 10
    @State private var spacing: Double = 1.5
    
    var totalArea: Double {
        areaLength * areaWidth
    }
    
    var plantsNeeded: Int {
        guard spacing > 0 else { return 0 }
        let rows = Int(areaLength / spacing) + 1
        let cols = Int(areaWidth / spacing) + 1
        return rows * cols
    }
    
    var body: some View {
        VStack(spacing: 24) {
            // Result card
            VStack(spacing: 8) {
                Text("\(plantsNeeded)")
                    .font(.system(size: 60, weight: .bold))
                    .foregroundColor(AppTheme.primaryGreen)
                
                Text("plants needed")
                    .font(.subheadline)
                    .foregroundColor(AppTheme.textSecondary)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 32)
            .cardStyle()
            .padding(.horizontal, 16)
            
            // Inputs
            VStack(spacing: 16) {
                InputSlider(title: "Area Length", value: $areaLength, range: 1...100, unit: "m")
                InputSlider(title: "Area Width", value: $areaWidth, range: 1...100, unit: "m")
                InputSlider(title: "Plant Spacing", value: $spacing, range: 0.3...5, unit: "m")
            }
            .padding(.horizontal, 16)
            
            // Summary
            VStack(spacing: 12) {
                SummaryRow(label: "Total Area", value: String(format: "%.1f sqm", totalArea))
                SummaryRow(label: "Plants per Row", value: "\(Int(areaWidth / spacing) + 1)")
                SummaryRow(label: "Number of Rows", value: "\(Int(areaLength / spacing) + 1)")
            }
            .padding(16)
            .cardStyle()
            .padding(.horizontal, 16)
            
            Spacer()
        }
        .padding(.top, 16)
    }
}

struct AreaCoverageCalculator: View {
    @State private var plantCount: Double = 50
    @State private var coveragePerPlant: Double = 2
    
    var totalCoverage: Double {
        plantCount * coveragePerPlant
    }
    
    var body: some View {
        VStack(spacing: 24) {
            // Result card
            VStack(spacing: 8) {
                Text(String(format: "%.0f", totalCoverage))
                    .font(.system(size: 60, weight: .bold))
                    .foregroundColor(AppTheme.primaryGreen)
                
                Text("sqm coverage")
                    .font(.subheadline)
                    .foregroundColor(AppTheme.textSecondary)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 32)
            .cardStyle()
            .padding(.horizontal, 16)
            
            // Inputs
            VStack(spacing: 16) {
                InputSlider(title: "Number of Plants", value: $plantCount, range: 1...500, unit: "plants")
                InputSlider(title: "Coverage per Plant", value: $coveragePerPlant, range: 0.5...10, unit: "sqm")
            }
            .padding(.horizontal, 16)
            
            // Info
            VStack(alignment: .leading, spacing: 8) {
                Text("Tip")
                    .font(.headline)
                    .foregroundColor(AppTheme.textPrimary)
                
                Text("Coverage varies by plant type: ground covers typically cover 0.5-2 sqm, shrubs 2-4 sqm, and trees can shade 10-50+ sqm.")
                    .font(.subheadline)
                    .foregroundColor(AppTheme.textSecondary)
            }
            .padding(16)
            .cardStyle()
            .padding(.horizontal, 16)
            
            Spacer()
        }
        .padding(.top, 16)
    }
}

struct WaterNeedsCalculator: View {
    @State private var plantCount: Double = 20
    @State private var waterPerPlant: Double = 5
    @State private var wateringFrequency: Double = 2
    
    var dailyWater: Double {
        (plantCount * waterPerPlant * wateringFrequency) / 7
    }
    
    var weeklyWater: Double {
        plantCount * waterPerPlant * wateringFrequency
    }
    
    var monthlyWater: Double {
        weeklyWater * 4
    }
    
    var body: some View {
        VStack(spacing: 24) {
            // Result card
            VStack(spacing: 8) {
                Text(String(format: "%.0f", weeklyWater))
                    .font(.system(size: 60, weight: .bold))
                    .foregroundColor(AppTheme.primaryGreen)
                
                Text("liters per week")
                    .font(.subheadline)
                    .foregroundColor(AppTheme.textSecondary)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 32)
            .cardStyle()
            .padding(.horizontal, 16)
            
            // Inputs
            VStack(spacing: 16) {
                InputSlider(title: "Number of Plants", value: $plantCount, range: 1...200, unit: "plants")
                InputSlider(title: "Water per Plant", value: $waterPerPlant, range: 1...20, unit: "L")
                InputSlider(title: "Waterings per Week", value: $wateringFrequency, range: 1...7, unit: "times")
            }
            .padding(.horizontal, 16)
            
            // Summary
            VStack(spacing: 12) {
                SummaryRow(label: "Daily Average", value: String(format: "%.1f L", dailyWater))
                SummaryRow(label: "Weekly Total", value: String(format: "%.0f L", weeklyWater))
                SummaryRow(label: "Monthly Estimate", value: String(format: "%.0f L", monthlyWater))
            }
            .padding(16)
            .cardStyle()
            .padding(.horizontal, 16)
            
            Spacer()
        }
        .padding(.top, 16)
    }
}

struct InputSlider: View {
    let title: String
    @Binding var value: Double
    let range: ClosedRange<Double>
    let unit: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(title)
                    .font(.subheadline)
                    .foregroundColor(AppTheme.textSecondary)
                
                Spacer()
                
                Text(String(format: "%.1f", value) + " " + unit)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(AppTheme.textPrimary)
            }
            
            Slider(value: $value, in: range)
                .tint(AppTheme.primaryGreen)
        }
        .padding(16)
        .cardStyle()
    }
}

struct SummaryRow: View {
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Text(label)
                .foregroundColor(AppTheme.textSecondary)
            Spacer()
            Text(value)
                .fontWeight(.medium)
                .foregroundColor(AppTheme.textPrimary)
        }
        .font(.subheadline)
    }
}

#Preview {
    CalculatorView()
}