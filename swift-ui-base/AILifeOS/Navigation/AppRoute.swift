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
        }
    }
    
    var title: String {
        switch self {
        case .home: return "Home"
        case .aiChat: return "AI Chat"
        case .voiceChat: return "Voice Chat"
        case .memory: return "Memory"
        case .lifeMap: return "Life Map"
        case .goals: return "Goals"
        case .projects: return "Projects"
        case .habits: return "Habits"
        case .calendar: return "Calendar"
        case .insights: return "Insights"
        case .predictions: return "Predictions"
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
        }
    }
    
    var icon: String {
        switch self {
        case .home: return "house.fill"
        case .aiChat: return "bubble.left.and.bubble.right.fill"
        case .voiceChat: return "waveform.circle.fill"
        case .memory: return "brain.head.profile"
        case .lifeMap: return "map.fill"
        case .goals: return "target"
        case .projects: return "folder.fill"
        case .habits: return "repeat.circle.fill"
        case .calendar: return "calendar"
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
        }
    }
}

enum MainTab: Int, CaseIterable, Identifiable {
    case home, chat, explore, insights, profile
    
    var id: Int { rawValue }
    
    var title: String {
        switch self {
        case .home: return "Home"
        case .chat: return "Chat"
        case .explore: return "Explore"
        case .insights: return "Insights"
        case .profile: return "Me"
        }
    }
    
    var icon: String {
        switch self {
        case .home: return "house.fill"
        case .chat: return "bubble.left.and.bubble.right.fill"
        case .explore: return "square.grid.2x2.fill"
        case .insights: return "chart.line.uptrend.xyaxis"
        case .profile: return "person.fill"
        }
    }
}
