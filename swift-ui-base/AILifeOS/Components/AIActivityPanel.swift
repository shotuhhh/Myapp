//
//  AIActivityPanel.swift
//  AI Life OS
//

import SwiftUI

struct AIActivityPanel: View {
    @ObservedObject private var liveAI = LiveAIActivityStore.shared
    @Environment(\.colorScheme) private var colorScheme
    @State private var dotPulse = false
    
    var body: some View {
        let theme = colorScheme == .dark ? ThemeColors.dark : ThemeColors.light
        
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Circle()
                    .fill(theme.success)
                    .frame(width: 8, height: 8)
                    .scaleEffect(dotPulse ? 1.3 : 0.8)
                    .opacity(dotPulse ? 1 : 0.6)
                Text("AI Active")
                    .font(.system(size: 12, weight: .bold, design: .rounded))
                    .foregroundColor(theme.success)
                    .textCase(.uppercase)
                    .tracking(1)
                Spacer()
                Text(liveAI.currentActivity.module)
                    .font(.system(size: 11, weight: .medium))
                    .foregroundColor(theme.accent)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 3)
                    .background(Capsule().fill(theme.accent.opacity(0.15)))
            }
            
            HStack(spacing: 12) {
                ZStack {
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .fill(theme.accent.opacity(0.15))
                        .frame(width: 40, height: 40)
                    Image(systemName: liveAI.currentActivity.icon)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(theme.accent)
                        .pulse()
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(liveAI.currentActivity.message)
                        .font(.system(size: 15, weight: .semibold, design: .rounded))
                        .foregroundColor(theme.primaryText)
                        .id(liveAI.currentActivity.id)
                        .transition(.asymmetric(insertion: .move(edge: .bottom).combined(with: .opacity), removal: .opacity))
                    Text("Processing continuously")
                        .font(.system(size: 12))
                        .foregroundColor(theme.secondaryText)
                }
                Spacer()
            }
            .animation(.spring(response: 0.5, dampingFraction: 0.8), value: liveAI.currentActivity.id)
            
            // Activity stream
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(liveAI.recentActivities.prefix(5)) { activity in
                        HStack(spacing: 6) {
                            Image(systemName: activity.icon)
                                .font(.system(size: 10))
                            Text(activity.message)
                                .font(.system(size: 11, weight: .medium))
                                .lineLimit(1)
                        }
                        .foregroundColor(theme.secondaryText)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(Capsule().fill(theme.cardBackground.opacity(0.6)))
                    }
                }
            }
        }
        .padding(AppTheme.padding)
        .glassSurface()
        .onAppear {
            withAnimation(.easeInOut(duration: 1.0).repeatForever(autoreverses: true)) {
                dotPulse = true
            }
        }
    }
}
