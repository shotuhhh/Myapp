//
//  AnalyticsScreen.swift
//  AI Life OS
//

import SwiftUI

struct AnalyticsScreen: View {
    @ObservedObject private var data = MockDataStore.shared
    @Environment(\.colorScheme) private var colorScheme
    @State private var period = "Week"
    
    var body: some View {
        let theme = colorScheme == .dark ? ThemeColors.dark : ThemeColors.light
        
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 16) {
                Text("Analytics")
                    .font(.system(size: 34, weight: .bold, design: .rounded))
                    .foregroundColor(theme.primaryText)
                    .padding(.top, 8)
                
                HStack(spacing: 8) {
                    ForEach(["Week", "Month", "Year"], id: \.self) { p in
                        Button(action: { period = p; HapticFeedback.selection() }) {
                            ChipView(text: p, isSelected: period == p)
                        }
                    }
                }
                
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                    ForEach(data.analytics) { metric in
                        StatCard(label: metric.label, value: metric.value, icon: metric.icon, change: metric.change)
                    }
                }
                
                GlassCard {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Focus Hours Trend")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(theme.primaryText)
                        chartBars(theme: theme)
                    }
                }
            }
            .padding(AppTheme.padding)
        }
        .themedBackground()
        .navigationBarHidden(true)
    }
    
    private func chartBars(theme: ThemeColors) -> some View {
        let values: [CGFloat] = [0.4, 0.65, 0.5, 0.8, 0.72, 0.9, 0.85]
        return HStack(alignment: .bottom, spacing: 8) {
            ForEach(values.indices, id: \.self) { i in
                RoundedRectangle(cornerRadius: 4)
                    .fill(
                        LinearGradient(colors: [theme.gradientStart, theme.gradientEnd], startPoint: .bottom, endPoint: .top)
                    )
                    .frame(height: 80 * values[i])
            }
        }
        .frame(height: 80)
    }
}
