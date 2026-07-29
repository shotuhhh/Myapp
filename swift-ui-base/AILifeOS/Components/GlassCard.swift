//
//  GlassCard.swift
//  AI Life OS
//

import SwiftUI

struct GlassCard<Content: View>: View {
    let content: Content
    var padding: CGFloat = AppTheme.padding
    
    @Environment(\.colorScheme) private var colorScheme
    
    init(padding: CGFloat = AppTheme.padding, @ViewBuilder content: () -> Content) {
        self.padding = padding
        self.content = content()
    }
    
    var body: some View {
        content
            .padding(padding)
            .glassSurface()
    }
    
    private var theme: ThemeColors {
        colorScheme == .dark ? ThemeColors.dark : ThemeColors.light
    }
}

struct GradientHeaderCard: View {
    let title: String
    let subtitle: String
    let icon: String
    
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        let theme = colorScheme == .dark ? ThemeColors.dark : ThemeColors.light
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(colors: [theme.gradientStart, theme.gradientEnd], startPoint: .topLeading, endPoint: .bottomTrailing)
                    )
                    .frame(width: 52, height: 52)
                Image(systemName: icon)
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundColor(.white)
            }
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .foregroundColor(theme.primaryText)
                Text(subtitle)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(theme.secondaryText)
            }
            Spacer()
        }
        .padding(AppTheme.padding)
        .background(
            RoundedRectangle(cornerRadius: AppTheme.cardRadius, style: .continuous)
                .fill(theme.cardBackground)
        )
    }
}
