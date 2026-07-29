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
                Text("Settings")
                    .font(.system(size: 34, weight: .bold, design: .rounded))
                    .foregroundColor(theme.primaryText)
                    .padding(.top, 8)
                
                settingsGroup(title: "Appearance", theme: theme) {
                    settingRow("Dark Mode", icon: "moon.fill", theme: theme) {
                        Picker("", selection: $darkModePreference) {
                            Text("System").tag("system")
                            Text("Light").tag("light")
                            Text("Dark").tag("dark")
                        }
                        .pickerStyle(MenuPickerStyle())
                    }
                }
                
                settingsGroup(title: "Preferences", theme: theme) {
                    Toggle(isOn: $notificationsEnabled) {
                        Label("Notifications", systemImage: "bell.fill")
                    }
                    Toggle(isOn: $hapticsEnabled) {
                        Label("Haptic Feedback", systemImage: "hand.tap.fill")
                    }
                }
                
                settingsGroup(title: "Account", theme: theme) {
                    navButton("Subscription", icon: "crown.fill", route: .subscription, theme: theme)
                    navButton("Privacy", icon: "hand.raised.fill", route: .privacy, theme: theme)
                    navButton("About", icon: "info.circle.fill", route: .about, theme: theme)
                }
                
                PremiumButton("Sign Out", icon: "rectangle.portrait.and.arrow.right", style: .ghost, action: {
                    appState.logout()
                })
            }
            .padding(AppTheme.padding)
        }
        .themedBackground()
        .navigationBarHidden(true)
    }
    
    private func settingsGroup<Content: View>(title: String, theme: ThemeColors, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(theme.secondaryText)
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
