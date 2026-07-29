//
//  InsightsScreen.swift
//  AI Life OS
//

import SwiftUI

struct InsightsScreen: View {
    @ObservedObject private var data = MockDataStore.shared
    @EnvironmentObject var appState: AppState
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        let theme = colorScheme == .dark ? ThemeColors.dark : ThemeColors.light

        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 16) {
                ModuleHeader(title: "Analysis", subtitle: "AI-generated life insights", icon: "lightbulb.fill")

                // Live AI badge
                LiveActivityMock()

                ForEach(data.insights) { insight in
                    GlassCard {
                        VStack(alignment: .leading, spacing: 10) {
                            HStack {
                                Image(systemName: "lightbulb.fill")
                                    .foregroundColor(theme.warning)
                                    .glow(theme.warning, radius: 4, intensity: 0.4)
                                Text(insight.category)
                                    .font(.system(size: 11, weight: .bold))
                                    .foregroundColor(theme.accent)
                                    .tracking(1)
                                Spacer()
                                impactBadge(insight.impact, theme: theme)
                            }
                            Text(insight.title)
                                .font(.system(size: 17, weight: .semibold, design: .rounded))
                                .foregroundColor(theme.primaryText)
                            Text(insight.body)
                                .font(.system(size: 14))
                                .foregroundColor(theme.secondaryText)
                            Text(insight.date, style: .relative)
                                .font(.system(size: 11))
                                .foregroundColor(theme.tertiaryText)
                        }
                    }
                    .fadeIn()
                }

                PremiumButton("Generate Insight", icon: "sparkles", action: {
                    appState.showToast("New insight ready")
                })
            }
            .padding(AppTheme.padding)
        }
        .futuristicBackground()
        .navigationBarHidden(true)
    }

    private func impactBadge(_ impact: String, theme: ThemeColors) -> some View {
        let color: Color = impact == "High" ? theme.success : theme.accent
        return Text(impact)
            .font(.system(size: 10, weight: .bold))
            .foregroundColor(color)
            .padding(.horizontal, 8)
            .padding(.vertical, 3)
            .background(color.opacity(0.15))
            .clipShape(Capsule())
    }
}
