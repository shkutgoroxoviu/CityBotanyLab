//
//  ProjectsView.swift
//  CityBotanyLab
//

import SwiftUI

struct ProjectsView: View {
    @EnvironmentObject var dataManager: DataManager
    @State private var showingAddProject = false
    @State private var selectedProject: Project?
    
    var body: some View {
        NavigationStack {
            ZStack {
                AppTheme.background
                    .ignoresSafeArea()
                
                if dataManager.projects.isEmpty {
                    EmptyProjectsView(showingAddProject: $showingAddProject)
                } else {
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(dataManager.projects) { project in
                                ProjectCard(project: project)
                                    .onTapGesture {
                                        selectedProject = project
                                    }
                            }
                        }
                        .padding(16)
                        .padding(.bottom, 100)
                    }
                }
            }
            .navigationTitle("Projects")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingAddProject = true }) {
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(AppTheme.primaryGreen)
                    }
                }
            }
            .sheet(isPresented: $showingAddProject) {
                AddProjectView()
            }
            .sheet(item: $selectedProject) { project in
                ProjectDetailView(project: project)
            }
        }
    }
}

struct EmptyProjectsView: View {
    @Binding var showingAddProject: Bool
    
    var body: some View {
        VStack(spacing: 24) {
            Image(systemName: "folder.badge.plus")
                .font(.system(size: 60))
                .foregroundColor(AppTheme.textSecondary.opacity(0.5))
            
            VStack(spacing: 8) {
                Text("No Projects Yet")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(AppTheme.textPrimary)
                
                Text("Create your first landscaping project\nto start planning your urban green space")
                    .font(.body)
                    .foregroundColor(AppTheme.textSecondary)
                    .multilineTextAlignment(.center)
            }
            
            Button(action: { showingAddProject = true }) {
                HStack {
                    Image(systemName: "plus")
                    Text("Create Project")
                }
                .primaryButtonStyle()
            }
        }
        .padding(32)
    }
}

struct ProjectCard: View {
    let project: Project
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(project.name)
                        .font(.headline)
                        .foregroundColor(AppTheme.textPrimary)
                    
                    Text(project.locationType.rawValue)
                        .font(.caption)
                        .foregroundColor(AppTheme.textSecondary)
                }
                
                Spacer()
                
                StatusBadge(status: project.status)
            }
            
            Text(project.projectDescription)
                .font(.subheadline)
                .foregroundColor(AppTheme.textSecondary)
                .lineLimit(2)
            
            HStack(spacing: 16) {
                Label("\(Int(project.area)) sqm", systemImage: "square.dashed")
                Label("\(project.plants.count) plants", systemImage: "leaf")
            }
            .font(.caption)
            .foregroundColor(AppTheme.textSecondary)
        }
        .padding(16)
        .cardStyle()
    }
}

struct StatusBadge: View {
    let status: ProjectStatus
    
    var color: Color {
        switch status {
        case .planning: return .orange
        case .inProgress: return .blue
        case .completed: return AppTheme.primaryGreen
        case .onHold: return .gray
        }
    }
    
    var body: some View {
        Text(status.rawValue)
            .font(.caption)
            .fontWeight(.medium)
            .foregroundColor(color)
            .padding(.horizontal, 10)
            .padding(.vertical, 4)
            .background(color.opacity(0.15))
            .cornerRadius(8)
    }
}

#Preview {
    ProjectsView()
        .environmentObject(DataManager())
}