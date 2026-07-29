//
//  ProgressScreen.swift
//  AI Life OS
//

import SwiftUI

struct ProgressScreen: View {
    @ObservedObject private var data = MockDataStore.shared
    @Environment(\.colorScheme) private var colorScheme
    @State private var animateRings = false

    var body: some View {
        let theme = colorScheme == .dark ? ThemeColors.dark : ThemeColors.light

        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 16) {
                ModuleHeader(title: "Progress", subtitle: "Life area scores · AI-tracked", icon: "chart.pie.fill")

                // Ring overview
                GlassCard {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Life Balance")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(theme.accent)
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 16) {
                                ForEach(data.progressAreas) { area in
                                    ProgressRing(
                                        progress: animateRings ? Double(area.score) / 100 : 0,
                                        label: area.area,
                                        size: 68
                                    )
                                }
                            }
                        }
                    }
                }

                ForEach(data.progressAreas) { area in
                    GlassCard(padding: 14) {
                        HStack(spacing: 14) {
                            Image(systemName: area.icon)
                                .font(.system(size: 18))
                                .foregroundColor(theme.accent)
                                .frame(width: 42, height: 42)
                                .background(theme.accent.opacity(0.12))
                                .clipShape(Circle())
                                .glow(theme.accent, radius: 5, intensity: 0.25)
                            VStack(alignment: .leading, spacing: 4) {
                                Text(area.area)
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(theme.primaryText)
                                HStack(spacing: 4) {
                                    Image(systemName: area.trend >= 0 ? "arrow.up.right" : "arrow.down.right")
                                        .font(.system(size: 10, weight: .bold))
                                    Text(String(format: "%.1f%% this month", abs(area.trend)))
                                        .font(.system(size: 12))
                                }
                                .foregroundColor(area.trend >= 0 ? theme.success : theme.error)
                            }
                            Spacer()
                            Text("\(area.score)")
                                .font(.system(size: 32, weight: .bold, design: .rounded))
                                .foregroundColor(theme.primaryText)
                                .glow(theme.accent, radius: 6, intensity: 0.2)
                        }
                    }
                    .fadeIn()
                }
            }
            .padding(AppTheme.padding)
        }
        .futuristicBackground()
        .navigationBarHidden(true)
        .onAppear {
            withAnimation(.spring(response: 1.0, dampingFraction: 0.8).delay(0.2)) {
                animateRings = true
            }
        }
    }
}
