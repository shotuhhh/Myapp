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
        case .aiChat, .assistant: AIChatScreen()
        case .voiceChat: VoiceChatScreen()
        case .memory: MemoryScreen()
        case .lifeMap, .worldModel: LifeMapScreen()
        case .goals: GoalsScreen()
        case .projects: ProjectsScreen()
        case .habits: HabitsScreen()
        case .calendar, .planning: PlanningScreen()
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
        case .aiDNA: AIDNAScreen()
        case .futureSimulation: FutureSimulationScreen()
        case .decisionEngine: DecisionEngineScreen()
        case .curiosityEngine: CuriosityEngineScreen()
        case .goalEvolution: GoalEvolutionScreen()
        case .multiAgentEngine: MultiAgentEngineScreen()
        case .knowledgeFusion: KnowledgeFusionScreen()
        case .selfEvolution: SelfEvolutionScreen()
        case .trustEngine: TrustEngineScreen()
        case .lifeOSOrchestrator: LifeOSOrchestratorScreen()
        case .personality: PersonalityScreen()
        case .learning: LearningScreen()
        case .adaptation: AdaptationScreen()
        case .hiddenRelations: HiddenRelationsScreen()
        case .integrations: IntegrationsScreen()
        case .security: SecurityScreen()
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
            FuturisticBackground()
            VStack(spacing: 0) {
                if showBack {
                    HStack {
                        Button(action: { appState.pop() }) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 17, weight: .semibold))
                                .foregroundColor(theme.primaryText)
                                .frame(width: 36, height: 36)
                                .glassSurface(cornerRadius: 18)
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
