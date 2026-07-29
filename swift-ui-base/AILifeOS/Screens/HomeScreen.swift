//
//  HomeScreen.swift
//  AI Life OS — AI Brain
//

import SwiftUI

struct HomeScreen: View {
    @EnvironmentObject var appState: AppState
    @ObservedObject private var data = MockDataStore.shared
    @ObservedObject private var liveAI = LiveAIActivityStore.shared
    @ObservedObject private var motion = MotionManager.shared
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        let theme = colorScheme == .dark ? ThemeColors.dark : ThemeColors.light
        
        ZStack {
            FuturisticBackground()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 16) {
                    DynamicIslandMock()
                    
                    header(theme: theme)
                    
                    // Living AI Universe
                    LivingUniverseView()
                        .frame(height: 340)
                        .padding(.horizontal, 8)
                    
                    AIActivityPanel()
                        .padding(.horizontal, AppTheme.padding)
                    
                    AIConfidenceView()
                        .padding(.horizontal, AppTheme.padding)
                    
                    moduleQuickAccess(theme: theme)
                    
                    LiveActivityMock()
                        .padding(.horizontal, AppTheme.padding)
                }
                .padding(.bottom, 24)
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            motion.start()
            liveAI.startLiveUpdates()
        }
    }
    
    private func header(theme: ThemeColors) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 6) {
                    Circle()
                        .fill(theme.success)
                        .frame(width: 8, height: 8)
                        .glow(theme.success, radius: 4)
                    Text("AI BRAIN")
                        .font(.system(size: 11, weight: .bold, design: .rounded))
                        .foregroundColor(theme.accent)
                        .tracking(2)
                }
                Text("Good morning, \(data.user.name.components(separatedBy: " ").first ?? data.user.name)")
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                    .foregroundColor(theme.primaryText)
            }
            Spacer()
            HStack(spacing: 10) {
                IconButton(icon: "magnifyingglass", action: { appState.navigate(to: .search) })
                IconButton(icon: "bell.fill", action: { appState.navigate(to: .notifications) })
            }
        }
        .padding(.horizontal, AppTheme.padding)
        .padding(.top, 4)
    }
    
    private func moduleQuickAccess(theme: ThemeColors) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader(title: "AI Modules", actionTitle: "See all", action: { appState.selectedTab = .explore })
                .padding(.horizontal, AppTheme.padding)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    moduleChip("AI DNA", icon: "dna", route: .aiDNA, theme: theme)
                    moduleChip("Memory", icon: "brain.head.profile", route: .memory, theme: theme)
                    moduleChip("World Model", icon: "globe.americas.fill", route: .lifeMap, theme: theme)
                    moduleChip("Future Sim", icon: "sparkle.magnifyingglass", route: .futureSimulation, theme: theme)
                    moduleChip("Decision", icon: "arrow.triangle.branch", route: .decisionEngine, theme: theme)
                    moduleChip("Trust", icon: "shield.checkered", route: .trustEngine, theme: theme)
                    moduleChip("Agents", icon: "person.3.fill", route: .multiAgentEngine, theme: theme)
                }
                .padding(.horizontal, AppTheme.padding)
            }
        }
    }
    
    private func moduleChip(_ title: String, icon: String, route: AppRoute, theme: ThemeColors) -> some View {
        Button(action: { appState.navigate(to: route); HapticFeedback.selection() }) {
            VStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(width: 44, height: 44)
                    .background(
                        LinearGradient(colors: [theme.gradientStart, theme.gradientEnd], startPoint: .topLeading, endPoint: .bottomTrailing)
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                    .glow(theme.accent, radius: 6, intensity: 0.4)
                Text(title)
                    .font(.system(size: 11, weight: .medium))
                    .foregroundColor(theme.primaryText)
            }
        }
        .buttonStyle(PressableButtonStyle())
    }
}
