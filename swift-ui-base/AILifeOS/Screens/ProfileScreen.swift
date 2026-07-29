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
        (.aiDNA, "AI DNA"),
        (.memory, "Universal Memory"),
        (.personality, "Personality"),
        (.goals, "Goals"),
        (.integrations, "Integrations"),
        (.security, "Security"),
        (.settings, "Settings")
    ]

    var body: some View {
        let theme = colorScheme == .dark ? ThemeColors.dark : ThemeColors.light

        ScrollView(showsIndicators: false) {
            VStack(spacing: 20) {
                avatarSection(theme: theme)

                // AI DNA preview
                GlassCard(padding: 14) {
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Image(systemName: "dna")
                                .foregroundColor(theme.accent)
                            Text("AI DNA — Top Traits")
                                .font(.system(size: 13, weight: .semibold))
                                .foregroundColor(theme.accent)
                            Spacer()
                            Button("View all") { appState.navigate(to: .aiDNA) }
                                .font(.system(size: 12, weight: .semibold))
                                .foregroundColor(theme.secondaryText)
                        }
                        ForEach(data.aiDNATraits.prefix(3)) { trait in
                            HStack {
                                Text(trait.name)
                                    .font(.system(size: 13, weight: .medium))
                                    .foregroundColor(theme.primaryText)
                                Spacer()
                                Text("\(Int(trait.value * 100))%")
                                    .font(.system(size: 13, weight: .bold, design: .monospaced))
                                    .foregroundColor(theme.accent)
                            }
                        }
                    }
                }

                GlassCard {
                    VStack(spacing: 4) {
                        ForEach(menuRoutes, id: \.0.id) { route, title in
                            Button(action: { appState.navigate(to: route) }) {
                                NavigationRow(icon: route.icon, title: title, subtitle: route.subtitle)
                            }
                            .buttonStyle(PressableButtonStyle())
                        }
                    }
                }

                PremiumButton("Edit Profile", icon: "pencil", style: .secondary, action: {
                    appState.showToast("Profile updated")
                })
                PremiumButton("Sign Out", icon: "rectangle.portrait.and.arrow.right", style: .ghost, action: {
                    appState.logout()
                })
            }
            .padding(AppTheme.padding)
        }
        .futuristicBackground()
        .navigationBarHidden(true)
    }

    private func avatarSection(theme: ThemeColors) -> some View {
        VStack(spacing: 14) {
            ZStack {
                BreathingGlow(color: theme.accent, size: 140)
                Circle()
                    .fill(LinearGradient(
                        colors: [theme.gradientStart, theme.gradientEnd],
                        startPoint: .topLeading, endPoint: .bottomTrailing
                    ))
                    .frame(width: 96, height: 96)
                    .glow(theme.accent, radius: 12, intensity: 0.5)
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
                .padding(.horizontal, 24)

            HStack(spacing: 28) {
                profileStat("\(data.user.streakDays)d", label: "Streak", theme: theme)
                profileStat("\(data.user.focusScore)", label: "Focus", theme: theme)
                profileStat(data.user.plan, label: "Plan", theme: theme)
            }
            .padding(.vertical, 12)
            .padding(.horizontal, 20)
            .glassSurface(cornerRadius: 16)
        }
    }

    private func profileStat(_ value: String, label: String, theme: ThemeColors) -> some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.system(size: 20, weight: .bold, design: .rounded))
                .foregroundColor(theme.primaryText)
            Text(label)
                .font(.system(size: 11, weight: .medium))
                .foregroundColor(theme.secondaryText)
        }
    }
}
