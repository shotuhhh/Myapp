//
//  AppRootView.swift
//  AI Life OS
//

import SwiftUI

struct AppRootView: View {
    @EnvironmentObject var appState: AppState
    @Environment(\.colorScheme) private var colorScheme
    
    private var isAutomationTest: Bool {
        ProcessInfo.processInfo.arguments.contains("Automation Test")
    }
    
    var body: some View {
        ZStack {
            if isAutomationTest && !appState.isLoggedIn {
                NavigationView {
                    HomeView()
                }
                .transition(.opacity)
            } else if !appState.hasCompletedOnboarding {
                OnboardingScreen()
                    .transition(.opacity)
            } else if !appState.isLoggedIn {
                LoginScreen()
                    .transition(.opacity)
            } else {
                MainTabView()
                    .transition(.opacity)
            }
        }
        .animation(AppTheme.springAnimation, value: appState.hasCompletedOnboarding)
        .animation(AppTheme.springAnimation, value: appState.isLoggedIn)
    }
}
