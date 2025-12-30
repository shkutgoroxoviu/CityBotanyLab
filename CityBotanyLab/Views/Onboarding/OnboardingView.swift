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
        OnboardingPage(icon: "рџЊі", title: "Discover Urban Plants", description: "Explore a comprehensive catalog of trees, shrubs, and flowers perfect for city environments."),
        OnboardingPage(icon: "рџ“‹", title: "Plan Your Green Projects", description: "Create and manage urban greening projects. Track plant selections and progress."),
        OnboardingPage(icon: "рџ“ќ", title: "Track Your Care Activities", description: "Keep a detailed journal of all your plant care activities."),
        OnboardingPage(icon: "рџ§®", title: "Calculate & Estimate", description: "Use built-in calculators to estimate plant quantities and watering needs."),
        OnboardingPage(icon: "в­ђ", title: "Save Your Favorites", description: "Build your personal collection of favorite plants."),
        OnboardingPage(icon: "рџЊї", title: "Ready to Go Green?", description: "Start exploring the world of urban botany.")
    ]
    
    var body: some View {
        ZStack {
            AppTheme.onboardingGradient.ignoresSafeArea()
            
            GeometryReader { geometry in
                Circle().fill(AppTheme.lightGreen.opacity(0.2)).frame(width: 200, height: 200).offset(x: -50, y: -50)
                Circle().fill(AppTheme.accentPink.opacity(0.15)).frame(width: 150, height: 150).offset(x: geometry.size.width - 80, y: 100)
                Circle().fill(AppTheme.mintGreen.opacity(0.2)).frame(width: 180, height: 180).offset(x: geometry.size.width - 100, y: geometry.size.height - 200)
            }
            
            VStack(spacing: 0) {
                HStack {
                    Spacer()
                    if currentPage < pages.count - 1 {
                        Button("Skip") { withAnimation { hasSeenOnboarding = true } }
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.white.opacity(0.9))
                            .padding(.horizontal, 24).padding(.top, 16)
                    }
                }
                
                TabView(selection: $currentPage) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        OnboardingPageView(page: pages[index]).tag(index)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                
                HStack(spacing: 8) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        Capsule()
                            .fill(currentPage == index ? AppTheme.accentPink : Color.white.opacity(0.4))
                            .frame(width: currentPage == index ? 24 : 8, height: 8)
                    }
                }
                .padding(.bottom, 32)
                
                VStack(spacing: 12) {
                    Button {
                        withAnimation {
                            if currentPage < pages.count - 1 { currentPage += 1 }
                            else { hasSeenOnboarding = true }
                        }
                    } label: {
                        Text(currentPage < pages.count - 1 ? "Continue" : "Get Started")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(AppTheme.darkGreen)
                            .frame(maxWidth: .infinity).padding(.vertical, 18)
                            .background(Color.white).cornerRadius(16)
                    }
                    
                    if currentPage > 0 {
                        Button { withAnimation { currentPage -= 1 } } label: {
                            Text("Back").font(.system(size: 16, weight: .medium)).foregroundColor(.white.opacity(0.9))
                        }.padding(.top, 8)
                    }
                }
                .padding(.horizontal, 32).padding(.bottom, 48)
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
        VStack(spacing: 24) {
            Spacer()
            ZStack {
                Circle().fill(Color.white.opacity(0.15)).frame(width: 180, height: 180)
                Circle().fill(Color.white.opacity(0.2)).frame(width: 140, height: 140)
                Text(page.icon).font(.system(size: 80))
            }.padding(.bottom, 20)
            
            Text(page.title).font(.system(size: 28, weight: .bold)).foregroundColor(.white).multilineTextAlignment(.center).padding(.horizontal, 32)
            Text(page.description).font(.system(size: 17)).foregroundColor(.white.opacity(0.9)).multilineTextAlignment(.center).lineSpacing(4).padding(.horizontal, 40)
            Spacer(); Spacer()
        }
    }
}
