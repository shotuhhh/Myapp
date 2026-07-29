//
//  AboutScreen.swift
//  AI Life OS
//

import SwiftUI

struct AboutScreen: View {
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        let theme = colorScheme == .dark ? ThemeColors.dark : ThemeColors.light
        
        ScrollView(showsIndicators: false) {
            VStack(spacing: 24) {
                ZStack {
                    BreathingGlow(color: theme.accent, size: 150)
                    Circle()
                        .fill(LinearGradient(colors: [theme.gradientStart, theme.gradientEnd], startPoint: .topLeading, endPoint: .bottomTrailing))
                        .frame(width: 100, height: 100)
                        .glow(theme.accent, radius: 14, intensity: 0.5)
                    Image(systemName: "sparkles")
                        .font(.system(size: 44, weight: .semibold))
                        .foregroundColor(.white)
                }
                .frame(height: 170)
                .padding(.top, 8)

                Text("AI Life OS")
                    .font(.system(size: 30, weight: .bold, design: .rounded))
                    .foregroundColor(theme.primaryText)
                Text("Version 1.0.0 (Build 1)")
                    .font(.system(size: 14))
                    .foregroundColor(theme.secondaryText)
                
                GlassCard {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("About")
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundColor(theme.primaryText)
                        Text("AI Life OS is a premium life management prototype that helps you organize goals, habits, projects, and insights with an intelligent AI companion.")
                            .font(.system(size: 15))
                            .foregroundColor(theme.secondaryText)
                        Text("Built with SwiftUI following Apple Human Interface Guidelines.")
                            .font(.system(size: 14))
                            .foregroundColor(theme.secondaryText)
                    }
                }
                
                GlassCard {
                    VStack(alignment: .leading, spacing: 8) {
                        infoRow("Developer", "AI Life OS Team", theme: theme)
                        infoRow("Platform", "iOS 16+", theme: theme)
                        infoRow("License", "Prototype UI Demo", theme: theme)
                    }
                }
            }
            .padding(AppTheme.padding)
        }
        .futuristicBackground()
        .navigationBarHidden(true)
    }
    
    private func infoRow(_ label: String, _ value: String, theme: ThemeColors) -> some View {
        HStack {
            Text(label)
                .foregroundColor(theme.secondaryText)
            Spacer()
            Text(value)
                .foregroundColor(theme.primaryText)
        }
        .font(.system(size: 14))
    }
}
