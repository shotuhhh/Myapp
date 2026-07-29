//
//  GoalsScreen.swift
//  AI Life OS
//

import SwiftUI

struct GoalsScreen: View {
    @ObservedObject private var data = MockDataStore.shared
    @EnvironmentObject var appState: AppState
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        let theme = colorScheme == .dark ? ThemeColors.dark : ThemeColors.light
        
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 16) {
                Text("Goals")
                    .font(.system(size: 34, weight: .bold, design: .rounded))
                    .foregroundColor(theme.primaryText)
                    .padding(.top, 8)
                
                GradientHeaderCard(title: "Active Goals", subtitle: "\(data.goals.count) in progress", icon: "target")
                
                ForEach(data.goals) { goal in
                    GlassCard {
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Text(goal.title)
                                    .font(.system(size: 18, weight: .semibold))
                                    .foregroundColor(theme.primaryText)
                                Spacer()
                                ChipView(text: goal.category, isSelected: true)
                            }
                            Text(goal.description)
                                .font(.system(size: 14))
                                .foregroundColor(theme.secondaryText)
                            
                            GeometryReader { g in
                                ZStack(alignment: .leading) {
                                    RoundedRectangle(cornerRadius: 4).fill(theme.border).frame(height: 8)
                                    RoundedRectangle(cornerRadius: 4)
                                        .fill(LinearGradient(colors: [theme.gradientStart, theme.gradientEnd], startPoint: .leading, endPoint: .trailing))
                                        .frame(width: g.size.width * CGFloat(goal.progress), height: 8)
                                }
                            }
                            .frame(height: 8)
                            
                            HStack {
                                Text("\(Int(goal.progress * 100))% complete")
                                    .font(.system(size: 13, weight: .medium))
                                    .foregroundColor(theme.accent)
                                Spacer()
                                Text(formatDate(goal.deadline))
                                    .font(.system(size: 13))
                                    .foregroundColor(theme.secondaryText)
                            }
                            
                            ForEach(goal.milestones, id: \.self) { milestone in
                                HStack(spacing: 8) {
                                    Image(systemName: "checkmark.circle")
                                        .foregroundColor(theme.tertiaryText)
                                        .font(.system(size: 14))
                                    Text(milestone)
                                        .font(.system(size: 13))
                                        .foregroundColor(theme.secondaryText)
                                }
                            }
                        }
                    }
                }
                
                PremiumButton("New Goal", icon: "plus", action: { appState.showToast("Goal created") })
            }
            .padding(AppTheme.padding)
        }
        .themedBackground()
        .navigationBarHidden(true)
    }
    
    private func formatDate(_ date: Date) -> String {
        let f = DateFormatter()
        f.dateStyle = .medium
        return f.string(from: date)
    }
}
