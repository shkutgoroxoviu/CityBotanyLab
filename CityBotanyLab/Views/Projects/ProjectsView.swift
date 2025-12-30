//
//  ProjectsView.swift
//  CityBotanyLab
//

import SwiftUI

struct ProjectsView: View {
    @EnvironmentObject var dataManager: DataManager
    @State private var showingAddProject = false
    @State private var selectedProject: Project?
    @State private var filterStatus: ProjectStatus?
    
    var filteredProjects: [Project] {
        if let status = filterStatus { return dataManager.projects.filter { $0.status == status } }
        return dataManager.projects.sorted { $0.createdDate > $1.createdDate }
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                AppTheme.background.ignoresSafeArea()
                if dataManager.projects.isEmpty {
                    EmptyProjectsView { showingAddProject = true }
                } else {
                    VStack(spacing: 0) {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 10) {
                                StatusFilterChip(title: "All", count: dataManager.projects.count, isSelected: filterStatus == nil) { filterStatus = nil }
                                ForEach(ProjectStatus.allCases, id: \.self) { status in
                                    StatusFilterChip(title: status.rawValue, count: dataManager.projects.filter { $0.status == status }.count, isSelected: filterStatus == status) {
                                        filterStatus = filterStatus == status ? nil : status
                                    }
                                }
                            }.padding(.horizontal, 16)
                        }.padding(.vertical, 12)
                        
                        ScrollView {
                            LazyVStack(spacing: 12) {
                                ForEach(filteredProjects) { project in
                                    ProjectCard(project: project).onTapGesture { selectedProject = project }
                                }
                            }.padding(.horizontal, 16).padding(.bottom, 20)
                        }
                    }
                }
            }
            .navigationTitle("Projects")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button { showingAddProject = true } label: {
                        Image(systemName: "plus.circle.fill").font(.system(size: 24)).foregroundColor(AppTheme.primaryGreen)
                    }
                }
            }
            .sheet(isPresented: $showingAddProject) { AddProjectView() }
            .sheet(item: $selectedProject) { project in ProjectDetailView(project: project) }
        }
    }
}

struct EmptyProjectsView: View {
    let onAdd: () -> Void
    var body: some View {
        VStack(spacing: 24) {
            ZStack { Circle().fill(AppTheme.paleGreen).frame(width: 120, height: 120); Text("рџ“‹").font(.system(size: 50)) }
            VStack(spacing: 8) {
                Text("No Projects Yet").font(.system(size: 22, weight: .bold)).foregroundColor(AppTheme.textPrimary)
                Text("Create your first urban greening project").font(.system(size: 15)).foregroundColor(AppTheme.textSecondary).multilineTextAlignment(.center)
            }
            Button { onAdd() } label: {
                HStack { Image(systemName: "plus"); Text("Create Project") }
                    .font(.system(size: 16, weight: .semibold)).foregroundColor(.white)
                    .padding(.horizontal, 32).padding(.vertical, 14).background(AppTheme.primaryGradient).cornerRadius(14)
            }
        }.padding(40)
    }
}

struct StatusFilterChip: View {
    let title: String; let count: Int; let isSelected: Bool; let action: () -> Void
    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                Text(title).font(.system(size: 14, weight: .medium))
                Text("\(count)").font(.system(size: 12, weight: .bold)).padding(.horizontal, 6).padding(.vertical, 2)
                    .background(isSelected ? Color.white.opacity(0.3) : AppTheme.primaryGreen.opacity(0.15)).cornerRadius(8)
            }
            .foregroundColor(isSelected ? .white : AppTheme.textPrimary)
            .padding(.horizontal, 14).padding(.vertical, 10)
            .background(isSelected ? AppTheme.primaryGreen : Color.white)
            .cornerRadius(20).shadow(color: AppTheme.darkGreen.opacity(0.08), radius: 4, x: 0, y: 2)
        }
    }
}

struct ProjectCard: View {
    let project: Project
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(project.status.icon).font(.system(size: 24))
                VStack(alignment: .leading, spacing: 2) {
                    Text(project.name).font(.system(size: 17, weight: .semibold)).foregroundColor(AppTheme.textPrimary)
                    Text(project.locationType.rawValue).font(.system(size: 13)).foregroundColor(AppTheme.textSecondary)
                }
                Spacer()
                Text(project.status.rawValue).font(.system(size: 12, weight: .medium)).foregroundColor(statusColor)
                    .padding(.horizontal, 10).padding(.vertical, 5).background(statusColor.opacity(0.15)).cornerRadius(8)
            }
            if !project.projectDescription.isEmpty {
                Text(project.projectDescription).font(.system(size: 14)).foregroundColor(AppTheme.textSecondary).lineLimit(2)
            }
            HStack(spacing: 16) {
                HStack(spacing: 4) { Image(systemName: "ruler").font(.system(size: 12)); Text("\(Int(project.area)) mВІ").font(.system(size: 13, weight: .medium)) }.foregroundColor(AppTheme.textSecondary)
                HStack(spacing: 4) { Image(systemName: "leaf").font(.system(size: 12)); Text("\(project.plants.count) plants").font(.system(size: 13, weight: .medium)) }.foregroundColor(AppTheme.textSecondary)
                Spacer()
                Text(project.createdDate, style: .date).font(.system(size: 12)).foregroundColor(AppTheme.textSecondary.opacity(0.7))
            }
        }.padding(16).cardStyle()
    }
    
    private var statusColor: Color {
        switch project.status { case .planning: return .orange; case .inProgress: return AppTheme.primaryGreen; case .completed: return .green; case .onHold: return AppTheme.textSecondary }
    }
}
