//
//  LifeMapScreen.swift
//  AI Life OS — World Model
//

import SwiftUI

struct LifeMapScreen: View {
    @ObservedObject private var data = MockDataStore.shared
    @ObservedObject private var motion = MotionManager.shared
    @Environment(\.colorScheme) private var colorScheme
    @State private var selectedNode: LifeMapNode?
    @State private var energyFlow: Double = 0
    @State private var nodePulse: [String: Bool] = [:]
    
    private let categories = ["Goals", "Projects", "People", "Habits", "Health", "Money", "Career", "Learning", "Family", "Relationships"]
    
    var body: some View {
        let theme = colorScheme == .dark ? ThemeColors.dark : ThemeColors.light
        
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 16) {
                ModuleHeader(title: "World Model", subtitle: "Dynamic life graph — always evolving", icon: "globe.americas.fill")
                
                // Category pills
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(categories, id: \.self) { cat in
                            ChipView(text: cat, isSelected: selectedNode?.category == cat)
                        }
                    }
                }
                
                GeometryReader { geo in
                    ZStack {
                        // Animated connections
                        ForEach(data.lifeMapNodes) { node in
                            ForEach(node.connections, id: \.self) { connId in
                                if let target = data.lifeMapNodes.first(where: { $0.id == connId }) {
                                    AnimatedConnection(
                                        from: nodePoint(node, in: geo.size),
                                        to: nodePoint(target, in: geo.size),
                                        color: theme.accent,
                                        phase: energyFlow
                                    )
                                }
                            }
                        }
                        
                        ForEach(data.lifeMapNodes) { node in
                            Button(action: {
                                selectedNode = node
                                HapticFeedback.selection()
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                                    nodePulse[node.id] = true
                                }
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                    nodePulse[node.id] = false
                                }
                            }) {
                                WorldModelNode(
                                    node: node,
                                    isSelected: selectedNode?.id == node.id,
                                    isPulsing: nodePulse[node.id] ?? false,
                                    theme: theme
                                )
                            }
                            .position(
                                x: nodePoint(node, in: geo.size).x + motion.parallaxOffset.width * 0.12,
                                y: nodePoint(node, in: geo.size).y + motion.parallaxOffset.height * 0.12
                            )
                        }
                    }
                }
                .frame(height: 360)
                .glassSurface()
                
                if let node = selectedNode {
                    GlassCard {
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text(node.title)
                                    .font(.system(size: 20, weight: .bold, design: .rounded))
                                    .foregroundColor(theme.primaryText)
                                Spacer()
                                Text("\(Int(node.strength * 100))%")
                                    .font(.system(size: 18, weight: .bold, design: .monospaced))
                                    .foregroundColor(theme.accent)
                                    .glow(theme.accent, radius: 4)
                            }
                            Text("Category: \(node.category)")
                                .foregroundColor(theme.secondaryText)
                            Text("\(node.connections.count) connected domains")
                                .font(.system(size: 13, weight: .medium))
                                .foregroundColor(theme.accent)
                            
                            HStack(spacing: 8) {
                                ForEach(node.connections, id: \.self) { connId in
                                    if let linked = data.lifeMapNodes.first(where: { $0.id == connId }) {
                                        ChipView(text: linked.title)
                                    }
                                }
                            }
                        }
                    }
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                }
                
                // Domain stats
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                    ForEach(data.lifeMapNodes) { node in
                        HStack {
                            Circle()
                                .fill(theme.accent)
                                .frame(width: 6, height: 6)
                            Text(node.title)
                                .font(.system(size: 13, weight: .medium))
                                .foregroundColor(theme.primaryText)
                            Spacer()
                            Text("\(Int(node.strength * 100))%")
                                .font(.system(size: 12, weight: .bold, design: .monospaced))
                                .foregroundColor(theme.accent)
                        }
                        .padding(10)
                        .glassSurface(cornerRadius: 10)
                    }
                }
            }
            .padding(AppTheme.padding)
        }
        .futuristicBackground()
        .navigationBarHidden(true)
        .onAppear {
            withAnimation(.linear(duration: 4).repeatForever(autoreverses: false)) {
                energyFlow = 1
            }
        }
    }
    
    private func nodePoint(_ node: LifeMapNode, in size: CGSize) -> CGPoint {
        CGPoint(x: node.x * size.width, y: node.y * size.height)
    }
}

struct WorldModelNode: View {
    let node: LifeMapNode
    let isSelected: Bool
    let isPulsing: Bool
    let theme: ThemeColors
    @State private var floatOffset: CGFloat = 0
    
    var body: some View {
        VStack(spacing: 4) {
            ZStack {
                if isPulsing {
                    EnergyPulseRing(color: theme.accent, size: 60)
                }
                Circle()
                    .fill(
                        LinearGradient(colors: [theme.gradientStart, theme.gradientEnd], startPoint: .topLeading, endPoint: .bottomTrailing)
                    )
                    .frame(width: 44 + CGFloat(node.strength * 20), height: 44 + CGFloat(node.strength * 20))
                    .glow(theme.accent, radius: isSelected ? 14 : 6, intensity: isSelected ? 0.8 : 0.4)
                Text(String(node.title.prefix(1)))
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.white)
            }
            Text(node.title)
                .font(.system(size: 11, weight: .semibold))
                .foregroundColor(theme.primaryText)
        }
        .scaleEffect(isSelected ? 1.12 : 1.0)
        .offset(y: floatOffset)
        .animation(AppTheme.springAnimation, value: isSelected)
        .onAppear {
            withAnimation(.easeInOut(duration: Double.random(in: 2...4)).repeatForever(autoreverses: true)) {
                floatOffset = CGFloat.random(in: -3...3)
            }
        }
    }
}

struct AnimatedConnection: View {
    let from: CGPoint
    let to: CGPoint
    let color: Color
    let phase: Double
    
    var body: some View {
        Path { path in
            path.move(to: from)
            let mid = CGPoint(x: (from.x + to.x) / 2, y: (from.y + to.y) / 2)
            let dx = to.x - from.x
            let dy = to.y - from.y
            let control = CGPoint(x: mid.x - dy * 0.1, y: mid.y + dx * 0.1)
            path.addQuadCurve(to: to, control: control)
        }
        .stroke(
            color.opacity(0.15 + phase * 0.2),
            style: StrokeStyle(lineWidth: 1.5, lineCap: .round, dash: [6, 8], dashPhase: phase * 20)
        )
    }
}
