//
//  OnboardingView.swift
//  CityBotanyLab
//

import SwiftUI

struct OnboardingView: View {
    @Binding var hasSeenOnboarding: Bool
    @EnvironmentObject var dataManager: DataManager
    @State private var currentPage = 0
    
    private let pages: [OnboardingPage] = [
        OnboardingPage(
            icon: "tree.fill",
            title: "Discover Urban Plants",
            description: "Explore a comprehensive catalog of trees, shrubs, and flowers perfect for city environments. Find the ideal plants for any urban space."
        ),
        OnboardingPage(
            icon: "folder.fill",
            title: "Plan Your Projects",
            description: "Create and manage landscaping projects for streets, parks, plazas, and green zones. Track plant quantities, areas, and progress."
        ),
        OnboardingPage(
            icon: "book.fill",
            title: "Keep a Care Journal",
            description: "Document your plant care activities, observations, and maintenance schedules. Build a history of your urban greening efforts."
        ),
        OnboardingPage(
            icon: "function",
            title: "Calculate Resources",
            description: "Estimate plant quantities for your projects based on area and spacing requirements. Plan efficiently and avoid waste."
        ),
        OnboardingPage(
            icon: "heart.fill",
            title: "Save Favorites",
            description: "Bookmark plants you love for quick reference. Build your personal collection of go-to urban plant species."
        ),
        OnboardingPage(
            icon: "leaf.fill",
            title: "Start Growing",
            description: "Join the urban greening movement. Transform concrete jungles into thriving green spaces, one plant at a time."
        )
    ]
    
    var body: some View {
        ZStack {
            AppTheme.onboardingGradient
                .ignoresSafeArea()
            
            // Decorative circles
            Circle()
                .fill(AppTheme.accentPink.opacity(0.1))
                .frame(width: 300, height: 300)
                .blur(radius: 60)
                .offset(x: -150, y: -300)
            
            Circle()
                .fill(AppTheme.primaryGreen.opacity(0.15))
                .frame(width: 250, height: 250)
                .blur(radius: 50)
                .offset(x: 150, y: 400)
            
            VStack(spacing: 0) {
                // Skip button
                HStack {
                    Spacer()
                    if currentPage < pages.count - 1 {
                        Button("Skip") {
                            withAnimation {
                                hasSeenOnboarding = true
                            }
                        }
                        .foregroundColor(AppTheme.textSecondary)
                        .padding()
                    }
                }
                .frame(height: 50)
                
                TabView(selection: $currentPage) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        OnboardingPageView(page: pages[index])
                            .tag(index)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                
                // Custom page indicator
                HStack(spacing: 8) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        Capsule()
                            .fill(index == currentPage ? AppTheme.primaryGreen : AppTheme.textSecondary.opacity(0.3))
                            .frame(width: index == currentPage ? 24 : 8, height: 8)
                            .animation(.easeInOut(duration: 0.3), value: currentPage)
                    }
                }
                .padding(.vertical, 24)
                
                // Navigation buttons
                VStack(spacing: 12) {
                    Button(action: {
                        if currentPage < pages.count - 1 {
                            withAnimation {
                                currentPage += 1
                            }
                        } else {
                            withAnimation {
                                hasSeenOnboarding = true
                            }
                        }
                    }) {
                        HStack {
                            Text(currentPage < pages.count - 1 ? "Continue" : "Get Started")
                                .fontWeight(.semibold)
                            
                            Image(systemName: currentPage < pages.count - 1 ? "arrow.right" : "checkmark")
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(AppTheme.primaryGreen)
                        .foregroundColor(.white)
                        .cornerRadius(16)
                    }
                    
                    if currentPage > 0 {
                        Button("Back") {
                            withAnimation {
                                currentPage -= 1
                            }
                        }
                        .foregroundColor(AppTheme.textSecondary)
                        .frame(height: 44)
                    }
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 32)
            }
        }
    }
}

struct OnboardingPage {
    let icon: String
    let title: String
    let description: String
}

struct OnboardingPageView: View {
    let page: OnboardingPage
    
    var body: some View {
        VStack(spacing: 32) {
            Spacer()
            
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [AppTheme.primaryGreen.opacity(0.2), AppTheme.accentPink.opacity(0.1)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 180, height: 180)
                
                Image(systemName: page.icon)
                    .font(.system(size: 70))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [AppTheme.primaryGreen, AppTheme.accentPink],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
            }
            
            VStack(spacing: 16) {
                Text(page.title)
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(AppTheme.textPrimary)
                    .multilineTextAlignment(.center)
                
                Text(page.description)
                    .font(.body)
                    .foregroundColor(AppTheme.textSecondary)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
                    .padding(.horizontal, 32)
            }
            
            Spacer()
            Spacer()
        }
    }
}

#Preview {
    OnboardingView(hasSeenOnboarding: .constant(false))
        .environmentObject(DataManager())
}