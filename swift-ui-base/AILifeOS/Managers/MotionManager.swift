//
//  MotionManager.swift
//  AI Life OS
//

import CoreMotion
import SwiftUI
import Combine

final class MotionManager: ObservableObject {
    static let shared = MotionManager()
    
    @Published var roll: Double = 0
    @Published var pitch: Double = 0
    @Published var yaw: Double = 0
    
    private let motion = CMMotionManager()
    private var isRunning = false
    
    var parallaxOffset: CGSize {
        CGSize(width: CGFloat(roll) * 30, height: CGFloat(pitch) * 30)
    }
    
    var tiltRotation: Double {
        roll * 8
    }
    
    func start() {
        guard !isRunning, motion.isDeviceMotionAvailable else { return }
        isRunning = true
        motion.deviceMotionUpdateInterval = 1.0 / 60.0
        motion.startDeviceMotionUpdates(to: .main) { [weak self] data, _ in
            guard let data = data else { return }
            withAnimation(.interactiveSpring(response: 0.4, dampingFraction: 0.75)) {
                self?.roll = data.attitude.roll
                self?.pitch = data.attitude.pitch
                self?.yaw = data.attitude.yaw
            }
        }
    }
    
    func stop() {
        motion.stopDeviceMotionUpdates()
        isRunning = false
    }
}
