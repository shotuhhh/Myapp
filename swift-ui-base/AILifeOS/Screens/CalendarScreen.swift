//
//  CalendarScreen.swift
//  AI Life OS
//

import SwiftUI

struct CalendarScreen: View {
    @ObservedObject private var data = MockDataStore.shared
    @EnvironmentObject var appState: AppState
    @Environment(\.colorScheme) private var colorScheme
    @State private var selectedDate = Date()

    var body: some View {
        let theme = colorScheme == .dark ? ThemeColors.dark : ThemeColors.light

        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 16) {
                ModuleHeader(title: "Planning", subtitle: "AI-optimized schedule", icon: "calendar.badge.clock")

                weekStrip(theme: theme)

                // AI planning hint
                GlassCard(padding: 12) {
                    HStack(spacing: 10) {
                        Image(systemName: "sparkles")
                            .foregroundColor(theme.accent)
                            .glow(theme.accent, radius: 4)
                        Text("AI suggests: protect 9–11 AM for deep work today")
                            .font(.system(size: 13, weight: .medium))
                            .foregroundColor(theme.primaryText)
                        Spacer()
                    }
                }

                SectionHeader(
                    title: "Events",
                    actionTitle: "Add",
                    action: { appState.showToast("Event added") }
                )

                if data.calendarEvents.isEmpty {
                    EmptyStateView(
                        icon: "calendar",
                        title: "No events",
                        message: "Your schedule is clear today.",
                        actionTitle: "Add Event",
                        action: { appState.showToast("Event added") }
                    )
                } else {
                    ForEach(data.calendarEvents) { event in
                        GlassCard(padding: 14) {
                            HStack(spacing: 14) {
                                VStack(spacing: 2) {
                                    Text(formatTime(event.start))
                                        .font(.system(size: 13, weight: .bold, design: .monospaced))
                                        .foregroundColor(theme.accent)
                                    Text(formatTime(event.end))
                                        .font(.system(size: 11, design: .monospaced))
                                        .foregroundColor(theme.secondaryText)
                                }
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(event.color)
                                    .frame(width: 4)
                                    .glow(event.color, radius: 4, intensity: 0.4)
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(event.title)
                                        .font(.system(size: 15, weight: .semibold))
                                        .foregroundColor(theme.primaryText)
                                    if let loc = event.location {
                                        Label(loc, systemImage: "mappin")
                                            .font(.system(size: 12))
                                            .foregroundColor(theme.secondaryText)
                                    }
                                }
                                Spacer()
                                Image(systemName: "sparkles")
                                    .font(.system(size: 12))
                                    .foregroundColor(theme.accent.opacity(0.6))
                            }
                        }
                        .fadeIn()
                    }
                }
            }
            .padding(AppTheme.padding)
        }
        .futuristicBackground()
        .navigationBarHidden(true)
    }

    private func weekStrip(theme: ThemeColors) -> some View {
        let cal = Calendar.current
        let days = (-3...3).map { cal.date(byAdding: .day, value: $0, to: Date())! }

        return HStack(spacing: 6) {
            ForEach(days, id: \.self) { day in
                let isToday = cal.isDateInToday(day)
                VStack(spacing: 5) {
                    Text(dayFormatter.string(from: day))
                        .font(.system(size: 10, weight: .medium))
                        .foregroundColor(isToday ? .white : theme.secondaryText)
                    Text("\(cal.component(.day, from: day))")
                        .font(.system(size: 15, weight: .bold))
                        .foregroundColor(isToday ? .white : theme.primaryText)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
                .background(
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(isToday ? theme.accent : Color.white.opacity(0.05))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12, style: .continuous)
                                .stroke(isToday ? Color.clear : theme.border.opacity(0.3), lineWidth: 0.5)
                        )
                )
                .glow(isToday ? theme.accent : .clear, radius: 6, intensity: 0.4)
            }
        }
    }

    private var dayFormatter: DateFormatter {
        let f = DateFormatter(); f.dateFormat = "EEE"; return f
    }

    private func formatTime(_ date: Date) -> String {
        let f = DateFormatter(); f.timeStyle = .short; return f.string(from: date)
    }
}
