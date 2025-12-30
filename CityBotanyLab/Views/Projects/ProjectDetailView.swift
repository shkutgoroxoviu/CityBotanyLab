//
//  ProjectDetailView.swift
//  CityBotanyLab
//

import SwiftUI

struct ProjectDetailView: View {
    @State var project: Project
    @EnvironmentObject var dataManager: DataManager
    @Environment(\.dismiss) var dismiss
    @State private var showingEditSheet = false
    @State private var showingDeleteAlert = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    VStack(spacing: 12) {
                        HStack {
                            Text(project.status.icon).font(.system(size: 40))
                            VStack(alignment: .leading, spacing: 4) {
                                Text(project.name).font(.system(size: 24, weight: .bold)).foregroundColor(AppTheme.textPrimary)
                                Text(project.locationType.rawValue).font(.system(size: 15)).foregroundColor(AppTheme.textSecondary)
                            }
                            Spacer()
                        }
                        HStack(spacing: 8) {
                            ForEach(ProjectStatus.allCases, id: \.self) { status in
                                Button { withAnimation { project.status = status; dataManager.updateProject(project) } } label: {
                                    Text(status.rawValue).font(.system(size: 13, weight: .medium))
                                        .foregroundColor(project.status == status ? .white : AppTheme.textSecondary)
                                        .padding(.horizontal, 12).padding(.vertical, 8)
                                        .background(project.status == status ? statusColor(for: status) : Color.gray.opacity(0.1)).cornerRadius(10)
                                }
                            }
                        }
                    }.padding(20).cardStyle().padding(.horizontal, 16)
                    
                    if !project.projectDescription.isEmpty {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Description").font(.system(size: 16, weight: .bold)).foregroundColor(AppTheme.textPrimary)
                            Text(project.projectDescription).font(.system(size: 15)).foregroundColor(AppTheme.textSecondary).lineSpacing(4)
                        }.frame(maxWidth: .infinity, alignment: .leading).padding(20).cardStyle().padding(.horizontal, 16)
                    }
                    
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Project Details").font(.system(size: 16, weight: .bold)).foregroundColor(AppTheme.textPrimary)
                        HStack(spacing: 12) {
                            DetailTile(icon: "ruler", title: "Area", value: "\(Int(project.area)) mВІ", color: AppTheme.primaryGreen)
                            DetailTile(icon: "leaf.fill", title: "Plants", value: "\(project.plants.count)", color: AppTheme.accentPink)
                        }
                        HStack(spacing: 12) {
                            DetailTile(icon: "calendar", title: "Created", value: project.createdDate.formatted(date: .abbreviated, time: .omitted), color: .orange)
                            if let targetDate = project.targetCompletionDate {
                                DetailTile(icon: "flag.fill", title: "Target", value: targetDate.formatted(date: .abbreviated, time: .omitted), color: .blue)
                            }
                        }
                    }.padding(20).cardStyle().padding(.horizontal, 16)
                    
                    if !project.plants.isEmpty {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Plants (\(totalPlantCount))").font(.system(size: 16, weight: .bold)).foregroundColor(AppTheme.textPrimary)
                            ForEach(project.plants.indices, id: \.self) { index in
                                let pp = project.plants[index]
                                HStack {
                                    if let plant = dataManager.plant(for: pp.plantId) { Text(plant.icon).font(.system(size: 24)) }
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text(pp.plantName).font(.system(size: 15, weight: .medium)).foregroundColor(AppTheme.textPrimary)
                                        Text("Qty: \(pp.quantity)").font(.system(size: 13)).foregroundColor(AppTheme.textSecondary)
                                    }
                                    Spacer()
                                    Button {
                                        withAnimation {
                                            project.plants[index].isPlanted.toggle()
                                            project.plants[index].plantedDate = project.plants[index].isPlanted ? Date() : nil
                                            dataManager.updateProject(project)
                                        }
                                    } label: {
                                        Image(systemName: pp.isPlanted ? "checkmark.circle.fill" : "circle").font(.system(size: 24))
                                            .foregroundColor(pp.isPlanted ? AppTheme.primaryGreen : AppTheme.textSecondary.opacity(0.5))
                                    }
                                }.padding(.vertical, 8)
                                if index < project.plants.count - 1 { Divider() }
                            }
                        }.padding(20).cardStyle().padding(.horizontal, 16)
                    }
                    
                    Button { showingDeleteAlert = true } label: {
                        HStack { Image(systemName: "trash"); Text("Delete Project") }
                            .font(.system(size: 16, weight: .medium)).foregroundColor(.red)
                            .frame(maxWidth: .infinity).padding(.vertical, 14).background(Color.red.opacity(0.1)).cornerRadius(12)
                    }.padding(.horizontal, 16).padding(.bottom, 30)
                }.padding(.top, 16)
            }
            .background(AppTheme.background).navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button { dismiss() } label: { Image(systemName: "xmark.circle.fill").font(.system(size: 24)).foregroundColor(AppTheme.textSecondary.opacity(0.5)) }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button { showingEditSheet = true } label: { Text("Edit").font(.system(size: 16, weight: .medium)).foregroundColor(AppTheme.primaryGreen) }
                }
            }
            .alert("Delete Project?", isPresented: $showingDeleteAlert) {
                Button("Cancel", role: .cancel) {}
                Button("Delete", role: .destructive) { dataManager.deleteProject(project); dismiss() }
            } message: { Text("This action cannot be undone.") }
            .sheet(isPresented: $showingEditSheet) { EditProjectView(project: $project) }
        }
    }
    
    private var totalPlantCount: Int { project.plants.reduce(0) { $0 + $1.quantity } }
    private func statusColor(for status: ProjectStatus) -> Color {
        switch status { case .planning: return .orange; case .inProgress: return AppTheme.primaryGreen; case .completed: return .green; case .onHold: return AppTheme.textSecondary }
    }
}

struct DetailTile: View {
    let icon: String; let title: String; let value: String; let color: Color
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon).font(.system(size: 18)).foregroundColor(color).frame(width: 36, height: 36).background(color.opacity(0.15)).cornerRadius(10)
            VStack(alignment: .leading, spacing: 2) {
                Text(title).font(.system(size: 12)).foregroundColor(AppTheme.textSecondary)
                Text(value).font(.system(size: 15, weight: .semibold)).foregroundColor(AppTheme.textPrimary)
            }
            Spacer()
        }.padding(12).background(Color.gray.opacity(0.05)).cornerRadius(12)
    }
}

struct EditProjectView: View {
    @Binding var project: Project
    @EnvironmentObject var dataManager: DataManager
    @Environment(\.dismiss) var dismiss
    @State private var name = ""; @State private var projectDescription = ""; @State private var notes = ""; @State private var area = ""; @State private var locationType: UrbanLocation = .park
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Project Info") {
                    TextField("Project Name", text: $name)
                    TextField("Description", text: $projectDescription, axis: .vertical).lineLimit(3...6)
                    Picker("Location Type", selection: $locationType) { ForEach(UrbanLocation.allCases, id: \.self) { Text($0.rawValue).tag($0) } }
                    HStack { Text("Area"); Spacer(); TextField("0", text: $area).keyboardType(.decimalPad).multilineTextAlignment(.trailing).frame(width: 80); Text("mВІ").foregroundColor(AppTheme.textSecondary) }
                }
                Section("Notes") { TextField("Additional notes...", text: $notes, axis: .vertical).lineLimit(4...8) }
            }
            .onAppear { name = project.name; projectDescription = project.projectDescription; notes = project.notes; area = String(Int(project.area)); locationType = project.locationType }
            .navigationTitle("Edit Project").navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) { Button("Cancel") { dismiss() } }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        project.name = name; project.projectDescription = projectDescription; project.notes = notes
                        project.area = Double(area) ?? 0; project.locationType = locationType
                        dataManager.updateProject(project); dismiss()
                    }.font(.system(size: 16, weight: .semibold)).foregroundColor(AppTheme.primaryGreen)
                }
            }
        }
    }
}
