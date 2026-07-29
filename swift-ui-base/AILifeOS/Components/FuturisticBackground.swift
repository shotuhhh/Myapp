//
//  FuturisticBackground.swift
//  AI Life OS
//

import SwiftUI

struct FuturisticBackground: View {
    @ObservedObject private var motion = MotionManager.shared
    @Environment(\.colorScheme) private var colorScheme
    @State private var phase: CGFloat = 0
    
    var body: some View {
        ZStack {
            baseGradient
            auroraLayer
            gridLayer
            ParticleSystemView(count: colorScheme == .dark ? 60 : 30, intensity: colorScheme == .dark ? 1.0 : 0.5)
                .offset(motion.parallaxOffset)
        }
        .ignoresSafeArea()
        .onAppear { motion.start() }
        .onDisappear { motion.stop() }
    }
    
    private var baseGradient: some View {
        LinearGradient(
            colors: colorScheme == .dark
                ? [Color(red: 0.02, green: 0.02, blue: 0.08), Color(red: 0.06, green: 0.04, blue: 0.14), Color(red: 0.03, green: 0.06, blue: 0.12)]
                : [Color(red: 0.94, green: 0.95, blue: 0.98), Color(red: 0.88, green: 0.90, blue: 0.96), Color(red: 0.92, green: 0.94, blue: 0.99)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    private var auroraLayer: some View {
        ZStack {
            Circle()
                .fill(
                    RadialGradient(
                        colors: [Color("AccentPrimary").opacity(0.25), .clear],
                        center: .center,
                        startRadius: 20,
                        endRadius: 280
                    )
                )
                .frame(width: 500, height: 500)
                .offset(x: -80 + motion.parallaxOffset.width * 0.5, y: -200 + motion.parallaxOffset.height * 0.5)
                .blur(radius: 60)
            
            Circle()
                .fill(
                    RadialGradient(
                        colors: [Color("AccentSecondary").opacity(0.18), .clear],
                        center: .center,
                        startRadius: 10,
                        endRadius: 220
                    )
                )
                .frame(width: 400, height: 400)
                .offset(x: 120 + motion.parallaxOffset.width * 0.3, y: 300 + motion.parallaxOffset.height * 0.3)
                .blur(radius: 50)
        }
    }
    
    private var gridLayer: some View {
        GeometryReader { geo in
            Path { path in
                let spacing: CGFloat = 40
                var x: CGFloat = 0
                while x < geo.size.width {
                    path.move(to: CGPoint(x: x, y: 0))
                    path.addLine(to: CGPoint(x: x, y: geo.size.height))
                    x += spacing
                }
                var y: CGFloat = 0
                while y < geo.size.height {
                    path.move(to: CGPoint(x: 0, y: y))
                    path.addLine(to: CGPoint(x: geo.size.width, y: y))
                    y += spacing
                }
            }
            .stroke(Color.white.opacity(colorScheme == .dark ? 0.03 : 0.06), lineWidth: 0.5)
            .offset(motion.parallaxOffset)
        }
    }
}

struct FuturisticBackgroundModifier: ViewModifier {
    func body(content: Content) -> some View {
        ZStack {
            FuturisticBackground()
            content
        }
    }
}

extension View {
    func futuristicBackground() -> some View {
        modifier(FuturisticBackgroundModifier())
    }
}
