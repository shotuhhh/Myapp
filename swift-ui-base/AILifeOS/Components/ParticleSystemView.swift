//
//  ParticleSystemView.swift
//  AI Life OS
//

import SwiftUI

struct Particle: Identifiable {
    let id = UUID()
    var x: CGFloat
    var y: CGFloat
    var size: CGFloat
    var opacity: Double
    var speed: CGFloat
    var hue: Double
}

struct ParticleSystemView: View {
  let count: Int
    var intensity: Double = 1.0
    
    @ObservedObject private var motion = MotionManager.shared
    @State private var particles: [Particle] = []
    @State private var timer: Timer?
    
    var body: some View {
        GeometryReader { geo in
            Canvas { context, size in
                for particle in particles {
                    let rect = CGRect(
                        x: particle.x * size.width + motion.parallaxOffset.width * 0.2,
                        y: particle.y * size.height + motion.parallaxOffset.height * 0.2,
                        width: particle.size,
                        height: particle.size
                    )
                    context.fill(
                        Circle().path(in: rect),
                        with: .color(Color(hue: particle.hue, saturation: 0.7, brightness: 0.9).opacity(particle.opacity * intensity))
                    )
                }
            }
            .onAppear {
                if particles.isEmpty {
                    particles = (0..<count).map { _ in
                        Particle(
                            x: CGFloat.random(in: 0...1),
                            y: CGFloat.random(in: 0...1),
                            size: CGFloat.random(in: 1.5...4),
                            opacity: Double.random(in: 0.2...0.8),
                            speed: CGFloat.random(in: 0.0003...0.001),
                            hue: Double.random(in: 0.55...0.85)
                        )
                    }
                }
                startAnimation(size: geo.size)
            }
            .onDisappear { timer?.invalidate() }
        }
        .allowsHitTesting(false)
    }
    
    private func startAnimation(size: CGSize) {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0 / 30.0, repeats: true) { _ in
            for i in particles.indices {
                particles[i].y -= particles[i].speed
                particles[i].x += sin(particles[i].y * 20) * 0.0002
                if particles[i].y < -0.05 {
                    particles[i].y = 1.05
                    particles[i].x = CGFloat.random(in: 0...1)
                }
            }
        }
    }
}
