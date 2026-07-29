//
//  AppTheme.swift
//  AI Life OS
//

import SwiftUI

enum AppTheme {
    static let cornerRadius: CGFloat = 16
    static let cardRadius: CGFloat = 20
    static let smallRadius: CGFloat = 12
    static let padding: CGFloat = 16
    static let spacing: CGFloat = 12
    
    static let springAnimation = Animation.spring(response: 0.35, dampingFraction: 0.82)
    static let quickAnimation = Animation.easeOut(duration: 0.22)
}

struct ThemeColors {
    let accent: Color
    let accentSecondary: Color
    let background: Color
    let cardBackground: Color
    let elevatedBackground: Color
    let primaryText: Color
    let secondaryText: Color
    let tertiaryText: Color
    let success: Color
    let warning: Color
    let error: Color
    let border: Color
    let gradientStart: Color
    let gradientEnd: Color
    
    static let light = ThemeColors(
        accent: Color("AccentPrimary"),
        accentSecondary: Color("AccentSecondary"),
        background: Color(UIColor.systemGroupedBackground),
        cardBackground: Color(UIColor.secondarySystemGroupedBackground),
        elevatedBackground: Color(UIColor.systemBackground),
        primaryText: Color(UIColor.label),
        secondaryText: Color(UIColor.secondaryLabel),
        tertiaryText: Color(UIColor.tertiaryLabel),
        success: Color("SuccessGreen"),
        warning: Color("WarningOrange"),
        error: Color("ErrorRed"),
        border: Color(UIColor.separator).opacity(0.35),
        gradientStart: Color("AccentPrimary"),
        gradientEnd: Color("AccentSecondary")
    )
    
    static let dark = ThemeColors(
        accent: Color("AccentPrimary"),
        accentSecondary: Color("AccentSecondary"),
        background: Color(UIColor.systemGroupedBackground),
        cardBackground: Color(UIColor.secondarySystemGroupedBackground),
        elevatedBackground: Color(UIColor.systemBackground),
        primaryText: Color(UIColor.label),
        secondaryText: Color(UIColor.secondaryLabel),
        tertiaryText: Color(UIColor.tertiaryLabel),
        success: Color("SuccessGreen"),
        warning: Color("WarningOrange"),
        error: Color("ErrorRed"),
        border: Color(UIColor.separator).opacity(0.35),
        gradientStart: Color("AccentPrimary"),
        gradientEnd: Color("AccentSecondary")
    )
}

private struct ThemeColorsKey: EnvironmentKey {
    static let defaultValue = ThemeColors.light
}

extension EnvironmentValues {
    var theme: ThemeColors {
        get { self[ThemeColorsKey.self] }
        set { self[ThemeColorsKey.self] = newValue }
    }
}

struct ThemedBackground: ViewModifier {
    @Environment(\.colorScheme) private var colorScheme
    
    func body(content: Content) -> some View {
        content
            .background(
                (colorScheme == .dark ? ThemeColors.dark : ThemeColors.light).background
                    .ignoresSafeArea()
            )
    }
}

extension View {
    func themedBackground() -> some View {
        modifier(ThemedBackground())
    }
    
    func appCardStyle(theme: ThemeColors) -> some View {
        self
            .padding(AppTheme.padding)
            .background(
                RoundedRectangle(cornerRadius: AppTheme.cardRadius, style: .continuous)
                    .fill(theme.cardBackground)
                    .shadow(color: Color.black.opacity(0.06), radius: 12, x: 0, y: 4)
            )
    }
}
