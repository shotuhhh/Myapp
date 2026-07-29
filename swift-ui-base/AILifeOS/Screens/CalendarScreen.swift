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
                Text("Calendar")
                    .font(.system(size: 34, weight: .bold, design: .rounded))
                    .foregroundColor(theme.primaryText)
                    .padding(.top, 8)
                
                weekStrip(theme: theme)
                
                SectionHeader(title: "Events", actionTitle: "Add", action: { appState.showToast("Event added") })
                
                ForEach(data.calendarEvents) { event in
                    GlassCard {
                        HStack(spacing: 14) {
                            VStack {
                                Text(formatTime(event.start))
                                    .font(.system(size: 13, weight: .bold))
                                    .foregroundColor(theme.accent)
                                Text(formatTime(event.end))
                                    .font(.system(size: 11))
                                    .foregroundColor(theme.secondaryText)
                            }
                            RoundedRectangle(cornerRadius: 4)
                                .fill(event.color)
                                .frame(width: 4)
                            VStack(alignment: .leading, spacing: 4) {
                                Text(event.title)
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(theme.primaryText)
                                if let loc = event.location {
                                    Label(loc, systemImage: "mappin")
                                        .font(.system(size: 13))
                                        .foregroundColor(theme.secondaryText)
                                }
                            }
                            Spacer()
                        }
                    }
                }
                
                if data.calendarEvents.isEmpty {
                    EmptyStateView(icon: "calendar", title: "No events", message: "Your schedule is clear today.", actionTitle: "Add Event", action: { appState.showToast("Event added") })
                }
            }
            .padding(AppTheme.padding)
        }
        .themedBackground()
        .navigationBarHidden(true)
    }
    
    private func weekStrip(theme: ThemeColors) -> some View {
        let cal = Calendar.current
        let days = (-3...3).map { cal.date(byAdding: .day, value: $0, to: Date())! }
        
        return HStack(spacing: 8) {
            ForEach(days, id: \.self) { day in
                let isToday = cal.isDateInToday(day)
                VStack(spacing: 6) {
                    Text(dayFormatter.string(from: day))
                        .font(.system(size: 11, weight: .medium))
                        .foregroundColor(isToday ? .white : theme.secondaryText)
                    Text("\(cal.component(.day, from: day))")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(isToday ? .white : theme.primaryText)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(isToday ? theme.accent : theme.cardBackground)
                )
            }
        }
    }
    
    private var dayFormatter: DateFormatter {
        let f = DateFormatter()
        f.dateFormat = "EEE"
        return f
    }
    
    private func formatTime(_ date: Date) -> String {
        let f = DateFormatter()
        f.timeStyle = .short
        return f.string(from: date)
    }
}
