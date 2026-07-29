//
//  AnalyticsScreen.swift
//  AI Life OS
//

import SwiftUI

struct AnalyticsScreen: View {
    @ObservedObject private var data = MockDataStore.shared
    @Environment(\.colorScheme) private var colorScheme
    @State private var period = "Week"
    @State private var animateBars = false

    private let barValues: [CGFloat] = [0.4, 0.65, 0.5, 0.8, 0.72, 0.9, 0.85]
    private let dayLabels = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]

    var body: some View {
        let theme = colorScheme == .dark ? ThemeColors.dark : ThemeColors.light

        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 16) {
                ModuleHeader(title: "Analytics", subtitle: "Patterns & performance", icon: "chart.bar.fill")

                // Period selector
                HStack(spacing: 8) {
                    ForEach(["Week", "Month", "Year"], id: \.self) { p in
                        Button(action: { period = p; HapticFeedback.selection() }) {
                            ChipView(text: p, isSelected: period == p)
                        }
                    }
                }

                // Metrics grid
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                    ForEach(data.analytics) { metric in
                        StatCard(
                            label: metric.label,
                            value: metric.value,
                            icon: metric.icon,
                            change: metric.change
                        )
                    }
                }

                // Chart card
                GlassCard {
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Text("Focus Hours")
                                .font(.system(size: 15, weight: .semibold, design: .rounded))
                                .foregroundColor(theme.primaryText)
                            Spacer()
                            Text(period)
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(theme.accent)
                        }

                        HStack(alignment: .bottom, spacing: 6) {
                            ForEach(barValues.indices, id: \.self) { i in
                                VStack(spacing: 4) {
                                    RoundedRectangle(cornerRadius: 5, style: .continuous)
                                        .fill(LinearGradient(
                                            colors: [theme.gradientStart, theme.gradientEnd],
                                            startPoint: .bottom, endPoint: .top
                                        ))
                                        .frame(height: animateBars ? 90 * barValues[i] : 0)
                                        .glow(theme.accent, radius: 3, intensity: 0.25)
                                    Text(dayLabels[i])
                                        .font(.system(size: 9, weight: .medium))
                                        .foregroundColor(theme.tertiaryText)
                                }
                                .frame(maxWidth: .infinity)
                            }
                        }
                        .frame(height: 100)
                        .animation(.spring(response: 0.8, dampingFraction: 0.75).delay(0.1), value: animateBars)
                    }
                }

                // AI summary
                GlassCard(padding: 12) {
                    HStack(spacing: 10) {
                        Image(systemName: "sparkles")
                            .foregroundColor(theme.accent)
                        VStack(alignment: .leading, spacing: 2) {
                            Text("AI Insight")
                                .font(.system(size: 11, weight: .bold))
                                .foregroundColor(theme.accent)
                            Text("Friday is your most productive day — 90% of weekly output")
                                .font(.system(size: 13))
                                .foregroundColor(theme.primaryText)
                        }
                    }
                }
            }
            .padding(AppTheme.padding)
        }
        .futuristicBackground()
        .navigationBarHidden(true)
        .onAppear {
            withAnimation(.spring(response: 0.9, dampingFraction: 0.8).delay(0.15)) {
                animateBars = true
            }
        }
    }
}
