//
//  AppRoute.swift
//  AI Life OS
//

import Foundation

enum AppRoute: Hashable, Identifiable {
    case home
    case aiChat
    case voiceChat
    case memory
    case lifeMap
    case goals
    case projects
    case habits
    case calendar
    case insights
    case predictions
    case analytics
    case progress
    case notifications
    case settings
    case profile
    case search
    case onboarding
    case login
    case subscription
    case about
    case privacy
    // AI Life OS Modules
    case aiDNA
    case worldModel
    case futureSimulation
    case decisionEngine
    case curiosityEngine
    case goalEvolution
    case multiAgentEngine
    case knowledgeFusion
    case selfEvolution
    case trustEngine
    case lifeOSOrchestrator
    case personality
    case learning
    case adaptation
    case hiddenRelations
    case integrations
    case security
    case planning
    case assistant
    
    var id: String {
        switch self {
        case .home: return "home"
        case .aiChat: return "aiChat"
        case .voiceChat: return "voiceChat"
        case .memory: return "memory"
        case .lifeMap: return "lifeMap"
        case .goals: return "goals"
        case .projects: return "projects"
        case .habits: return "habits"
        case .calendar: return "calendar"
        case .insights: return "insights"
        case .predictions: return "predictions"
        case .analytics: return "analytics"
        case .progress: return "progress"
        case .notifications: return "notifications"
        case .settings: return "settings"
        case .profile: return "profile"
        case .search: return "search"
        case .onboarding: return "onboarding"
        case .login: return "login"
        case .subscription: return "subscription"
        case .about: return "about"
        case .privacy: return "privacy"
        case .aiDNA: return "aiDNA"
        case .worldModel: return "worldModel"
        case .futureSimulation: return "futureSimulation"
        case .decisionEngine: return "decisionEngine"
        case .curiosityEngine: return "curiosityEngine"
        case .goalEvolution: return "goalEvolution"
        case .multiAgentEngine: return "multiAgentEngine"
        case .knowledgeFusion: return "knowledgeFusion"
        case .selfEvolution: return "selfEvolution"
        case .trustEngine: return "trustEngine"
        case .lifeOSOrchestrator: return "lifeOSOrchestrator"
        case .personality: return "personality"
        case .learning: return "learning"
        case .adaptation: return "adaptation"
        case .hiddenRelations: return "hiddenRelations"
        case .integrations: return "integrations"
        case .security: return "security"
        case .planning: return "planning"
        case .assistant: return "assistant"
        }
    }
    
    var title: String {
        switch self {
        case .home: return "AI Brain"
        case .aiChat: return "AI Assistant"
        case .voiceChat: return "Voice Chat"
        case .memory: return "Universal Memory"
        case .lifeMap: return "World Model"
        case .goals: return "Goals"
        case .projects: return "Projects"
        case .habits: return "Health & Habits"
        case .calendar: return "Planning"
        case .insights: return "Analysis"
        case .predictions: return "Prediction"
        case .analytics: return "Analytics"
        case .progress: return "Progress"
        case .notifications: return "Notifications"
        case .settings: return "Settings"
        case .profile: return "Profile"
        case .search: return "Search"
        case .onboarding: return "Welcome"
        case .login: return "Sign In"
        case .subscription: return "Subscription"
        case .about: return "About"
        case .privacy: return "Privacy"
        case .aiDNA: return "AI DNA"
        case .worldModel: return "World Model"
        case .futureSimulation: return "Future Simulation"
        case .decisionEngine: return "Decision Engine"
        case .curiosityEngine: return "Curiosity Engine"
        case .goalEvolution: return "Goal Evolution"
        case .multiAgentEngine: return "Multi-Agent Engine"
        case .knowledgeFusion: return "Knowledge Fusion"
        case .selfEvolution: return "Self Evolution"
        case .trustEngine: return "Trust Engine"
        case .lifeOSOrchestrator: return "Life OS Orchestrator"
        case .personality: return "Personality"
        case .learning: return "Learning"
        case .adaptation: return "Adaptation"
        case .hiddenRelations: return "Hidden Relations"
        case .integrations: return "Integrations"
        case .security: return "Security"
        case .planning: return "Planning"
        case .assistant: return "Assistant"
        }
    }
    
    var icon: String {
        switch self {
        case .home: return "brain"
        case .aiChat: return "bubble.left.and.bubble.right.fill"
        case .voiceChat: return "waveform.circle.fill"
        case .memory: return "brain.head.profile"
        case .lifeMap: return "globe.americas.fill"
        case .goals: return "target"
        case .projects: return "folder.fill"
        case .habits: return "heart.fill"
        case .calendar: return "calendar.badge.clock"
        case .insights: return "lightbulb.fill"
        case .predictions: return "chart.line.uptrend.xyaxis"
        case .analytics: return "chart.bar.fill"
        case .progress: return "chart.pie.fill"
        case .notifications: return "bell.fill"
        case .settings: return "gearshape.fill"
        case .profile: return "person.fill"
        case .search: return "magnifyingglass"
        case .onboarding: return "sparkles"
        case .login: return "person.crop.circle"
        case .subscription: return "crown.fill"
        case .about: return "info.circle.fill"
        case .privacy: return "hand.raised.fill"
        case .aiDNA: return "dna"
        case .worldModel: return "globe.americas.fill"
        case .futureSimulation: return "sparkle.magnifyingglass"
        case .decisionEngine: return "arrow.triangle.branch"
        case .curiosityEngine: return "questionmark.circle"
        case .goalEvolution: return "arrow.up.right.circle.fill"
        case .multiAgentEngine: return "person.3.fill"
        case .knowledgeFusion: return "point.3.connected.trianglepath.dotted"
        case .selfEvolution: return "arrow.triangle.2.circlepath"
        case .trustEngine: return "shield.checkered"
        case .lifeOSOrchestrator: return "gearshape.2.fill"
        case .personality: return "person.crop.circle.badge.checkmark"
        case .learning: return "book.fill"
        case .adaptation: return "arrow.triangle.2.circlepath.circle.fill"
        case .hiddenRelations: return "link"
        case .integrations: return "puzzlepiece.extension.fill"
        case .security: return "lock.shield.fill"
        case .planning: return "calendar.badge.clock"
        case .assistant: return "sparkles"
        }
    }
    
    var subtitle: String {
        switch self {
        case .aiDNA: return "Auto-evolving identity"
        case .memory: return "Living memory graph"
        case .worldModel, .lifeMap: return "Dynamic life graph"
        case .futureSimulation: return "Scenario modeling"
        case .decisionEngine: return "Optimal path selection"
        case .curiosityEngine: return "Active exploration"
        case .goalEvolution: return "Adaptive goal tracking"
        case .multiAgentEngine: return "Coordinated AI agents"
        case .knowledgeFusion: return "Relationship discovery"
        case .selfEvolution: return "Continuous improvement"
        case .trustEngine: return "Confidence calibration"
        case .lifeOSOrchestrator: return "System coordination"
        case .personality: return "Trait modeling"
        case .learning: return "Knowledge acquisition"
        case .adaptation: return "Behavioral tuning"
        case .hiddenRelations: return "Pattern detection"
        case .integrations: return "Connected services"
        case .security: return "Privacy & protection"
        default: return "View details"
        }
    }
}

enum MainTab: Int, CaseIterable, Identifiable {
    case home, chat, explore, insights, profile
    
    var id: Int { rawValue }
    
    var title: String {
        switch self {
        case .home: return "Brain"
        case .chat: return "Assistant"
        case .explore: return "Modules"
        case .insights: return "Insights"
        case .profile: return "Me"
        }
    }
    
    var icon: String {
        switch self {
        case .home: return "brain"
        case .chat: return "bubble.left.and.bubble.right.fill"
        case .explore: return "square.grid.2x2.fill"
        case .insights: return "chart.line.uptrend.xyaxis"
        case .profile: return "person.fill"
        }
    }
}
