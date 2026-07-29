//
//  LiveAIActivityStore.swift
//  AI Life OS
//

import Foundation
import Combine
import SwiftUI

struct AIActivity: Identifiable, Hashable {
    let id: String
    let message: String
    let icon: String
    let timestamp: Date
    let module: String
}

struct AIConfidenceItem: Identifiable, Hashable {
    let id: String
    let recommendation: String
    let confidence: Double
    let trend: Double
    let category: String
}

final class LiveAIActivityStore: ObservableObject {
    static let shared = LiveAIActivityStore()
    
    @Published var currentActivity: AIActivity
    @Published var recentActivities: [AIActivity] = []
    @Published var confidenceItems: [AIConfidenceItem] = []
    @Published var isThinking = true
    @Published var neuralPulse: Double = 0
    
    private var timer: Timer?
    private var confidenceTimer: Timer?
    
    private let activityPool: [(String, String, String)] = [
        ("Memory indexing", "brain.head.profile", "Memory"),
        ("Finding hidden patterns", "link", "Knowledge Fusion"),
        ("Updating goals", "target", "Goal Evolution"),
        ("Forecast generation", "chart.line.uptrend.xyaxis", "Future Simulation"),
        ("Planning tomorrow", "calendar.badge.clock", "Planning"),
        ("Updating AI DNA", "dna", "AI DNA"),
        ("Cross-referencing memories", "arrow.triangle.branch", "Memory"),
        ("Simulating scenarios", "sparkle.magnifyingglass", "Future Simulation"),
        ("Trust calibration", "shield.checkered", "Trust Engine"),
        ("Agent coordination", "person.3.fill", "Multi-Agent"),
        ("Emotional pattern scan", "heart.text.square", "Emotions"),
        ("World model sync", "globe.americas.fill", "World Model"),
        ("Decision tree pruning", "arrow.triangle.merge", "Decision Engine"),
        ("Curiosity probe active", "questionmark.circle", "Curiosity"),
        ("Self-evolution cycle", "arrow.triangle.2.circlepath", "Self Evolution"),
        ("Knowledge graph weave", "point.3.connected.trianglepath.dotted", "Knowledge Fusion"),
        ("Health correlation", "heart.fill", "Health"),
        ("Finance projection", "dollarsign.circle", "Finance"),
        ("Personality refinement", "person.crop.circle.badge.checkmark", "Personality"),
        ("Orchestrator sync", "gearshape.2.fill", "Orchestrator")
    ]
    
    init() {
        currentActivity = AIActivity(
            id: UUID().uuidString,
            message: "Initializing neural pathways...",
            icon: "sparkles",
            timestamp: Date(),
            module: "Core"
        )
        confidenceItems = Self.initialConfidence()
        startLiveUpdates()
    }
    
    private static func initialConfidence() -> [AIConfidenceItem] {
        [
            AIConfidenceItem(id: "c1", recommendation: "Schedule deep work 9–11 AM", confidence: 0.91, trend: 0.02, category: "Productivity"),
            AIConfidenceItem(id: "c2", recommendation: "Prioritize investor deck today", confidence: 0.87, trend: -0.01, category: "Career"),
            AIConfidenceItem(id: "c3", recommendation: "Evening run before 7 PM", confidence: 0.78, trend: 0.05, category: "Health"),
            AIConfidenceItem(id: "c4", recommendation: "Journal before sleep", confidence: 0.84, trend: 0.03, category: "Wellness")
        ]
    }
    
    func startLiveUpdates() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 2.8, repeats: true) { [weak self] _ in
            self?.cycleActivity()
        }
        confidenceTimer?.invalidate()
        confidenceTimer = Timer.scheduledTimer(withTimeInterval: 4.5, repeats: true) { [weak self] _ in
            self?.updateConfidence()
        }
        withAnimation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true)) {
            neuralPulse = 1.0
        }
    }
    
    private func cycleActivity() {
        guard let pick = activityPool.randomElement() else { return }
        let activity = AIActivity(
            id: UUID().uuidString,
            message: pick.0,
            icon: pick.1,
            timestamp: Date(),
            module: pick.2
        )
        withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
            currentActivity = activity
            recentActivities.insert(activity, at: 0)
            if recentActivities.count > 8 { recentActivities.removeLast() }
        }
    }
    
    private func updateConfidence() {
        guard !confidenceItems.isEmpty else { return }
        let idx = Int.random(in: 0..<confidenceItems.count)
        var item = confidenceItems[idx]
        let delta = Double.random(in: -0.03...0.04)
        let newConf = min(0.99, max(0.55, item.confidence + delta))
        item = AIConfidenceItem(
            id: item.id,
            recommendation: item.recommendation,
            confidence: newConf,
            trend: delta,
            category: item.category
        )
        withAnimation(.spring(response: 0.6, dampingFraction: 0.85)) {
            confidenceItems[idx] = item
        }
    }
    
    deinit {
        timer?.invalidate()
        confidenceTimer?.invalidate()
    }
}
