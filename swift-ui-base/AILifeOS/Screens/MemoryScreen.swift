//
//  MemoryScreen.swift
//  AI Life OS — Universal Memory
//

import SwiftUI

struct MemoryScreen: View {
    @ObservedObject private var data = MockDataStore.shared
    @ObservedObject private var motion = MotionManager.shared
    @EnvironmentObject var appState: AppState
    @Environment(\.colorScheme) private var colorScheme
    @State private var selectedMemory: ExtendedMemoryItem?
    @State private var showGraph = true
    @State private var pulsePhase: Double = 0
    
    var body: some View {
        let theme = colorScheme == .dark ? ThemeColors.dark : ThemeColors.light
        
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 16) {
                ModuleHeader(title: "Universal Memory", subtitle: "Living memory with connections & impact", icon: "brain.head.profile")
                
                HStack {
                    Button(action: { showGraph = true; HapticFeedback.selection() }) {
                        ChipView(text: "Graph View", isSelected: showGraph)
                    }
                    Button(action: { showGraph = false; HapticFeedback.selection() }) {
                        ChipView(text: "List View", isSelected: !showGraph)
                    }
                }
                
                if showGraph {
                    memoryGraph(theme: theme)
                        .frame(height: 280)
                }
                
                ForEach(data.extendedMemories) { memory in
                    Button(action: { selectedMemory = memory; HapticFeedback.selection() }) {
                        GlassCard {
                            VStack(alignment: .leading, spacing: 10) {
                                HStack {
                                    Text(memory.title)
                                        .font(.system(size: 17, weight: .semibold))
                                        .foregroundColor(theme.primaryText)
                                    Spacer()
                                    importanceStars(memory.importance, theme: theme)
                                }
                                Text(memory.summary)
                                    .font(.system(size: 14))
                                    .foregroundColor(theme.secondaryText)
                                
                                HStack(spacing: 12) {
                                    impactBadge("Emotional", value: memory.emotionalImpact, color: .pink, theme: theme)
                                    impactBadge("Goal", value: memory.goalImpact, color: .blue, theme: theme)
                                    impactBadge("Future", value: memory.futureImpact, color: .purple, theme: theme)
                                }
                                
                                HStack {
                                    ForEach(memory.tags.prefix(3), id: \.self) { tag in
                                        ChipView(text: tag)
                                    }
                                    if !memory.connections.isEmpty {
                                        Spacer()
                                        HStack(spacing: 4) {
                                            Image(systemName: "link")
                                                .font(.system(size: 10))
                                            Text("\(memory.connections.count) links")
                                                .font(.system(size: 11, weight: .medium))
                                        }
                                        .foregroundColor(theme.accent)
                                    }
                                }
                            }
                        }
                    }
                    .buttonStyle(PressableButtonStyle())
                }
            }
            .padding(AppTheme.padding)
        }
        .futuristicBackground()
        .navigationBarHidden(true)
    }
    
    private func memoryGraph(theme: ThemeColors) -> some View {
        GeometryReader { geo in
            ZStack {
                // Connections
                ForEach(data.extendedMemories) { memory in
                    ForEach(memory.connections, id: \.self) { connId in
                        if let target = data.extendedMemories.first(where: { $0.id == connId }) {
                            Path { path in
                                let start = CGPoint(x: memory.x * geo.size.width, y: memory.y * geo.size.height)
                                let end = CGPoint(x: target.x * geo.size.width, y: target.y * geo.size.height)
                                path.move(to: start)
                                path.addLine(to: end)
                            }
                            .stroke(
                                theme.accent.opacity(0.2 + pulsePhase * 0.15),
                                style: StrokeStyle(lineWidth: 1.5, dash: [4, 6], dashPhase: pulsePhase * 10)
                            )
                        }
                    }
                }
                
                ForEach(data.extendedMemories) { memory in
                    let size = 30 + CGFloat(memory.importance) * 6
                    ZStack {
                        Circle()
                            .fill(
                                RadialGradient(
                                    colors: [theme.accent, theme.accentSecondary.opacity(0.6)],
                                    center: .center,
                                    startRadius: 0,
                                    endRadius: size / 2
                                )
                            )
                            .frame(width: size, height: size)
                            .glow(theme.accent, radius: selectedMemory?.id == memory.id ? 12 : 4, intensity: 0.5)
                        Text(String(memory.title.prefix(1)))
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(.white)
                    }
                    .position(
                        x: memory.x * geo.size.width + motion.parallaxOffset.width * 0.1,
                        y: memory.y * geo.size.height + motion.parallaxOffset.height * 0.1
                    )
                    .scaleEffect(selectedMemory?.id == memory.id ? 1.2 : 1.0)
                    .animation(AppTheme.springAnimation, value: selectedMemory?.id)
                }
            }
            .glassSurface()
        }
        .onAppear {
            withAnimation(.linear(duration: 3).repeatForever(autoreverses: false)) {
                pulsePhase = 1
            }
        }
    }
    
    private func importanceStars(_ level: Int, theme: ThemeColors) -> some View {
        HStack(spacing: 2) {
            ForEach(0..<level, id: \.self) { _ in
                Image(systemName: "star.fill")
                    .font(.system(size: 10))
                    .foregroundColor(theme.warning)
            }
        }
    }
    
    private func impactBadge(_ label: String, value: Double, color: Color, theme: ThemeColors) -> some View {
        VStack(spacing: 2) {
            Text(label)
                .font(.system(size: 9, weight: .bold))
                .foregroundColor(theme.tertiaryText)
            Text("\(Int(value * 100))%")
                .font(.system(size: 12, weight: .bold, design: .monospaced))
                .foregroundColor(color)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(RoundedRectangle(cornerRadius: 8).fill(color.opacity(0.1)))
    }
}
