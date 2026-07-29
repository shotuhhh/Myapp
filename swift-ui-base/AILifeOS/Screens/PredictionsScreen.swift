//
//  PredictionsScreen.swift
//  AI Life OS
//

import SwiftUI

struct PredictionsScreen: View {
    @ObservedObject private var data = MockDataStore.shared
    @EnvironmentObject var appState: AppState
    @Environment(\.colorScheme) private var colorScheme
    @State private var animateRings = false

    var body: some View {
        let theme = colorScheme == .dark ? ThemeColors.dark : ThemeColors.light

        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 16) {
                ModuleHeader(title: "Prediction", subtitle: "AI forecasts from your patterns", icon: "chart.line.uptrend.xyaxis")

                LiveActivityMock()

                ForEach(data.predictions) { prediction in
                    GlassCard {
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Text(prediction.title)
                                    .font(.system(size: 17, weight: .semibold, design: .rounded))
                                    .foregroundColor(theme.primaryText)
                                Spacer()
                                probabilityRing(animateRings ? prediction.probability : 0, theme: theme)
                            }

                            Label(prediction.timeframe, systemImage: "clock")
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(theme.accent)

                            HStack(spacing: 8) {
                                Image(systemName: "lightbulb.fill")
                                    .font(.system(size: 12))
                                    .foregroundColor(theme.warning)
                                Text(prediction.recommendation)
                                    .font(.system(size: 13))
                                    .foregroundColor(theme.primaryText)
                            }
                            .padding(10)
                            .background(
                                RoundedRectangle(cornerRadius: 10, style: .continuous)
                                    .fill(theme.accent.opacity(colorScheme == .dark ? 0.08 : 0.06))
                            )
                        }
                    }
                    .fadeIn()
                }

                PremiumButton("Run Simulation", icon: "sparkle.magnifyingglass", action: {
                    appState.navigate(to: .futureSimulation)
                })
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

    private func probabilityRing(_ value: Double, theme: ThemeColors) -> some View {
        ZStack {
            Circle()
                .stroke(theme.border.opacity(0.4), lineWidth: 4)
                .frame(width: 50, height: 50)
            Circle()
                .trim(from: 0, to: CGFloat(value))
                .stroke(
                    LinearGradient(colors: [theme.gradientStart, theme.gradientEnd],
                                   startPoint: .topLeading, endPoint: .bottomTrailing),
                    style: StrokeStyle(lineWidth: 4, lineCap: .round)
                )
                .frame(width: 50, height: 50)
                .rotationEffect(.degrees(-90))
                .glow(theme.accent, radius: 4, intensity: 0.4)
                .animation(.spring(response: 1.0, dampingFraction: 0.8), value: value)
            Text("\(Int(value * 100))%")
                .font(.system(size: 11, weight: .bold, design: .monospaced))
                .foregroundColor(theme.primaryText)
        }
    }
}
