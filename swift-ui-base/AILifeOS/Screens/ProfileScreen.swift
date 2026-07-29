//
//  ProfileScreen.swift
//  AI Life OS
//

import SwiftUI

struct ProfileScreen: View {
    @ObservedObject private var data = MockDataStore.shared
    @EnvironmentObject var appState: AppState
    @Environment(\.colorScheme) private var colorScheme
    
    private let menuRoutes: [(AppRoute, String)] = [
        (.memory, "AI Memory"),
        (.goals, "Goals"),
        (.projects, "Projects"),
        (.analytics, "Analytics"),
        (.settings, "Settings")
    ]
    
    var body: some View {
        let theme = colorScheme == .dark ? ThemeColors.dark : ThemeColors.light
        
        ScrollView(showsIndicators: false) {
            VStack(spacing: 20) {
                VStack(spacing: 16) {
                    ZStack {
                        Circle()
                            .fill(LinearGradient(colors: [theme.gradientStart, theme.gradientEnd], startPoint: .topLeading, endPoint: .bottomTrailing))
                            .frame(width: 96, height: 96)
                        Image(systemName: data.user.avatarSymbol)
                            .font(.system(size: 44))
                            .foregroundColor(.white)
                    }
                    .padding(.top, 16)
                    
                    Text(data.user.name)
                        .font(.system(size: 26, weight: .bold, design: .rounded))
                        .foregroundColor(theme.primaryText)
                    Text(data.user.email)
                        .font(.system(size: 14))
                        .foregroundColor(theme.secondaryText)
                    Text(data.user.bio)
                        .font(.system(size: 14))
                        .foregroundColor(theme.secondaryText)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    
                    HStack(spacing: 24) {
                        profileStat("\(data.user.streakDays)", label: "Streak", theme: theme)
                        profileStat("\(data.user.focusScore)", label: "Focus", theme: theme)
                        profileStat(data.user.plan, label: "Plan", theme: theme)
                    }
                }
                
                GlassCard {
                    VStack(spacing: 4) {
                        ForEach(menuRoutes, id: \.0.id) { route, title in
                            Button(action: { appState.navigate(to: route) }) {
                                NavigationRow(icon: route.icon, title: title)
                            }
                            .buttonStyle(PressableButtonStyle())
                        }
                    }
                }
                
                PremiumButton("Edit Profile", icon: "pencil", style: .secondary, action: { appState.showToast("Profile updated") })
            }
            .padding(AppTheme.padding)
        }
        .themedBackground()
        .navigationBarHidden(true)
    }
    
    private func profileStat(_ value: String, label: String, theme: ThemeColors) -> some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.system(size: 20, weight: .bold, design: .rounded))
                .foregroundColor(theme.primaryText)
            Text(label)
                .font(.system(size: 12))
                .foregroundColor(theme.secondaryText)
        }
    }
}
