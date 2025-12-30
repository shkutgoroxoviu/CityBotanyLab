//
//  AppTheme.swift
//  CityBotanyLab
//

import SwiftUI

struct AppTheme {
    // Primary Colors
    static let primaryGreen = Color(red: 0.18, green: 0.55, blue: 0.34)
    static let primaryGreenLight = Color(red: 0.25, green: 0.65, blue: 0.42)
    static let primaryGreenDark = Color(red: 0.12, green: 0.42, blue: 0.26)
    
    // Accent Colors
    static let accentPink = Color(red: 0.94, green: 0.45, blue: 0.65)
    static let accentPinkLight = Color(red: 0.97, green: 0.60, blue: 0.75)
    
    // Background Colors
    static let background = Color(red: 0.96, green: 0.97, blue: 0.95)
    static let cardBackground = Color.white
    
    // Text Colors
    static let textPrimary = Color(red: 0.15, green: 0.20, blue: 0.18)
    static let textSecondary = Color(red: 0.45, green: 0.50, blue: 0.48)
    
    // Gradients
    static let primaryGradient = LinearGradient(
        colors: [primaryGreen, primaryGreenLight],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let onboardingGradient = LinearGradient(
        colors: [
            Color(red: 0.95, green: 0.97, blue: 0.94),
            Color(red: 0.90, green: 0.95, blue: 0.92)
        ],
        startPoint: .top,
        endPoint: .bottom
    )
}

// MARK: - View Modifiers

struct CardStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(AppTheme.cardBackground)
            .cornerRadius(16)
            .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 2)
    }
}

struct PrimaryButtonStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.headline)
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 56)
            .background(AppTheme.primaryGreen)
            .cornerRadius(16)
    }
}

struct AccentButtonStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.subheadline)
            .fontWeight(.medium)
            .foregroundColor(AppTheme.accentPink)
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
            .background(AppTheme.accentPink.opacity(0.12))
            .cornerRadius(12)
    }
}

struct TagStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.caption)
            .foregroundColor(AppTheme.textSecondary)
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .background(AppTheme.background)
            .cornerRadius(8)
    }
}

// MARK: - View Extensions

extension View {
    func cardStyle() -> some View {
        modifier(CardStyle())
    }
    
    func primaryButtonStyle() -> some View {
        modifier(PrimaryButtonStyle())
    }
    
    func accentButtonStyle() -> some View {
        modifier(AccentButtonStyle())
    }
    
    func tagStyle() -> some View {
        modifier(TagStyle())
    }
}