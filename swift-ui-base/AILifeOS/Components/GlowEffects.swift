//
//  GlowEffects.swift
//  AI Life OS
//

import SwiftUI

struct GlowModifier: ViewModifier {
    let color: Color
    var radius: CGFloat = 12
    var intensity: Double = 0.6
    
    func body(content: Content) -> some View {
        content
            .shadow(color: color.opacity(intensity), radius: radius, x: 0, y: 0)
            .shadow(color: color.opacity(intensity * 0.5), radius: radius * 2, x: 0, y: 0)
    }
}

extension View {
    func glow(_ color: Color = Color("AccentPrimary"), radius: CGFloat = 12, intensity: Double = 0.6) -> some View {
        modifier(GlowModifier(color: color, radius: radius, intensity: intensity))
    }
}

struct BreathingGlow: View {
    let color: Color
    var size: CGFloat = 120
    @State private var scale: CGFloat = 0.85
    @State private var opacity: Double = 0.4
    
    var body: some View {
        Circle()
            .fill(
                RadialGradient(
                    colors: [color.opacity(opacity), color.opacity(0.05), .clear],
                    center: .center,
                    startRadius: 0,
                    endRadius: size / 2
                )
            )
            .frame(width: size, height: size)
            .scaleEffect(scale)
            .onAppear {
                withAnimation(.easeInOut(duration: 2.5).repeatForever(autoreverses: true)) {
                    scale = 1.15
                    opacity = 0.7
                }
            }
    }
}

struct EnergyPulseRing: View {
    let color: Color
    var size: CGFloat = 100
    @State private var pulseScale: CGFloat = 1.0
    @State private var pulseOpacity: Double = 0.6
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(color.opacity(pulseOpacity), lineWidth: 2)
                .frame(width: size, height: size)
                .scaleEffect(pulseScale)
            Circle()
                .stroke(color.opacity(pulseOpacity * 0.5), lineWidth: 1)
                .frame(width: size * 0.7, height: size * 0.7)
                .scaleEffect(pulseScale * 1.1)
        }
        .onAppear {
            withAnimation(.easeOut(duration: 2.0).repeatForever(autoreverses: false)) {
                pulseScale = 1.5
                pulseOpacity = 0
            }
        }
    }
}

struct GlassSurface: ViewModifier {
    @Environment(\.colorScheme) private var colorScheme
    var cornerRadius: CGFloat = AppTheme.cardRadius
    
    func body(content: Content) -> some View {
        content
            .background(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .fill(.ultraThinMaterial)
                    .overlay(
                        RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                            .stroke(
                                LinearGradient(
                                    colors: [
                                        Color.white.opacity(colorScheme == .dark ? 0.15 : 0.4),
                                        Color.white.opacity(colorScheme == .dark ? 0.05 : 0.1)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 0.5
                            )
                    )
            )
    }
}

extension View {
    func glassSurface(cornerRadius: CGFloat = AppTheme.cardRadius) -> some View {
        modifier(GlassSurface(cornerRadius: cornerRadius))
    }
}
