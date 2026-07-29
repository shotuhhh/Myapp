//
//  MainTabView.swift
//  AI Life OS
//

import SwiftUI

struct MainTabView: View {
    @EnvironmentObject var appState: AppState
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        let theme = colorScheme == .dark ? ThemeColors.dark : ThemeColors.light
        
        ZStack(alignment: .bottom) {
            TabView(selection: $appState.selectedTab) {
                NavigationStack(path: $appState.navigationPath) {
                    HomeScreen()
                        .navigationDestination(for: AppRoute.self) { route in
                            RouteDestination(route: route)
                        }
                }
                .tabItem {
                    Label(MainTab.home.title, systemImage: MainTab.home.icon)
                }
                .tag(MainTab.home)
                
                NavigationStack {
                    AIChatScreen()
                }
                .tabItem {
                    Label(MainTab.chat.title, systemImage: MainTab.chat.icon)
                }
                .tag(MainTab.chat)
                
                NavigationStack(path: $appState.navigationPath) {
                    ExploreHubScreen()
                        .navigationDestination(for: AppRoute.self) { route in
                            RouteDestination(route: route)
                        }
                }
                .tabItem {
                    Label(MainTab.explore.title, systemImage: MainTab.explore.icon)
                }
                .tag(MainTab.explore)
                
                NavigationStack(path: $appState.navigationPath) {
                    InsightsHubScreen()
                        .navigationDestination(for: AppRoute.self) { route in
                            RouteDestination(route: route)
                        }
                }
                .tabItem {
                    Label(MainTab.insights.title, systemImage: MainTab.insights.icon)
                }
                .tag(MainTab.insights)
                
                NavigationStack(path: $appState.navigationPath) {
                    ProfileScreen()
                        .navigationDestination(for: AppRoute.self) { route in
                            RouteDestination(route: route)
                        }
                }
                .tabItem {
                    Label(MainTab.profile.title, systemImage: MainTab.profile.icon)
                }
                .tag(MainTab.profile)
            }
            
            if appState.showSuccessToast {
                VStack {
                    SuccessBanner(message: appState.toastMessage)
                        .transition(.move(edge: .top).combined(with: .opacity))
                        .padding(.top, 50)
                    Spacer()
                }
                .zIndex(100)
            }
        }
        .accentColor(theme.accent)
    }
}

struct ExploreHubScreen: View {
    @EnvironmentObject var appState: AppState
    @Environment(\.colorScheme) private var colorScheme
    
    private let routes: [AppRoute] = [.lifeMap, .goals, .projects, .habits, .calendar, .memory]
    
    var body: some View {
        let theme = colorScheme == .dark ? ThemeColors.dark : ThemeColors.light
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 20) {
                Text("Explore")
                    .font(.system(size: 34, weight: .bold, design: .rounded))
                    .foregroundColor(theme.primaryText)
                    .padding(.top, 8)
                
                Text("Your life at a glance")
                    .font(.system(size: 15))
                    .foregroundColor(theme.secondaryText)
                
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                    ForEach(routes, id: \.id) { route in
                        Button(action: { appState.navigate(to: route) }) {
                            VStack(spacing: 12) {
                                Image(systemName: route.icon)
                                    .font(.system(size: 28, weight: .semibold))
                                    .foregroundColor(theme.accent)
                                Text(route.title)
                                    .font(.system(size: 14, weight: .semibold, design: .rounded))
                                    .foregroundColor(theme.primaryText)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 24)
                            .background(
                                RoundedRectangle(cornerRadius: AppTheme.cardRadius, style: .continuous)
                                    .fill(theme.cardBackground)
                            )
                        }
                        .buttonStyle(PressableButtonStyle())
                    }
                }
            }
            .padding(AppTheme.padding)
        }
        .themedBackground()
        .navigationBarHidden(true)
    }
}

struct InsightsHubScreen: View {
    @EnvironmentObject var appState: AppState
    @Environment(\.colorScheme) private var colorScheme
    
    private let routes: [AppRoute] = [.insights, .predictions, .analytics, .progress]
    
    var body: some View {
        let theme = colorScheme == .dark ? ThemeColors.dark : ThemeColors.light
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 20) {
                Text("Insights")
                    .font(.system(size: 34, weight: .bold, design: .rounded))
                    .foregroundColor(theme.primaryText)
                    .padding(.top, 8)
                
                ForEach(routes, id: \.id) { route in
                    Button(action: { appState.navigate(to: route) }) {
                        NavigationRow(icon: route.icon, title: route.title, subtitle: "View details")
                    }
                    .buttonStyle(PressableButtonStyle())
                }
            }
            .padding(AppTheme.padding)
        }
        .themedBackground()
        .navigationBarHidden(true)
    }
}
