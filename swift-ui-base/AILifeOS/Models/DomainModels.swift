//
//  DomainModels.swift
//  AI Life OS
//

import Foundation
import SwiftUI

struct LifeUser: Identifiable, Hashable {
    let id: String
    let name: String
    let email: String
    let avatarSymbol: String
    let plan: String
    let streakDays: Int
    let focusScore: Int
    let bio: String
}

struct ChatMessage: Identifiable, Hashable {
    let id: String
    let role: MessageRole
    let content: String
    let timestamp: Date
    var isLoading: Bool = false
    
    enum MessageRole: String, Hashable {
        case user, assistant, system
    }
}

struct MemoryItem: Identifiable, Hashable {
    let id: String
    let title: String
    let summary: String
    let category: String
    let date: Date
    let importance: Int
    let tags: [String]
}

struct GoalItem: Identifiable, Hashable {
    let id: String
    let title: String
    let description: String
    let progress: Double
    let deadline: Date
    let category: String
    let milestones: [String]
}

struct ProjectItem: Identifiable, Hashable {
    let id: String
    let name: String
    let status: ProjectStatus
    let progress: Double
    let dueDate: Date
    let teamSize: Int
    let tasksCompleted: Int
    let tasksTotal: Int
    
    enum ProjectStatus: String, Hashable {
        case active, paused, completed, planning
    }
}

struct HabitItem: Identifiable, Hashable {
    let id: String
    let name: String
    let icon: String
    let streak: Int
    let completionRate: Double
    let frequency: String
    let completedToday: Bool
}

struct CalendarEvent: Identifiable, Hashable {
    let id: String
    let title: String
    let start: Date
    let end: Date
    let colorName: String
    let location: String?
    
    var color: Color {
        switch colorName {
        case "blue": return .blue
        case "purple": return .purple
        case "green": return .green
        case "orange": return .orange
        default: return .blue
        }
    }
}

struct InsightItem: Identifiable, Hashable {
    let id: String
    let title: String
    let body: String
    let category: String
    let impact: String
    let date: Date
}

struct PredictionItem: Identifiable, Hashable {
    let id: String
    let title: String
    let probability: Double
    let timeframe: String
    let recommendation: String
}

struct AnalyticsMetric: Identifiable, Hashable {
    let id: String
    let label: String
    let value: String
    let change: Double
    let icon: String
}

struct ProgressSnapshot: Identifiable, Hashable {
    let id: String
    let area: String
    let score: Int
    let trend: Double
    let icon: String
}

struct NotificationItem: Identifiable, Hashable {
    let id: String
    let title: String
    let message: String
    let date: Date
    let type: NotificationType
    var isRead: Bool
    
    enum NotificationType: String, Hashable {
        case reminder, insight, achievement, system, social
    }
}

struct LifeMapNode: Identifiable, Hashable {
    let id: String
    let title: String
    let category: String
    let x: CGFloat
    let y: CGFloat
    let connections: [String]
    let strength: Double
}

struct SubscriptionPlan: Identifiable, Hashable {
    let id: String
    let name: String
    let price: String
    let period: String
    let features: [String]
    let isPopular: Bool
}

struct SearchResult: Identifiable, Hashable {
    let id: String
    let title: String
    let subtitle: String
    let icon: String
    let route: AppRoute
}

enum ContentState: Equatable {
    case loading
    case loaded
    case empty
    case error(String)
    case success(String)
}

struct AIDNATrait: Identifiable, Hashable {
    let id: String
    let name: String
    let value: Double
    let trend: Double
    let lastUpdated: Date
    let source: String
}

struct KnowledgeLink: Identifiable, Hashable {
    let id: String
    let from: String
    let to: String
    let strength: Double
    let discovery: String
}

struct FutureScenario: Identifiable, Hashable {
    let id: String
    let name: String
    let probability: Double
    let risk: String
    let outcome: String
    let recommendation: String
}

struct DecisionOption: Identifiable, Hashable {
    let id: String
    let title: String
    let score: Double
    let pros: [String]
    let cons: [String]
    let confidence: Double
}

struct AgentItem: Identifiable, Hashable {
    let id: String
    let name: String
    let role: String
    let status: String
    let taskProgress: Double
    let icon: String
}

struct EvolutionMetric: Identifiable, Hashable {
    let id: String
    let area: String
    let before: Double
    let after: Double
    let change: String
}

struct PersonalityDimension: Identifiable, Hashable {
    let id: String
    let name: String
    let score: Double
    let description: String
}

struct MemoryConnection: Identifiable, Hashable {
    let fromId: String
    let toId: String
    let strength: Double
    var id: String { "\(fromId)-\(toId)" }
}

struct ExtendedMemoryItem: Identifiable, Hashable {
    let id: String
    let title: String
    let summary: String
    let category: String
    let date: Date
    let importance: Int
    let tags: [String]
    let emotionalImpact: Double
    let goalImpact: Double
    let futureImpact: Double
    let connections: [String]
    let x: CGFloat
    let y: CGFloat
}

struct TrustMetric: Identifiable, Hashable {
    let id: String
    let category: String
    let score: Double
    let factors: [String]
}

struct CuriosityProbe: Identifiable, Hashable {
    let id: String
    let question: String
    let relevance: Double
    let status: String
}

struct GoalEvolutionEntry: Identifiable, Hashable {
    let id: String
    let goalTitle: String
    let previousState: String
    let currentState: String
    let aiAdjustment: String
    let date: Date
}

struct IntegrationItem: Identifiable, Hashable {
    let id: String
    let name: String
    let icon: String
    let connected: Bool
    let lastSync: Date?
}

struct SecurityItem: Identifiable, Hashable {
    let id: String
    let title: String
    let status: String
    let detail: String
    let icon: String
}
