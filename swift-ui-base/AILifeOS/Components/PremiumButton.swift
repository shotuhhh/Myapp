//
//  PremiumButton.swift
//  AI Life OS
//

import SwiftUI

struct PremiumButton: View {
    let title: String
    let icon: String?
    let style: ButtonStyle
    let action: () -> Void
    
    @Environment(\.colorScheme) private var colorScheme
    enum ButtonStyle {
        case primary, secondary, ghost, destructive
    }
    
    init(_ title: String, icon: String? = nil, style: ButtonStyle = .primary, action: @escaping () -> Void) {
        self.title = title
        self.icon = icon
        self.style = style
        self.action = action
    }
    
  private var theme: ThemeColors {
        colorScheme == .dark ? ThemeColors.dark : ThemeColors.light
    }
    
    var body: some View {
        Button(action: {
            HapticFeedback.light()
            action()
        }) {
            HStack(spacing: 8) {
                if let icon = icon {
                    Image(systemName: icon)
                        .font(.system(size: 15, weight: .semibold))
                }
                Text(title)
                    .font(.system(size: 16, weight: .semibold, design: .rounded))
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .foregroundColor(foregroundColor)
            .background(background)
            .clipShape(RoundedRectangle(cornerRadius: AppTheme.smallRadius, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: AppTheme.smallRadius, style: .continuous)
                    .stroke(borderColor, lineWidth: style == .ghost ? 1 : 0)
            )
        }
        .buttonStyle(PressableButtonStyle())
        .accessibilityLabel(title)
    }
    
    private var foregroundColor: Color {
        switch style {
        case .primary: return .white
        case .secondary: return theme.accent
        case .ghost: return theme.primaryText
        case .destructive: return .white
        }
    }
    
    @ViewBuilder
    private var background: some View {
        switch style {
        case .primary:
            LinearGradient(colors: [theme.gradientStart, theme.gradientEnd], startPoint: .leading, endPoint: .trailing)
        case .secondary:
            theme.accent.opacity(0.15)
        case .ghost:
            Color.clear
        case .destructive:
            theme.error
        }
    }
    
    private var borderColor: Color {
        style == .ghost ? theme.border : .clear
    }
}

struct PressableButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.96 : 1.0)
            .animation(AppTheme.quickAnimation, value: configuration.isPressed)
    }
}

struct IconButton: View {
    let icon: String
    let action: () -> Void
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        Button(action: {
            HapticFeedback.selection()
            action()
        }) {
            Image(systemName: icon)
                .font(.system(size: 17, weight: .semibold))
                .foregroundColor(theme.primaryText)
                .frame(width: 40, height: 40)
                .background(
                    Circle()
                        .fill(theme.cardBackground)
                        .shadow(color: .black.opacity(0.06), radius: 4, x: 0, y: 2)
                )
        }
        .buttonStyle(PressableButtonStyle())
    }
    
    private var theme: ThemeColors {
        colorScheme == .dark ? ThemeColors.dark : ThemeColors.light
    }
}
