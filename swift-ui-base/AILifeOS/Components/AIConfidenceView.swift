//
//  AIConfidenceView.swift
//  AI Life OS
//

import SwiftUI

struct AIConfidenceView: View {
    @ObservedObject private var liveAI = LiveAIActivityStore.shared
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        let theme = colorScheme == .dark ? ThemeColors.dark : ThemeColors.light
        
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "waveform.path.ecg")
                    .foregroundColor(theme.accent)
                Text("AI Confidence")
                    .font(.system(size: 16, weight: .bold, design: .rounded))
                    .foregroundColor(theme.primaryText)
                Spacer()
                Text("Live")
                    .font(.system(size: 10, weight: .bold))
                    .foregroundColor(theme.success)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 3)
                    .background(Capsule().fill(theme.success.opacity(0.15)))
            }
            
            ForEach(liveAI.confidenceItems) { item in
                ConfidenceRow(item: item, theme: theme)
            }
        }
        .padding(AppTheme.padding)
        .glassSurface()
    }
}

struct ConfidenceRow: View {
    let item: AIConfidenceItem
    let theme: ThemeColors
    @State private var animatedConfidence: Double = 0
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text(item.recommendation)
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(theme.primaryText)
                    .lineLimit(2)
                Spacer()
                HStack(spacing: 2) {
                    Image(systemName: item.trend >= 0 ? "arrow.up" : "arrow.down")
                        .font(.system(size: 9, weight: .bold))
                    Text("\(Int(animatedConfidence * 100))%")
                        .font(.system(size: 13, weight: .bold, design: .monospaced))
                }
                .foregroundColor(confidenceColor)
            }
            
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(theme.border.opacity(0.3))
                        .frame(height: 4)
                    Capsule()
                        .fill(
                            LinearGradient(
                                colors: [confidenceColor.opacity(0.7), confidenceColor],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(width: geo.size.width * animatedConfidence, height: 4)
                        .glow(confidenceColor, radius: 4, intensity: 0.4)
                }
            }
            .frame(height: 4)
            
            Text(item.category)
                .font(.system(size: 10, weight: .medium))
                .foregroundColor(theme.tertiaryText)
        }
        .padding(.vertical, 4)
        .onAppear { animatedConfidence = item.confidence }
        .onChange(of: item.confidence) { newVal in
            withAnimation(.spring(response: 0.8, dampingFraction: 0.75)) {
                animatedConfidence = newVal
            }
        }
    }
    
    private var confidenceColor: Color {
        if item.confidence >= 0.85 { return theme.success }
        if item.confidence >= 0.7 { return theme.accent }
        return theme.warning
    }
}
