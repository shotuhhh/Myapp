//
//  LivingUniverseView.swift
//  AI Life OS
//

import SwiftUI

struct BrainNode: Identifiable, Hashable {
    let id: String
    let title: String
    let icon: String
    let angle: Double
    let distance: CGFloat
    let color: Color
    let route: AppRoute
}

struct LivingUniverseView: View {
    @ObservedObject private var motion = MotionManager.shared
    @ObservedObject private var liveAI = LiveAIActivityStore.shared
    @EnvironmentObject var appState: AppState
    @Environment(\.colorScheme) private var colorScheme
    
    @State private var breathe: CGFloat = 1.0
    @State private var rotation: Double = 0
    @State private var energyPhase: Double = 0
    @State private var selectedNode: BrainNode?
    
    let nodes: [BrainNode] = [
        BrainNode(id: "memory", title: "Memory", icon: "brain.head.profile", angle: 0, distance: 0.42, color: .purple, route: .memory),
        BrainNode(id: "goals", title: "Goals", icon: "target", angle: 30, distance: 0.42, color: .blue, route: .goals),
        BrainNode(id: "planning", title: "Planning", icon: "calendar.badge.clock", angle: 60, distance: 0.42, color: .cyan, route: .calendar),
        BrainNode(id: "knowledge", title: "Knowledge", icon: "books.vertical.fill", angle: 90, distance: 0.42, color: .indigo, route: .knowledgeFusion),
        BrainNode(id: "health", title: "Health", icon: "heart.fill", angle: 120, distance: 0.42, color: .pink, route: .habits),
        BrainNode(id: "finance", title: "Finance", icon: "dollarsign.circle.fill", angle: 150, distance: 0.42, color: .green, route: .analytics),
        BrainNode(id: "prediction", title: "Prediction", icon: "chart.line.uptrend.xyaxis", angle: 180, distance: 0.42, color: .orange, route: .predictions),
        BrainNode(id: "decision", title: "Decision", icon: "arrow.triangle.branch", angle: 210, distance: 0.42, color: .yellow, route: .decisionEngine),
        BrainNode(id: "analysis", title: "Analysis", icon: "chart.bar.fill", angle: 240, distance: 0.42, color: .teal, route: .analytics),
        BrainNode(id: "emotions", title: "Emotions", icon: "heart.text.square.fill", angle: 270, distance: 0.42, color: .red, route: .personality),
        BrainNode(id: "personality", title: "Personality", icon: "person.crop.circle.badge.checkmark", angle: 300, distance: 0.42, color: .mint, route: .personality),
        BrainNode(id: "world", title: "World Model", icon: "globe.americas.fill", angle: 330, distance: 0.42, color: Color("AccentPrimary"), route: .lifeMap)
    ]
    
    var body: some View {
        let theme = colorScheme == .dark ? ThemeColors.dark : ThemeColors.light
        
        GeometryReader { geo in
            let center = CGPoint(x: geo.size.width / 2, y: geo.size.height / 2)
            let radius = min(geo.size.width, geo.size.height) / 2
            
            ZStack {
                // Energy connections
                ForEach(nodes) { node in
                    let nextIdx = (nodes.firstIndex(of: node)! + 1) % nodes.count
                    let next = nodes[nextIdx]
                    EnergyConnection(
                        from: nodePosition(node, center: center, radius: radius),
                        to: nodePosition(next, center: center, radius: radius),
                        phase: energyPhase,
                        color: theme.accent
                    )
                }
                
                // Center core
                ZStack {
                    BreathingGlow(color: theme.accent, size: radius * 0.9)
                    EnergyPulseRing(color: theme.accentSecondary, size: radius * 0.55)
                    EnergyPulseRing(color: theme.accent, size: radius * 0.7)
                    
                    ZStack {
                        Circle()
                            .fill(
                                RadialGradient(
                                    colors: [theme.accent, theme.accentSecondary, theme.accent.opacity(0.3)],
                                    center: .center,
                                    startRadius: 5,
                                    endRadius: radius * 0.25
                                )
                            )
                            .frame(width: radius * 0.45, height: radius * 0.45)
                            .scaleEffect(breathe)
                            .glow(theme.accent, radius: 20, intensity: 0.8)
                        
                        Image(systemName: "sparkles")
                            .font(.system(size: radius * 0.12, weight: .semibold))
                            .foregroundColor(.white)
                            .scaleEffect(breathe)
                    }
                    .rotation3DEffect(.degrees(motion.tiltRotation), axis: (x: 0, y: 1, z: 0))
                    .offset(motion.parallaxOffset)
                }
                .position(center)
                
                // Orbiting nodes
                ForEach(nodes) { node in
                    let pos = nodePosition(node, center: center, radius: radius)
                    AINodeOrb(
                        node: node,
                        isSelected: selectedNode?.id == node.id,
                        size: radius * 0.11
                    ) {
                        selectedNode = node
                        HapticFeedback.selection()
                        appState.navigate(to: node.route)
                    }
                    .position(
                        x: pos.x + motion.parallaxOffset.width * 0.15,
                        y: pos.y + motion.parallaxOffset.height * 0.15
                    )
                }
            }
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 3.0).repeatForever(autoreverses: true)) {
                breathe = 1.08
            }
            withAnimation(.linear(duration: 120).repeatForever(autoreverses: false)) {
                rotation = 360
            }
            withAnimation(.linear(duration: 4).repeatForever(autoreverses: false)) {
                energyPhase = 1
            }
        }
    }
    
    private func nodePosition(_ node: BrainNode, center: CGPoint, radius: CGFloat) -> CGPoint {
        let rad = (node.angle + rotation * 0.02) * .pi / 180
        let dist = radius * node.distance
        return CGPoint(
            x: center.x + cos(rad) * dist,
            y: center.y + sin(rad) * dist
        )
    }
}

struct AINodeOrb: View {
    let node: BrainNode
    var isSelected: Bool
    var size: CGFloat
    var action: () -> Void
    
    @State private var floatOffset: CGFloat = 0
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [node.color, node.color.opacity(0.6)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: size, height: size)
                        .glow(node.color, radius: isSelected ? 16 : 8, intensity: isSelected ? 0.9 : 0.5)
                    
                    Image(systemName: node.icon)
                        .font(.system(size: size * 0.35, weight: .semibold))
                        .foregroundColor(.white)
                }
                .scaleEffect(isSelected ? 1.15 : 1.0)
                
                Text(node.title)
                    .font(.system(size: max(8, size * 0.22), weight: .semibold, design: .rounded))
                    .foregroundColor(.primary.opacity(0.85))
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)
            }
            .offset(y: floatOffset)
        }
        .buttonStyle(.plain)
        .onAppear {
            withAnimation(.easeInOut(duration: Double.random(in: 2...3.5)).repeatForever(autoreverses: true)) {
                floatOffset = CGFloat.random(in: -4...4)
            }
        }
    }
}

struct EnergyConnection: View {
    let from: CGPoint
    let to: CGPoint
    let phase: Double
    let color: Color
    
    var body: some View {
        Path { path in
            path.move(to: from)
            let mid = CGPoint(x: (from.x + to.x) / 2, y: (from.y + to.y) / 2)
            let dx = to.x - from.x
            let dy = to.y - from.y
            let perp = CGPoint(x: -dy * 0.15, y: dx * 0.15)
            let control = CGPoint(x: mid.x + perp.x, y: mid.y + perp.y)
            path.addQuadCurve(to: to, control: control)
        }
        .stroke(
            LinearGradient(
                colors: [color.opacity(0.05), color.opacity(0.3 + phase * 0.2), color.opacity(0.05)],
                startPoint: .leading,
                endPoint: .trailing
            ),
            style: StrokeStyle(lineWidth: 1.5, lineCap: .round, dash: [4, 8], dashPhase: phase * 20)
        )
    }
}
