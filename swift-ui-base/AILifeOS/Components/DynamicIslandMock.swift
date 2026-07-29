//
//  DynamicIslandMock.swift
//  AI Life OS
//

import SwiftUI

struct DynamicIslandMock: View {
    @ObservedObject private var liveAI = LiveAIActivityStore.shared
    @Environment(\.colorScheme) private var colorScheme
    @State private var expanded = false
    
    var body: some View {
        let theme = colorScheme == .dark ? ThemeColors.dark : ThemeColors.light
        
        VStack {
            Button(action: {
                withAnimation(.spring(response: 0.4, dampingFraction: 0.75)) {
                    expanded.toggle()
                }
                HapticFeedback.light()
            }) {
                if expanded {
                    HStack(spacing: 10) {
                        Image(systemName: liveAI.currentActivity.icon)
                            .foregroundColor(theme.accent)
                            .font(.system(size: 14))
                        VStack(alignment: .leading, spacing: 1) {
                            Text("AI Life OS")
                                .font(.system(size: 11, weight: .bold))
                                .foregroundColor(.white)
                            Text(liveAI.currentActivity.message)
                                .font(.system(size: 10))
                                .foregroundColor(.white.opacity(0.7))
                                .lineLimit(1)
                        }
                        Spacer()
                        Circle()
                            .fill(theme.success)
                            .frame(width: 6, height: 6)
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                    .frame(width: 280)
                    .background(Capsule().fill(.black))
                } else {
                    HStack(spacing: 8) {
                        Circle()
                            .fill(theme.accent)
                            .frame(width: 8, height: 8)
                            .glow(theme.accent, radius: 4)
                        Capsule()
                            .fill(theme.accent.opacity(0.6))
                            .frame(width: 40, height: 4)
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 8)
                    .background(Capsule().fill(.black))
                }
            }
            .buttonStyle(.plain)
            Spacer()
        }
        .padding(.top, 4)
    }
}

struct LiveActivityMock: View {
    @ObservedObject private var liveAI = LiveAIActivityStore.shared
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        let theme = colorScheme == .dark ? ThemeColors.dark : ThemeColors.light
        
        HStack(spacing: 12) {
            Image(systemName: "sparkles")
                .foregroundColor(theme.accent)
            VStack(alignment: .leading, spacing: 2) {
                Text("AI Processing")
                    .font(.system(size: 12, weight: .bold))
                Text(liveAI.currentActivity.message)
                    .font(.system(size: 11))
                    .foregroundColor(theme.secondaryText)
            }
            Spacer()
            ProgressView()
                .scaleEffect(0.7)
        }
        .padding(12)
        .glassSurface(cornerRadius: 14)
    }
}
