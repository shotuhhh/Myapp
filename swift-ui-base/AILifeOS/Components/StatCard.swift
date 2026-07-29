//
//  StatCard.swift
//  AI Life OS
//

import SwiftUI

struct StatCard: View {
    let label: String
    let value: String
    let icon: String
    var change: Double?
    var accent: Color?
    
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        let theme = colorScheme == .dark ? ThemeColors.dark : ThemeColors.light
        let accentColor = accent ?? theme.accent
        
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Image(systemName: icon)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(accentColor)
                    .frame(width: 32, height: 32)
                    .background(accentColor.opacity(0.15))
                    .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                Spacer()
                if let change = change {
                    HStack(spacing: 2) {
                        Image(systemName: change >= 0 ? "arrow.up.right" : "arrow.down.right")
                            .font(.system(size: 10, weight: .bold))
                        Text(String(format: "%.1f%%", abs(change)))
                            .font(.system(size: 11, weight: .semibold))
                    }
                    .foregroundColor(change >= 0 ? theme.success : theme.error)
                }
            }
            Text(value)
                .font(.system(size: 24, weight: .bold, design: .rounded))
                .foregroundColor(theme.primaryText)
            Text(label)
                .font(.system(size: 13, weight: .medium))
                .foregroundColor(theme.secondaryText)
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: AppTheme.cornerRadius, style: .continuous)
                .fill(theme.cardBackground)
        )
    }
}

struct ProgressRing: View {
    let progress: Double
    let label: String
    var size: CGFloat = 64
    
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        let theme = colorScheme == .dark ? ThemeColors.dark : ThemeColors.light
        VStack(spacing: 6) {
            ZStack {
                Circle()
                    .stroke(theme.border, lineWidth: 6)
                Circle()
                    .trim(from: 0, to: CGFloat(min(progress, 1)))
                    .stroke(
                        LinearGradient(colors: [theme.gradientStart, theme.gradientEnd], startPoint: .topLeading, endPoint: .bottomTrailing),
                        style: StrokeStyle(lineWidth: 6, lineCap: .round)
                    )
                    .rotationEffect(.degrees(-90))
                    .animation(AppTheme.springAnimation, value: progress)
                Text("\(Int(progress * 100))%")
                    .font(.system(size: size * 0.22, weight: .bold, design: .rounded))
                    .foregroundColor(theme.primaryText)
            }
            .frame(width: size, height: size)
            Text(label)
                .font(.system(size: 11, weight: .medium))
                .foregroundColor(theme.secondaryText)
        }
    }
}

struct SectionHeader: View {
    let title: String
    var actionTitle: String?
    var action: (() -> Void)?
    
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        let theme = colorScheme == .dark ? ThemeColors.dark : ThemeColors.light
        HStack {
            Text(title)
                .font(.system(size: 18, weight: .semibold, design: .rounded))
                .foregroundColor(theme.primaryText)
            Spacer()
            if let actionTitle = actionTitle, let action = action {
                Button(action: {
                    HapticFeedback.selection()
                    action()
                }) {
                    Text(actionTitle)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(theme.accent)
                }
            }
        }
    }
}

struct ChipView: View {
    let text: String
    var isSelected: Bool = false
    
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        let theme = colorScheme == .dark ? ThemeColors.dark : ThemeColors.light
        Text(text)
            .font(.system(size: 13, weight: .medium))
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .foregroundColor(isSelected ? .white : theme.primaryText)
            .background(
                Capsule()
                    .fill(isSelected ? theme.accent : theme.cardBackground)
            )
            .overlay(
                Capsule().stroke(theme.border, lineWidth: isSelected ? 0 : 0.5)
            )
    }
}

struct NavigationRow: View {
    let icon: String
    let title: String
    var subtitle: String?
    var badge: String?
    
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        let theme = colorScheme == .dark ? ThemeColors.dark : ThemeColors.light
        HStack(spacing: 14) {
            Image(systemName: icon)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(theme.accent)
                .frame(width: 36, height: 36)
                .background(theme.accent.opacity(0.12))
                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(theme.primaryText)
                if let subtitle = subtitle {
                    Text(subtitle)
                        .font(.system(size: 13))
                        .foregroundColor(theme.secondaryText)
                }
            }
            Spacer()
            if let badge = badge {
                Text(badge)
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(theme.accent)
                    .clipShape(Capsule())
            }
            Image(systemName: "chevron.right")
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(theme.tertiaryText)
        }
        .padding(.vertical, 4)
    }
}
