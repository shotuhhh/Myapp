//
//  ProjectsScreen.swift
//  AI Life OS
//

import SwiftUI

struct ProjectsScreen: View {
    @ObservedObject private var data = MockDataStore.shared
    @EnvironmentObject var appState: AppState
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        let theme = colorScheme == .dark ? ThemeColors.dark : ThemeColors.light

        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 16) {
                ModuleHeader(title: "Projects", subtitle: "\(data.projects.count) active · AI-tracked", icon: "folder.fill")

                ForEach(data.projects) { project in
                    GlassCard {
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Text(project.name)
                                    .font(.system(size: 18, weight: .semibold, design: .rounded))
                                    .foregroundColor(theme.primaryText)
                                Spacer()
                                statusBadge(project.status, theme: theme)
                            }

                            HStack(spacing: 16) {
                                ProgressRing(progress: project.progress, label: "Done", size: 60)
                                    .glow(theme.accent, radius: 6, intensity: 0.3)
                                VStack(alignment: .leading, spacing: 5) {
                                    HStack(spacing: 6) {
                                        Image(systemName: "checkmark.circle")
                                            .font(.system(size: 12))
                                            .foregroundColor(theme.success)
                                        Text("\(project.tasksCompleted)/\(project.tasksTotal) tasks")
                                            .font(.system(size: 14, weight: .medium))
                                            .foregroundColor(theme.primaryText)
                                    }
                                    HStack(spacing: 6) {
                                        Image(systemName: "person.2")
                                            .font(.system(size: 12))
                                            .foregroundColor(theme.accent)
                                        Text("\(project.teamSize) members")
                                            .font(.system(size: 13))
                                            .foregroundColor(theme.secondaryText)
                                    }
                                    HStack(spacing: 6) {
                                        Image(systemName: "calendar")
                                            .font(.system(size: 12))
                                            .foregroundColor(theme.secondaryText)
                                        Text("Due \(formatDate(project.dueDate))")
                                            .font(.system(size: 13))
                                            .foregroundColor(theme.secondaryText)
                                    }
                                }
                                Spacer()
                            }

                            // Progress bar
                            GeometryReader { g in
                                ZStack(alignment: .leading) {
                                    Capsule().fill(theme.border.opacity(0.3)).frame(height: 5)
                                    Capsule()
                                        .fill(LinearGradient(
                                            colors: [theme.gradientStart, theme.gradientEnd],
                                            startPoint: .leading, endPoint: .trailing))
                                        .frame(width: g.size.width * CGFloat(project.progress), height: 5)
                                        .glow(theme.accent, radius: 3, intensity: 0.3)
                                }
                            }
                            .frame(height: 5)
                        }
                    }
                    .fadeIn()
                }

                PremiumButton("New Project", icon: "folder.badge.plus", action: {
                    appState.showToast("Project created")
                })
            }
            .padding(AppTheme.padding)
        }
        .futuristicBackground()
        .navigationBarHidden(true)
    }

    private func statusBadge(_ status: ProjectItem.ProjectStatus, theme: ThemeColors) -> some View {
        let (text, color): (String, Color) = {
            switch status {
            case .active:    return ("Active", theme.success)
            case .paused:    return ("Paused", theme.warning)
            case .completed: return ("Done", theme.accent)
            case .planning:  return ("Planning", theme.secondaryText)
            }
        }()
        return Text(text)
            .font(.system(size: 11, weight: .bold))
            .foregroundColor(color)
            .padding(.horizontal, 10)
            .padding(.vertical, 4)
            .background(color.opacity(0.15))
            .clipShape(Capsule())
    }

    private func formatDate(_ date: Date) -> String {
        let f = DateFormatter(); f.dateStyle = .medium; return f.string(from: date)
    }
}
