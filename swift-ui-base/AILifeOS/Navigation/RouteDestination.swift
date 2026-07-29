//
//  RouteDestination.swift
//  AI Life OS
//

import SwiftUI

struct RouteDestination: View {
    let route: AppRoute
    
    var body: some View {
        switch route {
        case .home: HomeScreen()
        case .aiChat: AIChatScreen()
        case .voiceChat: VoiceChatScreen()
        case .memory: MemoryScreen()
        case .lifeMap: LifeMapScreen()
        case .goals: GoalsScreen()
        case .projects: ProjectsScreen()
        case .habits: HabitsScreen()
        case .calendar: CalendarScreen()
        case .insights: InsightsScreen()
        case .predictions: PredictionsScreen()
        case .analytics: AnalyticsScreen()
        case .progress: ProgressScreen()
        case .notifications: NotificationsScreen()
        case .settings: SettingsScreen()
        case .profile: ProfileScreen()
        case .search: SearchScreen()
        case .onboarding: OnboardingScreen()
        case .login: LoginScreen()
        case .subscription: SubscriptionScreen()
        case .about: AboutScreen()
        case .privacy: PrivacyScreen()
        }
    }
}

struct ScreenContainer<Content: View>: View {
    let title: String
  var showBack: Bool = true
    let content: Content
    
    @EnvironmentObject var appState: AppState
    @Environment(\.colorScheme) private var colorScheme
    
    init(title: String, showBack: Bool = true, @ViewBuilder content: () -> Content) {
        self.title = title
        self.showBack = showBack
        self.content = content()
    }
    
    var body: some View {
        let theme = colorScheme == .dark ? ThemeColors.dark : ThemeColors.light
        ZStack {
            theme.background.ignoresSafeArea()
            VStack(spacing: 0) {
                if showBack {
                    HStack {
                        Button(action: { appState.pop() }) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 17, weight: .semibold))
                                .foregroundColor(theme.primaryText)
                                .frame(width: 36, height: 36)
                                .background(theme.cardBackground)
                                .clipShape(Circle())
                        }
                        Spacer()
                    }
                    .padding(.horizontal, AppTheme.padding)
                    .padding(.top, 8)
                }
                content
            }
        }
        .navigationBarHidden(true)
    }
}
