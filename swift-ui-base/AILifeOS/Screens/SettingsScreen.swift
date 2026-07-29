//
//  SettingsScreen.swift
//  AI Life OS
//

import SwiftUI

struct SettingsScreen: View {
    @EnvironmentObject var appState: AppState
    @Environment(\.colorScheme) private var colorScheme
    @AppStorage("ailifeos_dark_mode") private var darkModePreference = "system"
    @AppStorage("ailifeos_notifications") private var notificationsEnabled = true
    @AppStorage("ailifeos_haptics") private var hapticsEnabled = true

    var body: some View {
        let theme = colorScheme == .dark ? ThemeColors.dark : ThemeColors.light

        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 16) {
                ModuleHeader(title: "Settings", subtitle: "Preferences & account", icon: "gearshape.fill")

                settingsGroup(title: "Appearance") {
                    settingRow("Dark Mode", icon: "moon.fill", theme: theme) {
                        Picker("", selection: $darkModePreference) {
                            Text("System").tag("system")
                            Text("Light").tag("light")
                            Text("Dark").tag("dark")
                        }
                        .pickerStyle(MenuPickerStyle())
                        .accentColor(theme.accent)
                    }
                }

                settingsGroup(title: "Preferences") {
                    Toggle(isOn: $notificationsEnabled) {
                        Label("Notifications", systemImage: "bell.fill")
                            .foregroundColor(theme.primaryText)
                    }
                    .tint(theme.accent)
                    Toggle(isOn: $hapticsEnabled) {
                        Label("Haptic Feedback", systemImage: "hand.tap.fill")
                            .foregroundColor(theme.primaryText)
                    }
                    .tint(theme.accent)
                }

                settingsGroup(title: "AI & Privacy") {
                    navButton("Security & Privacy", icon: "lock.shield.fill", route: .security, theme: theme)
                    navButton("Integrations", icon: "puzzlepiece.extension.fill", route: .integrations, theme: theme)
                    navButton("AI DNA", icon: "dna", route: .aiDNA, theme: theme)
                }

                settingsGroup(title: "Account") {
                    navButton("Subscription", icon: "crown.fill", route: .subscription, theme: theme)
                    navButton("Privacy Policy", icon: "hand.raised.fill", route: .privacy, theme: theme)
                    navButton("About AI Life OS", icon: "info.circle.fill", route: .about, theme: theme)
                }

                PremiumButton("Sign Out", icon: "rectangle.portrait.and.arrow.right", style: .ghost, action: {
                    appState.logout()
                })
            }
            .padding(AppTheme.padding)
        }
        .futuristicBackground()
        .navigationBarHidden(true)
    }

    private func settingsGroup<Content: View>(title: String, @ViewBuilder content: () -> Content) -> some View {
        let theme = colorScheme == .dark ? ThemeColors.dark : ThemeColors.light
        return VStack(alignment: .leading, spacing: 8) {
            Text(title.uppercased())
                .font(.system(size: 11, weight: .semibold))
                .foregroundColor(theme.tertiaryText)
                .tracking(1)
            GlassCard {
                VStack(spacing: 12) {
                    content()
                }
            }
        }
    }

    private func settingRow<Trailing: View>(_ title: String, icon: String, theme: ThemeColors, @ViewBuilder trailing: () -> Trailing) -> some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(theme.accent)
            Text(title)
                .foregroundColor(theme.primaryText)
            Spacer()
            trailing()
        }
    }

    private func navButton(_ title: String, icon: String, route: AppRoute, theme: ThemeColors) -> some View {
        Button(action: { appState.navigate(to: route) }) {
            NavigationRow(icon: icon, title: title)
        }
        .buttonStyle(PressableButtonStyle())
    }
}
