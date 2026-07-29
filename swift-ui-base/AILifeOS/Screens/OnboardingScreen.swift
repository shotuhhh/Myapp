//
//  OnboardingScreen.swift
//  AI Life OS
//

import SwiftUI

struct OnboardingScreen: View {
    @EnvironmentObject var appState: AppState
    @Environment(\.colorScheme) private var colorScheme
    @State private var page = 0
    
    private let pages: [(icon: String, title: String, subtitle: String)] = [
        ("sparkles", "Welcome to AI Life OS", "Your intelligent companion for goals, habits, and life balance."),
        ("brain.head.profile", "AI That Knows You", "Personalized insights and memory that grows with you."),
        ("chart.line.uptrend.xyaxis", "Track Everything", "Goals, projects, habits, and progress in one place."),
        ("lock.shield.fill", "Private & Secure", "Your data stays yours. Built with privacy first.")
    ]
    
    var body: some View {
        let theme = colorScheme == .dark ? ThemeColors.dark : ThemeColors.light
        
        VStack(spacing: 0) {
            TabView(selection: $page) {
                ForEach(pages.indices, id: \.self) { index in
                    VStack(spacing: 32) {
                        Spacer()
                        ZStack {
                            Circle()
                                .fill(theme.accent.opacity(0.12))
                                .frame(width: 140, height: 140)
                            Image(systemName: pages[index].icon)
                                .font(.system(size: 56, weight: .medium))
                                .foregroundColor(theme.accent)
                        }
                        .fadeIn()
                        
                        VStack(spacing: 12) {
                            Text(pages[index].title)
                                .font(.system(size: 28, weight: .bold, design: .rounded))
                                .foregroundColor(theme.primaryText)
                                .multilineTextAlignment(.center)
                            Text(pages[index].subtitle)
                                .font(.system(size: 16))
                                .foregroundColor(theme.secondaryText)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 32)
                        }
                        Spacer()
                    }
                    .tag(index)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
            
            VStack(spacing: 12) {
                if page < pages.count - 1 {
                    PremiumButton("Continue", icon: "arrow.right", action: {
                        withAnimation { page += 1 }
                    })
                    .padding(.horizontal, AppTheme.padding)
                } else {
                    PremiumButton("Get Started", icon: "checkmark", action: finishOnboarding)
                        .padding(.horizontal, AppTheme.padding)
                }
                
                if page < pages.count - 1 {
                    Button("Skip") {
                        finishOnboarding()
                    }
                    .font(.system(size: 15, weight: .medium))
                    .foregroundColor(theme.secondaryText)
                }
            }
            .padding(.bottom, 32)
        }
        .themedBackground()
    }
    
    private func finishOnboarding() {
        HapticFeedback.success()
        appState.completeOnboarding()
    }
}
