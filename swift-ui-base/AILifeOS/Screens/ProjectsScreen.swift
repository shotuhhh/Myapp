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
                Text("Projects")
                    .font(.system(size: 34, weight: .bold, design: .rounded))
                    .foregroundColor(theme.primaryText)
                    .padding(.top, 8)
                
                ForEach(data.projects) { project in
                    GlassCard {
                        VStack(alignment: .leading, spacing: 10) {
                            HStack {
                                Text(project.name)
                                    .font(.system(size: 18, weight: .semibold))
                                    .foregroundColor(theme.primaryText)
                                Spacer()
                                statusBadge(project.status, theme: theme)
                            }
                            
                            HStack(spacing: 16) {
                                ProgressRing(progress: project.progress, label: "Done", size: 56)
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("\(project.tasksCompleted)/\(project.tasksTotal) tasks")
                                        .foregroundColor(theme.primaryText)
                                    Text("\(project.teamSize) team members")
                                        .font(.system(size: 13))
                                        .foregroundColor(theme.secondaryText)
                                    Text("Due \(formatDate(project.dueDate))")
                                        .font(.system(size: 13))
                                        .foregroundColor(theme.secondaryText)
                                }
                            }
                        }
                    }
                }
                
                PremiumButton("New Project", icon: "folder.badge.plus", action: { appState.showToast("Project created") })
            }
            .padding(AppTheme.padding)
        }
        .themedBackground()
        .navigationBarHidden(true)
    }
    
    private func statusBadge(_ status: ProjectItem.ProjectStatus, theme: ThemeColors) -> some View {
        let (text, color): (String, Color) = {
            switch status {
            case .active: return ("Active", theme.success)
            case .paused: return ("Paused", theme.warning)
            case .completed: return ("Done", theme.accent)
            case .planning: return ("Planning", theme.secondaryText)
            }
        }()
        return Text(text)
            .font(.system(size: 12, weight: .bold))
            .foregroundColor(color)
            .padding(.horizontal, 10)
            .padding(.vertical, 4)
            .background(color.opacity(0.15))
            .clipShape(Capsule())
    }
    
    private func formatDate(_ date: Date) -> String {
        let f = DateFormatter()
        f.dateStyle = .medium
        return f.string(from: date)
    }
}
