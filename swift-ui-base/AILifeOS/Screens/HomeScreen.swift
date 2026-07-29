//
//  HomeScreen.swift
//  AI Life OS
//

import SwiftUI

struct HomeScreen: View {
    @EnvironmentObject var appState: AppState
    @ObservedObject private var data = MockDataStore.shared
    @Environment(\.colorScheme) private var colorScheme
    @State private var showEmptyDemo = false
    
    var body: some View {
        let theme = colorScheme == .dark ? ThemeColors.dark : ThemeColors.light
        
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 20) {
                header(theme: theme)
                
                if appState.demoContentState == .loading {
                    LoadingSkeletonList(count: 3)
                } else if showEmptyDemo {
                    EmptyStateView(
                        icon: "sparkles",
                        title: "Your day awaits",
                        message: "Start a focus session or chat with AI to populate your dashboard.",
                        actionTitle: "Start Focus",
                        action: { showEmptyDemo = false; appState.showToast("Focus session started") }
                    )
                } else {
                    greetingCard(theme: theme)
                    quickActions(theme: theme)
                    statsRow(theme: theme)
                    todaySection(theme: theme)
                    habitsPreview(theme: theme)
                }
            }
            .padding(.horizontal, AppTheme.padding)
            .padding(.bottom, 24)
        }
        .themedBackground()
        .navigationBarHidden(true)
        .onAppear { appState.simulateLoadingThenLoaded() }
    }
    
    private func header(theme: ThemeColors) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("AI Life OS")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(theme.accent)
                Text("Good morning")
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                    .foregroundColor(theme.primaryText)
            }
            Spacer()
            HStack(spacing: 10) {
                IconButton(icon: "magnifyingglass", action: { appState.navigate(to: .search) })
                IconButton(icon: "bell.fill", action: { appState.navigate(to: .notifications) })
            }
        }
        .padding(.top, 8)
    }
    
    private func greetingCard(theme: ThemeColors) -> some View {
        GlassCard {
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    Text(data.user.name)
                        .font(.system(size: 22, weight: .bold, design: .rounded))
                        .foregroundColor(theme.primaryText)
                    Text("Focus score: \(data.user.focusScore) · \(data.user.streakDays)-day streak")
                        .font(.system(size: 14))
                        .foregroundColor(theme.secondaryText)
                    HStack(spacing: 8) {
                        ChipView(text: data.user.plan, isSelected: true)
                        ChipView(text: "3 events today")
                    }
                }
                Spacer()
                ProgressRing(progress: Double(data.user.focusScore) / 100, label: "Focus", size: 72)
            }
        }
        .fadeIn()
    }
    
    private func quickActions(theme: ThemeColors) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader(title: "Quick Actions")
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    quickActionButton("AI Chat", icon: "bubble.left.fill", theme: theme, route: .aiChat)
                    quickActionButton("Voice", icon: "waveform", theme: theme, route: .voiceChat)
                    quickActionButton("Calendar", icon: "calendar", theme: theme, route: .calendar)
                    quickActionButton("Goals", icon: "target", theme: theme, route: .goals)
                }
            }
        }
        .fadeIn(delay: 0.05)
    }
    
    private func quickActionButton(_ title: String, icon: String, theme: ThemeColors, route: AppRoute) -> some View {
        Button(action: { appState.navigate(to: route) }) {
            VStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(width: 48, height: 48)
                    .background(
                        LinearGradient(colors: [theme.gradientStart, theme.gradientEnd], startPoint: .topLeading, endPoint: .bottomTrailing)
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                Text(title)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(theme.primaryText)
            }
            .padding(.vertical, 4)
        }
        .buttonStyle(PressableButtonStyle())
    }
    
    private func statsRow(theme: ThemeColors) -> some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
            ForEach(Array(data.analytics.prefix(4))) { metric in
                StatCard(label: metric.label, value: metric.value, icon: metric.icon, change: metric.change)
            }
        }
        .fadeIn(delay: 0.1)
    }
    
    private func todaySection(theme: ThemeColors) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader(title: "Today", actionTitle: "Calendar", action: { appState.navigate(to: .calendar) })
            ForEach(data.calendarEvents) { event in
                HStack(spacing: 12) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(event.color)
                        .frame(width: 4, height: 44)
                    VStack(alignment: .leading, spacing: 2) {
                        Text(event.title)
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundColor(theme.primaryText)
                        Text(formatTime(event.start))
                            .font(.system(size: 13))
                            .foregroundColor(theme.secondaryText)
                    }
                    Spacer()
                }
                .padding(12)
                .background(RoundedRectangle(cornerRadius: AppTheme.cornerRadius).fill(theme.cardBackground))
            }
        }
        .fadeIn(delay: 0.15)
    }
    
    private func habitsPreview(theme: ThemeColors) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader(title: "Habits", actionTitle: "See all", action: { appState.navigate(to: .habits) })
            ForEach(Array(data.habits.prefix(3))) { habit in
                HStack {
                    Image(systemName: habit.icon)
                        .foregroundColor(habit.completedToday ? theme.success : theme.secondaryText)
                    Text(habit.name)
                        .foregroundColor(theme.primaryText)
                    Spacer()
                    Text("\(habit.streak)d")
                        .font(.system(size: 13, weight: .bold))
                        .foregroundColor(theme.accent)
                    Image(systemName: habit.completedToday ? "checkmark.circle.fill" : "circle")
                        .foregroundColor(habit.completedToday ? theme.success : theme.tertiaryText)
                }
                .padding(12)
                .background(RoundedRectangle(cornerRadius: AppTheme.cornerRadius).fill(theme.cardBackground))
            }
        }
        .fadeIn(delay: 0.2)
    }
    
    private func formatTime(_ date: Date) -> String {
        let f = DateFormatter()
        f.timeStyle = .short
        return f.string(from: date)
    }
}
