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
    
    private let coreModules: [AppRoute] = [
        .aiDNA, .memory, .lifeMap, .futureSimulation, .decisionEngine,
        .knowledgeFusion, .trustEngine, .multiAgentEngine, .lifeOSOrchestrator
    ]
    
    private let intelligenceModules: [AppRoute] = [
        .curiosityEngine, .goalEvolution, .selfEvolution, .personality,
        .hiddenRelations, .learning, .adaptation
    ]
    
    private let lifeModules: [AppRoute] = [
        .goals, .projects, .habits, .calendar, .planning, .integrations, .security
    ]
    
    var body: some View {
        let theme = colorScheme == .dark ? ThemeColors.dark : ThemeColors.light
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 24) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("AI Modules")
                        .font(.system(size: 34, weight: .bold, design: .rounded))
                        .foregroundColor(theme.primaryText)
                    Text("Your living AI operating system")
                        .font(.system(size: 15))
                        .foregroundColor(theme.secondaryText)
                }
                .padding(.top, 8)
                
                AIActivityPanel()
                
                moduleSection(title: "Core AI Engines", routes: coreModules, theme: theme)
                moduleSection(title: "Intelligence", routes: intelligenceModules, theme: theme)
                moduleSection(title: "Life Domains", routes: lifeModules, theme: theme)
            }
            .padding(AppTheme.padding)
        }
        .futuristicBackground()
        .navigationBarHidden(true)
    }
    
    private func moduleSection(title: String, routes: [AppRoute], theme: ThemeColors) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.system(size: 18, weight: .semibold, design: .rounded))
                .foregroundColor(theme.primaryText)
            
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                ForEach(routes, id: \.id) { route in
                    Button(action: { appState.navigate(to: route); HapticFeedback.selection() }) {
                        VStack(spacing: 10) {
                            Image(systemName: route.icon)
                                .font(.system(size: 24, weight: .semibold))
                                .foregroundColor(theme.accent)
                                .frame(width: 48, height: 48)
                                .background(theme.accent.opacity(0.12))
                                .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                                .glow(theme.accent, radius: 4, intensity: 0.3)
                            Text(route.title)
                                .font(.system(size: 12, weight: .semibold, design: .rounded))
                                .foregroundColor(theme.primaryText)
                                .lineLimit(2)
                                .multilineTextAlignment(.center)
                                .minimumScaleFactor(0.8)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .glassSurface(cornerRadius: 16)
                    }
                    .buttonStyle(PressableButtonStyle())
                }
            }
        }
    }
}

struct InsightsHubScreen: View {
    @EnvironmentObject var appState: AppState
    @Environment(\.colorScheme) private var colorScheme
    
    private let routes: [AppRoute] = [.insights, .predictions, .analytics, .progress, .hiddenRelations, .futureSimulation]
    
    var body: some View {
        let theme = colorScheme == .dark ? ThemeColors.dark : ThemeColors.light
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 20) {
                Text("Insights")
                    .font(.system(size: 34, weight: .bold, design: .rounded))
                    .foregroundColor(theme.primaryText)
                    .padding(.top, 8)
                
                AIConfidenceView()
                
                ForEach(routes, id: \.id) { route in
                    Button(action: { appState.navigate(to: route) }) {
                        NavigationRow(icon: route.icon, title: route.title, subtitle: route.subtitle)
                            .padding(12)
                            .glassSurface(cornerRadius: 14)
                    }
                    .buttonStyle(PressableButtonStyle())
                }
            }
            .padding(AppTheme.padding)
        }
        .futuristicBackground()
        .navigationBarHidden(true)
    }
}
