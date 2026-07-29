//
//  OnboardingScreen.swift
//  AI Life OS — Premium Onboarding
//

import SwiftUI

private struct OnboardingPage {
    let icon: String
    let badge: String
    let title: String
    let subtitle: String
    let accent: Color
    let detail: String
}

struct OnboardingScreen: View {
    @EnvironmentObject var appState: AppState
    @Environment(\.colorScheme) private var colorScheme
    @State private var page = 0
    @State private var orbBreathing = false
    @State private var particlePhase = false

    private let pages: [OnboardingPage] = [
        OnboardingPage(
            icon: "brain",
            badge: "PERSONAL INTELLIGENCE ENGINE",
            title: "Your AI is always thinking",
            subtitle: "AI Life OS runs a living neural model of your life — continuously indexing memories, updating your world model, and simulating your future. 24/7.",
            accent: Color("AccentPrimary"),
            detail: "Memory Engine · World Model · Future Simulation"
        ),
        OnboardingPage(
            icon: "globe.americas.fill",
            badge: "WORLD MODEL",
            title: "AI that understands your life",
            subtitle: "Goals, people, habits, health, finance, career — all connected in a dynamic graph. Your AI discovers hidden relationships you'd never see.",
            accent: .purple,
            detail: "Knowledge Fusion · Hidden Relations · Pattern Detection"
        ),
        OnboardingPage(
            icon: "sparkle.magnifyingglass",
            badge: "FUTURE SIMULATION",
            title: "See your future before it happens",
            subtitle: "Every recommendation runs through Scenario A, B, C modelling — with risk, probability, and expected outcome — before it reaches you.",
            accent: .cyan,
            detail: "Scenario Modeling · Decision Engine · Trust Engine"
        ),
        OnboardingPage(
            icon: "arrow.triangle.2.circlepath",
            badge: "SELF EVOLUTION",
            title: "AI that grows with you",
            subtitle: "Your AI DNA auto-updates from your behaviour. No manual entry. The more you live, the smarter and more personal it becomes.",
            accent: .green,
            detail: "AI DNA · Self Evolution · Continuous Adaptation"
        )
    ]

    var body: some View {
        let theme = colorScheme == .dark ? ThemeColors.dark : ThemeColors.light
        let current = pages[page]

        ZStack {
            // Background morphs per page
            FuturisticBackground()

            // Per-page accent aurora
            Circle()
                .fill(RadialGradient(
                    colors: [current.accent.opacity(0.28), .clear],
                    center: .center, startRadius: 10, endRadius: 300
                ))
                .frame(width: 500, height: 500)
                .offset(x: 0, y: -180)
                .blur(radius: 60)
                .animation(.spring(response: 0.7, dampingFraction: 0.85), value: page)
                .allowsHitTesting(false)

            VStack(spacing: 0) {
                // Skip button
                HStack {
                    Spacer()
                    if page < pages.count - 1 {
                        Button("Skip") { finishOnboarding() }
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundColor(theme.secondaryText)
                    }
                }
                .padding(.horizontal, AppTheme.padding)
                .padding(.top, 12)

                Spacer()

                // Animated orb
                ZStack {
                    BreathingGlow(color: current.accent, size: 180)
                    EnergyPulseRing(color: current.accent, size: 130)

                    Circle()
                        .fill(LinearGradient(
                            colors: [current.accent, current.accent.opacity(0.5)],
                            startPoint: .topLeading, endPoint: .bottomTrailing
                        ))
                        .frame(width: 100, height: 100)
                        .glow(current.accent, radius: 20, intensity: 0.7)

                    Image(systemName: current.icon)
                        .font(.system(size: 40, weight: .semibold))
                        .foregroundColor(.white)
                        .scaleEffect(orbBreathing ? 1.06 : 0.97)
                }
                .frame(height: 200)
                .id("orb-\(page)")
                .transition(.asymmetric(
                    insertion: .scale(scale: 0.7).combined(with: .opacity),
                    removal: .scale(scale: 1.2).combined(with: .opacity)
                ))
                .animation(.spring(response: 0.5, dampingFraction: 0.7), value: page)

                Spacer(minLength: 28)

                // Text content
                VStack(spacing: 14) {
                    Text(current.badge)
                        .font(.system(size: 11, weight: .bold, design: .rounded))
                        .foregroundColor(current.accent)
                        .tracking(2)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 5)
                        .background(Capsule().fill(current.accent.opacity(0.12)))
                        .id("badge-\(page)")
                        .transition(.opacity.combined(with: .move(edge: .bottom)))

                    Text(current.title)
                        .font(.system(size: 30, weight: .bold, design: .rounded))
                        .foregroundColor(theme.primaryText)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 24)
                        .id("title-\(page)")
                        .transition(.asymmetric(
                            insertion: .move(edge: .trailing).combined(with: .opacity),
                            removal: .move(edge: .leading).combined(with: .opacity)
                        ))

                    Text(current.subtitle)
                        .font(.system(size: 16))
                        .lineSpacing(4)
                        .foregroundColor(theme.secondaryText)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 28)
                        .id("sub-\(page)")
                        .transition(.opacity)

                    Text(current.detail)
                        .font(.system(size: 11, weight: .medium))
                        .foregroundColor(theme.tertiaryText)
                        .padding(.top, 2)
                        .id("detail-\(page)")
                        .transition(.opacity)
                }
                .animation(.spring(response: 0.55, dampingFraction: 0.82), value: page)

                Spacer()

                // Page dots
                HStack(spacing: 8) {
                    ForEach(pages.indices, id: \.self) { i in
                        Capsule()
                            .fill(i == page ? current.accent : theme.border)
                            .frame(width: i == page ? 24 : 8, height: 8)
                            .glow(i == page ? current.accent : .clear, radius: 4, intensity: 0.4)
                    }
                }
                .animation(.spring(response: 0.4, dampingFraction: 0.8), value: page)
                .padding(.bottom, 20)

                // CTA
                VStack(spacing: 12) {
                    if page < pages.count - 1 {
                        Button(action: {
                            HapticFeedback.selection()
                            withAnimation(.spring(response: 0.45, dampingFraction: 0.78)) {
                                page += 1
                            }
                        }) {
                            HStack {
                                Text("Continue")
                                    .font(.system(size: 17, weight: .semibold))
                                Image(systemName: "arrow.right")
                                    .font(.system(size: 15, weight: .semibold))
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 54)
                            .background(
                                LinearGradient(
                                    colors: [current.accent, current.accent.opacity(0.7)],
                                    startPoint: .leading, endPoint: .trailing
                                )
                            )
                            .clipShape(Capsule())
                            .glow(current.accent, radius: 10, intensity: 0.4)
                        }
                        .buttonStyle(PressableButtonStyle())
                        .padding(.horizontal, AppTheme.padding)
                        .animation(.spring(response: 0.4, dampingFraction: 0.8), value: page)
                    } else {
                        Button(action: finishOnboarding) {
                            HStack {
                                Text("Start My AI Life OS")
                                    .font(.system(size: 17, weight: .bold))
                                Image(systemName: "sparkles")
                                    .font(.system(size: 15, weight: .semibold))
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 54)
                            .background(
                                LinearGradient(
                                    colors: [current.accent, Color("AccentPrimary")],
                                    startPoint: .leading, endPoint: .trailing
                                )
                            )
                            .clipShape(Capsule())
                            .glow(current.accent, radius: 14, intensity: 0.5)
                        }
                        .buttonStyle(PressableButtonStyle())
                        .padding(.horizontal, AppTheme.padding)
                    }
                }
                .padding(.bottom, 36)
            }
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 2.5).repeatForever(autoreverses: true)) {
                orbBreathing = true
            }
        }
    }

    private func finishOnboarding() {
        HapticFeedback.success()
        appState.completeOnboarding()
    }
}
