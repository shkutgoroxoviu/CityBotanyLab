//
//  AppTheme.swift
//  CityBotanyLab
//

import SwiftUI

struct AppTheme {
    static let primaryGreen = Color(red: 0.18, green: 0.55, blue: 0.34)
    static let darkGreen = Color(red: 0.10, green: 0.35, blue: 0.22)
    static let lightGreen = Color(red: 0.56, green: 0.78, blue: 0.63)
    static let paleGreen = Color(red: 0.85, green: 0.94, blue: 0.88)
    static let mintGreen = Color(red: 0.68, green: 0.88, blue: 0.78)
    static let forestGreen = Color(red: 0.13, green: 0.29, blue: 0.18)
    
    static let accentPink = Color(red: 0.94, green: 0.45, blue: 0.65)
    static let lightPink = Color(red: 1.0, green: 0.75, blue: 0.83)
    static let softPink = Color(red: 0.98, green: 0.88, blue: 0.91)
    static let rosePink = Color(red: 0.87, green: 0.36, blue: 0.51)
    
    static let background = Color(red: 0.98, green: 0.98, blue: 0.97)
    static let cardBackground = Color.white
    static let textPrimary = Color(red: 0.15, green: 0.20, blue: 0.18)
    static let textSecondary = Color(red: 0.45, green: 0.50, blue: 0.47)
    
    static let primaryGradient = LinearGradient(
        colors: [darkGreen, primaryGreen],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let accentGradient = LinearGradient(
        colors: [accentPink, rosePink],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let softGradient = LinearGradient(
        colors: [paleGreen, mintGreen.opacity(0.5)],
        startPoint: .top,
        endPoint: .bottom
    )
    
    static let onboardingGradient = LinearGradient(
        colors: [darkGreen.opacity(0.9), primaryGreen, lightGreen.opacity(0.8)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}

struct CardStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(AppTheme.cardBackground)
            .cornerRadius(16)
            .shadow(color: AppTheme.darkGreen.opacity(0.08), radius: 8, x: 0, y: 4)
    }
}

struct PrimaryButtonStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: 17, weight: .semibold))
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(AppTheme.primaryGradient)
            .cornerRadius(14)
    }
}

struct AccentButtonStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: 17, weight: .semibold))
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(AppTheme.accentGradient)
            .cornerRadius(14)
    }
}

struct TagStyle: ViewModifier {
    let color: Color
    
    func body(content: Content) -> some View {
        content
            .font(.system(size: 12, weight: .medium))
            .foregroundColor(color)
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .background(color.opacity(0.15))
            .cornerRadius(8)
    }
}

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
    
    func tagStyle(color: Color = AppTheme.primaryGreen) -> some View {
        modifier(TagStyle(color: color))
    }
}
