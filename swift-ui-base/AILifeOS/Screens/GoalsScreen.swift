//
//  GoalsScreen.swift
//  AI Life OS
//

import SwiftUI

struct GoalsScreen: View {
    @ObservedObject private var data = MockDataStore.shared
    @EnvironmentObject var appState: AppState
    @Environment(\.colorScheme) private var colorScheme
    @State private var animateProgress = false

    var body: some View {
        let theme = colorScheme == .dark ? ThemeColors.dark : ThemeColors.light

        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 16) {
                ModuleHeader(title: "Goals", subtitle: "\(data.goals.count) active · AI-tracked", icon: "target")

                // Summary ring row
                GlassCard {
                    HStack(spacing: 20) {
                        ForEach(data.goals) { goal in
                            ProgressRing(
                                progress: animateProgress ? goal.progress : 0,
                                label: goal.category,
                                size: 68
                            )
                        }
                    }
                    .frame(maxWidth: .infinity)
                }

                ForEach(data.goals) { goal in
                    GlassCard {
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Text(goal.title)
                                    .font(.system(size: 18, weight: .semibold, design: .rounded))
                                    .foregroundColor(theme.primaryText)
                                Spacer()
                                ChipView(text: goal.category, isSelected: true)
                            }
                            Text(goal.description)
                                .font(.system(size: 14))
                                .foregroundColor(theme.secondaryText)

                            GeometryReader { g in
                                ZStack(alignment: .leading) {
                                    Capsule()
                                        .fill(theme.border.opacity(0.3))
                                        .frame(height: 7)
                                    Capsule()
                                        .fill(LinearGradient(
                                            colors: [theme.gradientStart, theme.gradientEnd],
                                            startPoint: .leading, endPoint: .trailing))
                                        .frame(width: animateProgress ? g.size.width * CGFloat(goal.progress) : 0, height: 7)
                                        .glow(theme.accent, radius: 4, intensity: 0.35)
                                }
                            }
                            .frame(height: 7)

                            HStack {
                                Text("\(Int(goal.progress * 100))% complete")
                                    .font(.system(size: 13, weight: .semibold))
                                    .foregroundColor(theme.accent)
                                Spacer()
                                Text("Due \(formatDate(goal.deadline))")
                                    .font(.system(size: 13))
                                    .foregroundColor(theme.secondaryText)
                            }

                            VStack(alignment: .leading, spacing: 6) {
                                ForEach(goal.milestones, id: \.self) { milestone in
                                    HStack(spacing: 8) {
                                        Image(systemName: "checkmark.circle")
                                            .font(.system(size: 13))
                                            .foregroundColor(theme.accent.opacity(0.7))
                                        Text(milestone)
                                            .font(.system(size: 13))
                                            .foregroundColor(theme.secondaryText)
                                    }
                                }
                            }
                        }
                    }
                    .fadeIn()
                }

                PremiumButton("New Goal", icon: "plus", action: { appState.showToast("Goal created") })
            }
            .padding(AppTheme.padding)
        }
        .futuristicBackground()
        .navigationBarHidden(true)
        .onAppear {
            withAnimation(.spring(response: 1.0, dampingFraction: 0.8).delay(0.2)) {
                animateProgress = true
            }
        }
    }

    private func formatDate(_ date: Date) -> String {
        let f = DateFormatter(); f.dateStyle = .medium
        return f.string(from: date)
    }
}
