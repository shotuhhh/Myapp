//
//  LifeMapScreen.swift
//  AI Life OS
//

import SwiftUI

struct LifeMapScreen: View {
    @ObservedObject private var data = MockDataStore.shared
    @Environment(\.colorScheme) private var colorScheme
    @State private var selectedNode: LifeMapNode?
    
    var body: some View {
        let theme = colorScheme == .dark ? ThemeColors.dark : ThemeColors.light
        
        VStack(alignment: .leading, spacing: 16) {
            Text("Life Map")
                .font(.system(size: 34, weight: .bold, design: .rounded))
                .foregroundColor(theme.primaryText)
                .padding(.horizontal, AppTheme.padding)
                .padding(.top, 8)
            
            GeometryReader { geo in
                ZStack {
                    // Connections
                    ForEach(data.lifeMapNodes) { node in
                        ForEach(node.connections, id: \.self) { connId in
                            if let target = data.lifeMapNodes.first(where: { $0.id == connId }) {
                                Path { path in
                                    let start = CGPoint(x: node.x * geo.size.width, y: node.y * geo.size.height)
                                    let end = CGPoint(x: target.x * geo.size.width, y: target.y * geo.size.height)
                                    path.move(to: start)
                                    path.addLine(to: end)
                                }
                                .stroke(theme.accent.opacity(0.25), lineWidth: 2)
                            }
                        }
                    }
                    
                    ForEach(data.lifeMapNodes) { node in
                        Button(action: { selectedNode = node; HapticFeedback.selection() }) {
                            VStack(spacing: 4) {
                                Circle()
                                    .fill(
                                        LinearGradient(colors: [theme.gradientStart, theme.gradientEnd], startPoint: .topLeading, endPoint: .bottomTrailing)
                                    )
                                    .frame(width: 44 + CGFloat(node.strength * 20), height: 44 + CGFloat(node.strength * 20))
                                    .overlay(
                                        Text(String(node.title.prefix(1)))
                                            .font(.system(size: 16, weight: .bold))
                                            .foregroundColor(.white)
                                    )
                                    .shadow(color: theme.accent.opacity(0.4), radius: selectedNode?.id == node.id ? 12 : 4)
                                Text(node.title)
                                    .font(.system(size: 11, weight: .semibold))
                                    .foregroundColor(theme.primaryText)
                            }
                            .position(x: node.x * geo.size.width, y: node.y * geo.size.height)
                            .scaleEffect(selectedNode?.id == node.id ? 1.1 : 1.0)
                            .animation(AppTheme.springAnimation, value: selectedNode?.id)
                        }
                    }
                }
            }
            .padding(.horizontal, AppTheme.padding)
            
            if let node = selectedNode {
                GlassCard {
                    VStack(alignment: .leading, spacing: 6) {
                        Text(node.title)
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(theme.primaryText)
                        Text("Category: \(node.category)")
                            .foregroundColor(theme.secondaryText)
                        Text("Strength: \(Int(node.strength * 100))%")
                            .foregroundColor(theme.accent)
                    }
                }
                .padding(.horizontal, AppTheme.padding)
                .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
        .themedBackground()
        .navigationBarHidden(true)
    }
}
