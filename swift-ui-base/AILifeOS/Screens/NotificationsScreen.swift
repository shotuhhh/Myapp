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
    
    var body: some View {
        let theme = colorScheme == .dark ? ThemeColors.dark : ThemeColors.light
        
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Text("Notifications")
                        .font(.system(size: 34, weight: .bold, design: .rounded))
                        .foregroundColor(theme.primaryText)
                    Spacer()
                    Button("Mark all read") {
                        notifications = notifications.map { n in
                            NotificationItem(id: n.id, title: n.title, message: n.message, date: n.date, type: n.type, isRead: true)
                        }
                        appState.showToast("All marked read")
                    }
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(theme.accent)
                }
                .padding(.top, 8)
                
                if notifications.allSatisfy({ $0.isRead }) && notifications.isEmpty {
                    EmptyStateView(icon: "bell.slash", title: "All clear", message: "No notifications right now.")
                } else {
                    ForEach(notifications.indices, id: \.self) { index in
                        let n = notifications[index]
                        Button(action: { markRead(at: index) }) {
                            GlassCard(padding: 12) {
                                HStack(alignment: .top, spacing: 12) {
                                    Image(systemName: iconFor(n.type))
                                        .foregroundColor(theme.accent)
                                        .frame(width: 36, height: 36)
                                        .background(theme.accent.opacity(0.12))
                                        .clipShape(Circle())
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(n.title)
                                            .font(.system(size: 15, weight: n.isRead ? .medium : .semibold))
                                            .foregroundColor(theme.primaryText)
                                        Text(n.message)
                                            .font(.system(size: 13))
                                            .foregroundColor(theme.secondaryText)
                                            .lineLimit(2)
                                    }
                                    Spacer()
                                    if !n.isRead {
                                        Circle()
                                            .fill(theme.accent)
                                            .frame(width: 8, height: 8)
                                    }
                                }
                            }
                        }
                        .buttonStyle(PressableButtonStyle())
                    }
                }
            }
            .padding(AppTheme.padding)
        }
        .themedBackground()
        .navigationBarHidden(true)
    }
    
    private func iconFor(_ type: NotificationItem.NotificationType) -> String {
        switch type {
        case .reminder: return "bell.fill"
        case .insight: return "lightbulb.fill"
        case .achievement: return "trophy.fill"
        case .system: return "gear"
        case .social: return "person.2.fill"
        }
    }
    
    private func markRead(at index: Int) {
        let n = notifications[index]
        notifications[index] = NotificationItem(id: n.id, title: n.title, message: n.message, date: n.date, type: n.type, isRead: true)
        HapticFeedback.light()
    }
}
