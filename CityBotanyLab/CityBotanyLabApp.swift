//
//  CityBotanyLabApp.swift
//  CityBotanyLab
//

import SwiftUI

@main
struct CityBotanyLabApp: App {
    @StateObject private var dataManager = DataManager()
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding = false
    
    var body: some Scene {
        WindowGroup {
            if hasSeenOnboarding {
                MainTabView()
                    .environmentObject(dataManager)
            } else {
                OnboardingView(hasSeenOnboarding: $hasSeenOnboarding)
                    .environmentObject(dataManager)
            }
        }
    }
}