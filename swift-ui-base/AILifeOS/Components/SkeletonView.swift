//
//  SkeletonView.swift
//  AI Life OS
//

import SwiftUI

struct SkeletonView: View {
    var height: CGFloat = 16
    var cornerRadius: CGFloat = 8
    
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
            .fill(baseColor)
            .frame(height: height)
            .shimmer()
    }
    
    private var baseColor: Color {
        colorScheme == .dark ? Color.white.opacity(0.08) : Color.black.opacity(0.06)
    }
}

struct SkeletonCard: View {
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            SkeletonView(height: 20, cornerRadius: 6)
            SkeletonView(height: 14, cornerRadius: 6)
                .frame(maxWidth: .infinity)
            SkeletonView(height: 14, cornerRadius: 6)
                .frame(width: 180)
        }
        .padding(AppTheme.padding)
        .background(
            RoundedRectangle(cornerRadius: AppTheme.cardRadius, style: .continuous)
                .fill(colorScheme == .dark ? ThemeColors.dark.cardBackground : ThemeColors.light.cardBackground)
        )
    }
}

struct LoadingSkeletonList: View {
    let count: Int
    
    init(count: Int = 4) {
        self.count = count
    }
    
    var body: some View {
        VStack(spacing: 12) {
            ForEach(0..<count, id: \.self) { i in
                SkeletonCard()
                    .fadeIn(delay: Double(i) * 0.08)
            }
        }
    }
}
