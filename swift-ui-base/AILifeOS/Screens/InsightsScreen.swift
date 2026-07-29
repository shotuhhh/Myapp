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
                Text("Insights")
                    .font(.system(size: 34, weight: .bold, design: .rounded))
                    .foregroundColor(theme.primaryText)
                    .padding(.top, 8)
                
                ForEach(data.insights) { insight in
                    GlassCard {
                        VStack(alignment: .leading, spacing: 10) {
                            HStack {
                                Image(systemName: "lightbulb.fill")
                                    .foregroundColor(theme.warning)
                                Text(insight.category)
                                    .font(.system(size: 12, weight: .bold))
                                    .foregroundColor(theme.accent)
                                Spacer()
                                impactBadge(insight.impact, theme: theme)
                            }
                            Text(insight.title)
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(theme.primaryText)
                            Text(insight.body)
                                .font(.system(size: 14))
                                .foregroundColor(theme.secondaryText)
                        }
                    }
                }
                
                PremiumButton("Generate Insight", icon: "sparkles", action: { appState.showToast("New insight ready") })
            }
            .padding(AppTheme.padding)
        }
        .themedBackground()
        .navigationBarHidden(true)
    }
    
    private func impactBadge(_ impact: String, theme: ThemeColors) -> some View {
        Text(impact)
            .font(.system(size: 11, weight: .bold))
            .foregroundColor(theme.success)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(theme.success.opacity(0.15))
            .clipShape(Capsule())
    }
}
