//
//  NotificationsScreen.swift
//  AI Life OS
//

import SwiftUI

struct NotificationsScreen: View {
    @ObservedObject private var data = MockDataStore.shared
    @EnvironmentObject var appState: AppState
    @Environment(\.colorScheme) private var colorScheme
    @State private var notifications: [NotificationItem] = MockDataStore.shared.notifications

    private var unreadCount: Int { notifications.filter { !$0.isRead }.count }

    var body: some View {
        let theme = colorScheme == .dark ? ThemeColors.dark : ThemeColors.light

        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    ModuleHeader(
                        title: "Notifications",
                        subtitle: "\(unreadCount) unread",
                        icon: "bell.fill"
                    )
                    Spacer()
                    if unreadCount > 0 {
                        Button("Mark all read") {
                            withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                                notifications = notifications.map {
                                    NotificationItem(id: $0.id, title: $0.title, message: $0.message,
                                                     date: $0.date, type: $0.type, isRead: true)
                                }
                            }
                            appState.showToast("All marked read")
                        }
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(theme.accent)
                    }
                }

                if notifications.isEmpty {
                    EmptyStateView(icon: "bell.slash", title: "All clear", message: "No notifications right now.")
                } else {
                    ForEach(notifications.indices, id: \.self) { index in
                        let n = notifications[index]
                        Button(action: { markRead(at: index) }) {
                            GlassCard(padding: 12) {
                                HStack(alignment: .top, spacing: 12) {
                                    Image(systemName: iconFor(n.type))
                                        .font(.system(size: 15))
                                        .foregroundColor(colorFor(n.type, theme: theme))
                                        .frame(width: 38, height: 38)
                                        .background(colorFor(n.type, theme: theme).opacity(0.12))
                                        .clipShape(Circle())
                                        .glow(colorFor(n.type, theme: theme), radius: 4, intensity: 0.3)
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(n.title)
                                            .font(.system(size: 15, weight: n.isRead ? .medium : .semibold))
                                            .foregroundColor(theme.primaryText)
                                        Text(n.message)
                                            .font(.system(size: 13))
                                            .foregroundColor(theme.secondaryText)
                                            .lineLimit(2)
                                        Text(n.date, style: .relative)
                                            .font(.system(size: 11))
                                            .foregroundColor(theme.tertiaryText)
                                    }
                                    Spacer()
                                    if !n.isRead {
                                        Circle()
                                            .fill(theme.accent)
                                            .frame(width: 8, height: 8)
                                            .glow(theme.accent, radius: 4, intensity: 0.6)
                                    }
                                }
                            }
                        }
                        .buttonStyle(PressableButtonStyle())
                        .opacity(n.isRead ? 0.7 : 1.0)
                    }
                }
            }
            .padding(AppTheme.padding)
        }
        .futuristicBackground()
        .navigationBarHidden(true)
    }

    private func iconFor(_ type: NotificationItem.NotificationType) -> String {
        switch type {
        case .reminder:    return "bell.fill"
        case .insight:     return "lightbulb.fill"
        case .achievement: return "trophy.fill"
        case .system:      return "gear"
        case .social:      return "person.2.fill"
        }
    }

    private func colorFor(_ type: NotificationItem.NotificationType, theme: ThemeColors) -> Color {
        switch type {
        case .reminder:    return theme.accent
        case .insight:     return theme.warning
        case .achievement: return theme.success
        case .system:      return theme.secondaryText
        case .social:      return .purple
        }
    }

    private func markRead(at index: Int) {
        let n = notifications[index]
        withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
            notifications[index] = NotificationItem(
                id: n.id, title: n.title, message: n.message,
                date: n.date, type: n.type, isRead: true
            )
        }
        HapticFeedback.light()
    }
}
