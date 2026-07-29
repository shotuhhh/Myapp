//
//  EmptyStateView.swift
//  AI Life OS
//

import SwiftUI

struct EmptyStateView: View {
    let icon: String
    let title: String
    let message: String
    var actionTitle: String?
    var action: (() -> Void)?
    
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        let theme = colorScheme == .dark ? ThemeColors.dark : ThemeColors.light
        VStack(spacing: 20) {
            ZStack {
                Circle()
                    .fill(theme.accent.opacity(0.12))
                    .frame(width: 88, height: 88)
                Image(systemName: icon)
                    .font(.system(size: 36, weight: .medium))
                    .foregroundColor(theme.accent)
            }
            .pulse()
            
            VStack(spacing: 8) {
                Text(title)
                    .font(.system(size: 20, weight: .semibold, design: .rounded))
                    .foregroundColor(theme.primaryText)
                Text(message)
                    .font(.system(size: 15))
                    .foregroundColor(theme.secondaryText)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24)
            }
            
            if let actionTitle = actionTitle, let action = action {
                PremiumButton(actionTitle, icon: "plus", style: .secondary, action: action)
                    .padding(.horizontal, 32)
            }
        }
        .padding(32)
    }
}

struct ErrorStateView: View {
    let message: String
    let retryAction: () -> Void
    
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        let theme = colorScheme == .dark ? ThemeColors.dark : ThemeColors.light
        VStack(spacing: 20) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 44))
                .foregroundColor(theme.warning)
            Text("Something went wrong")
                .font(.system(size: 20, weight: .semibold, design: .rounded))
                .foregroundColor(theme.primaryText)
            Text(message)
                .font(.system(size: 15))
                .foregroundColor(theme.secondaryText)
                .multilineTextAlignment(.center)
            PremiumButton("Try Again", icon: "arrow.clockwise", action: retryAction)
                .padding(.horizontal, 32)
        }
        .padding(32)
    }
}

struct SuccessBanner: View {
    let message: String
    
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        let theme = colorScheme == .dark ? ThemeColors.dark : ThemeColors.light
        HStack(spacing: 10) {
            Image(systemName: "checkmark.circle.fill")
                .foregroundColor(theme.success)
            Text(message)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(theme.primaryText)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            Capsule()
                .fill(theme.cardBackground)
                .shadow(color: .black.opacity(0.12), radius: 12, x: 0, y: 4)
        )
    }
}
