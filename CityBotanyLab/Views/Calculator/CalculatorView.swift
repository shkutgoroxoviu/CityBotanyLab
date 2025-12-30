//
//  CalculatorView.swift
//  CityBotanyLab
//

import SwiftUI

struct CalculatorView: View {
    @State private var selectedCalculator: CalculatorType = .plantSpacing
    
    var body: some View {
        NavigationStack {
            ZStack {
                AppTheme.background.ignoresSafeArea()
                VStack(spacing: 0) {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 10) {
                            ForEach(CalculatorType.allCases, id: \.self) { type in
                                CalculatorTypeButton(type: type, isSelected: selectedCalculator == type) { withAnimation { selectedCalculator = type } }
                            }
                        }.padding(.horizontal, 16)
                    }.padding(.vertical, 12)
                    
                    ScrollView {
                        VStack(spacing: 20) {
                            switch selectedCalculator {
                            case .plantSpacing: PlantSpacingCalculator()
                            case .watering: WateringCalculator()
                            case .mulch: MulchCalculator()
                            case .treeCount: TreeCountCalculator()
                            case .greenArea: GreenAreaCalculator()
                            }
                        }.padding(.horizontal, 16).padding(.bottom, 30)
                    }
                }
            }.navigationTitle("Calculators")
        }
    }
}

enum CalculatorType: String, CaseIterable {
    case plantSpacing = "Spacing"; case watering = "Watering"; case mulch = "Mulch"; case treeCount = "Tree Count"; case greenArea = "Green Area"
    var icon: String { switch self { case .plantSpacing: return "arrow.left.and.right"; case .watering: return "drop.fill"; case .mulch: return "leaf.fill"; case .treeCount: return "tree"; case .greenArea: return "square.grid.2x2" } }
}

struct CalculatorTypeButton: View {
    let type: CalculatorType; let isSelected: Bool; let action: () -> Void
    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) { Image(systemName: type.icon).font(.system(size: 14)); Text(type.rawValue).font(.system(size: 14, weight: .medium)) }
                .foregroundColor(isSelected ? .white : AppTheme.textPrimary).padding(.horizontal, 14).padding(.vertical, 10)
                .background(isSelected ? AppTheme.primaryGreen : Color.white).cornerRadius(20).shadow(color: AppTheme.darkGreen.opacity(0.08), radius: 4, x: 0, y: 2)
        }
    }
}

struct PlantSpacingCalculator: View {
    @State private var areaLength = ""; @State private var areaWidth = ""; @State private var plantSpacing = ""; @State private var result: Int?
    var body: some View {
        VStack(spacing: 16) {
            CalculatorHeader(icon: "arrow.left.and.right", title: "Plant Spacing Calculator", description: "Calculate how many plants you need based on area and spacing")
            VStack(spacing: 16) {
                CalculatorInputField(label: "Area Length", value: $areaLength, unit: "m", placeholder: "10")
                CalculatorInputField(label: "Area Width", value: $areaWidth, unit: "m", placeholder: "5")
                CalculatorInputField(label: "Plant Spacing", value: $plantSpacing, unit: "m", placeholder: "1.5")
                Button { calculate() } label: { Text("Calculate").primaryButtonStyle() }
                if let result = result { ResultCard(value: "\(result)", label: "plants needed") }
            }.padding(20).cardStyle()
        }
    }
    private func calculate() {
        guard let length = Double(areaLength), let width = Double(areaWidth), let spacing = Double(plantSpacing), spacing > 0 else { result = nil; return }
        let plantsPerRow = Int(ceil(length / spacing)) + 1; let numberOfRows = Int(ceil(width / spacing)) + 1; result = plantsPerRow * numberOfRows
    }
}

struct WateringCalculator: View {
    @State private var plantCount = ""; @State private var waterPerPlant = ""; @State private var frequencyPerWeek = ""; @State private var result: (daily: Double, weekly: Double, monthly: Double)?
    var body: some View {
        VStack(spacing: 16) {
            CalculatorHeader(icon: "drop.fill", title: "Watering Calculator", description: "Estimate water requirements for your plants")
            VStack(spacing: 16) {
                CalculatorInputField(label: "Number of Plants", value: $plantCount, unit: "", placeholder: "50")
                CalculatorInputField(label: "Water per Plant", value: $waterPerPlant, unit: "L", placeholder: "2")
                CalculatorInputField(label: "Watering Frequency", value: $frequencyPerWeek, unit: "/week", placeholder: "3")
                Button { calculate() } label: { Text("Calculate").primaryButtonStyle() }
                if let result = result {
                    VStack(spacing: 12) {
                        ResultCard(value: String(format: "%.1f L", result.weekly), label: "per week")
                        HStack(spacing: 12) { SmallResultCard(value: String(format: "%.1f L", result.daily), label: "per day"); SmallResultCard(value: String(format: "%.0f L", result.monthly), label: "per month") }
                    }
                }
            }.padding(20).cardStyle()
        }
    }
    private func calculate() {
        guard let count = Double(plantCount), let water = Double(waterPerPlant), let freq = Double(frequencyPerWeek), freq > 0 else { result = nil; return }
        let weekly = count * water * freq; result = (daily: weekly / 7, weekly: weekly, monthly: weekly * 4.33)
    }
}

struct MulchCalculator: View {
    @State private var areaSize = ""; @State private var mulchDepth = ""; @State private var result: Double?
    var body: some View {
        VStack(spacing: 16) {
            CalculatorHeader(icon: "leaf.fill", title: "Mulch Calculator", description: "Calculate mulch volume needed for your area")
            VStack(spacing: 16) {
                CalculatorInputField(label: "Area Size", value: $areaSize, unit: "mВІ", placeholder: "100")
                CalculatorInputField(label: "Mulch Depth", value: $mulchDepth, unit: "cm", placeholder: "7")
                Button { calculate() } label: { Text("Calculate").primaryButtonStyle() }
                if let result = result {
                    VStack(spacing: 12) {
                        ResultCard(value: String(format: "%.2f mВі", result), label: "of mulch needed")
                        let bags = Int(ceil(result * 1000 / 50)); SmallResultCard(value: "\(bags)", label: "50L bags approx.")
                    }
                }
            }.padding(20).cardStyle()
        }
    }
    private func calculate() { guard let area = Double(areaSize), let depth = Double(mulchDepth) else { result = nil; return }; result = area * (depth / 100) }
}

struct TreeCountCalculator: View {
    @State private var streetLength = ""; @State private var treeSpacing = ""; @State private var bothSides = true; @State private var result: Int?
    var body: some View {
        VStack(spacing: 16) {
            CalculatorHeader(icon: "tree", title: "Street Tree Calculator", description: "Calculate trees needed for street planting")
            VStack(spacing: 16) {
                CalculatorInputField(label: "Street Length", value: $streetLength, unit: "m", placeholder: "500")
                CalculatorInputField(label: "Tree Spacing", value: $treeSpacing, unit: "m", placeholder: "8")
                Toggle("Plant on Both Sides", isOn: $bothSides).tint(AppTheme.primaryGreen)
                Button { calculate() } label: { Text("Calculate").primaryButtonStyle() }
                if let result = result { ResultCard(value: "\(result)", label: "trees needed") }
            }.padding(20).cardStyle()
        }
    }
    private func calculate() {
        guard let length = Double(streetLength), let spacing = Double(treeSpacing), spacing > 0 else { result = nil; return }
        let treesPerSide = Int(floor(length / spacing)) + 1; result = bothSides ? treesPerSide * 2 : treesPerSide
    }
}

struct GreenAreaCalculator: View {
    @State private var totalArea = ""; @State private var greenArea = ""; @State private var result: Double?
    var body: some View {
        VStack(spacing: 16) {
            CalculatorHeader(icon: "square.grid.2x2", title: "Green Coverage Calculator", description: "Calculate the percentage of green coverage")
            VStack(spacing: 16) {
                CalculatorInputField(label: "Total Area", value: $totalArea, unit: "mВІ", placeholder: "1000")
                CalculatorInputField(label: "Green Area", value: $greenArea, unit: "mВІ", placeholder: "350")
                Button { calculate() } label: { Text("Calculate").primaryButtonStyle() }
                if let result = result {
                    VStack(spacing: 12) {
                        ResultCard(value: String(format: "%.1f%%", result), label: "green coverage")
                        Text(coverageMessage).font(.system(size: 14)).foregroundColor(AppTheme.textSecondary).multilineTextAlignment(.center).padding(.horizontal, 12)
                    }
                }
            }.padding(20).cardStyle()
        }
    }
    private var coverageMessage: String {
        guard let r = result else { return "" }
        if r >= 30 { return "вњ… Excellent! This meets most urban greening standards." }
        else if r >= 20 { return "рџ‘Ќ Good coverage. Consider adding more green elements." }
        else if r >= 10 { return "вљ пёЏ Below average. More vegetation recommended." }
        else { return "вќ— Low green coverage. Significant greening needed." }
    }
    private func calculate() { guard let total = Double(totalArea), let green = Double(greenArea), total > 0 else { result = nil; return }; result = (green / total) * 100 }
}

struct CalculatorHeader: View {
    let icon: String; let title: String; let description: String
    var body: some View {
        VStack(spacing: 12) {
            ZStack { Circle().fill(AppTheme.paleGreen).frame(width: 60, height: 60); Image(systemName: icon).font(.system(size: 24)).foregroundColor(AppTheme.primaryGreen) }
            Text(title).font(.system(size: 20, weight: .bold)).foregroundColor(AppTheme.textPrimary)
            Text(description).font(.system(size: 14)).foregroundColor(AppTheme.textSecondary).multilineTextAlignment(.center)
        }.padding(.bottom, 8)
    }
}

struct CalculatorInputField: View {
    let label: String; @Binding var value: String; let unit: String; let placeholder: String
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(label).font(.system(size: 14, weight: .medium)).foregroundColor(AppTheme.textSecondary)
            HStack {
                TextField(placeholder, text: $value).keyboardType(.decimalPad).font(.system(size: 18, weight: .medium)).foregroundColor(AppTheme.textPrimary)
                if !unit.isEmpty { Text(unit).font(.system(size: 16)).foregroundColor(AppTheme.textSecondary) }
            }.padding(14).background(AppTheme.background).cornerRadius(12)
        }
    }
}

struct ResultCard: View {
    let value: String; let label: String
    var body: some View {
        VStack(spacing: 6) {
            Text(value).font(.system(size: 36, weight: .bold)).foregroundColor(AppTheme.primaryGreen)
            Text(label).font(.system(size: 14)).foregroundColor(AppTheme.textSecondary)
        }.frame(maxWidth: .infinity).padding(.vertical, 20).background(AppTheme.paleGreen).cornerRadius(16)
    }
}

struct SmallResultCard: View {
    let value: String; let label: String
    var body: some View {
        VStack(spacing: 4) {
            Text(value).font(.system(size: 20, weight: .bold)).foregroundColor(AppTheme.accentPink)
            Text(label).font(.system(size: 12)).foregroundColor(AppTheme.textSecondary)
        }.frame(maxWidth: .infinity).padding(.vertical, 14).background(AppTheme.softPink).cornerRadius(12)
    }
}
