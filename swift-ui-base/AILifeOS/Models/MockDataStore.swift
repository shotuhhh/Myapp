//
//  MockDataStore.swift
//  AI Life OS
//

import Foundation
import SwiftUI

final class MockDataStore: ObservableObject {
    static let shared = MockDataStore()
    
    let user = LifeUser(
        id: "u1",
        name: "Alex Chen",
        email: "alex.chen@ailifeos.app",
        avatarSymbol: "person.crop.circle.fill",
        plan: "Pro",
        streakDays: 28,
        focusScore: 87,
        bio: "Building a balanced life with AI-guided clarity."
    )
    
    let chatMessages: [ChatMessage] = [
        ChatMessage(id: "c1", role: .assistant, content: "Good morning, Alex! Your focus window opens in 20 minutes. Want me to prep your deep work session?", timestamp: Date().addingTimeInterval(-3600)),
        ChatMessage(id: "c2", role: .user, content: "Yes, and block distractions until noon.", timestamp: Date().addingTimeInterval(-3500)),
        ChatMessage(id: "c3", role: .assistant, content: "Done. I've scheduled a 90-minute focus block, muted non-urgent notifications, and queued your project brief.", timestamp: Date().addingTimeInterval(-3400)),
        ChatMessage(id: "c4", role: .user, content: "What should I prioritize today?", timestamp: Date().addingTimeInterval(-1800)),
        ChatMessage(id: "c5", role: .assistant, content: "Top 3: finish Q2 roadmap draft (high impact), 30-min run (habit streak), review investor deck slides 8–12.", timestamp: Date().addingTimeInterval(-1700))
    ]
    
    let memories: [MemoryItem] = [
        MemoryItem(id: "m1", title: "Morning routine preference", summary: "Prefers 6:30 AM wake, meditation before email.", category: "Routine", date: Date().addingTimeInterval(-86400 * 3), importance: 4, tags: ["health", "routine"]),
        MemoryItem(id: "m2", title: "Investor meeting notes", summary: "Focus on traction metrics and retention story.", category: "Work", date: Date().addingTimeInterval(-86400 * 5), importance: 5, tags: ["startup", "fundraising"]),
        MemoryItem(id: "m3", title: "Weekend hiking spot", summary: "Loved Eagle Peak trail — schedule monthly hikes.", category: "Personal", date: Date().addingTimeInterval(-86400 * 12), importance: 3, tags: ["outdoors", "family"])
    ]
    
    let goals: [GoalItem] = [
        GoalItem(id: "g1", title: "Ship AI Life OS v1", description: "Complete premium UI prototype and beta release.", progress: 0.72, deadline: Date().addingTimeInterval(86400 * 45), category: "Career", milestones: ["Design system", "Core screens", "Beta launch"]),
        GoalItem(id: "g2", title: "Marathon ready", description: "Train for sub-4 hour marathon.", progress: 0.45, deadline: Date().addingTimeInterval(86400 * 120), category: "Health", milestones: ["Base mileage", "Tempo runs", "Race day"]),
        GoalItem(id: "g3", title: "Read 24 books", description: "One book every two weeks.", progress: 0.58, deadline: Date().addingTimeInterval(86400 * 200), category: "Growth", milestones: ["12 books", "18 books", "24 books"])
    ]
    
    let projects: [ProjectItem] = [
        ProjectItem(id: "p1", name: "AI Life OS", status: .active, progress: 0.72, dueDate: Date().addingTimeInterval(86400 * 30), teamSize: 4, tasksCompleted: 48, tasksTotal: 67),
        ProjectItem(id: "p2", name: "Home renovation", status: .planning, progress: 0.15, dueDate: Date().addingTimeInterval(86400 * 90), teamSize: 2, tasksCompleted: 3, tasksTotal: 20),
        ProjectItem(id: "p3", name: "Investor deck refresh", status: .active, progress: 0.55, dueDate: Date().addingTimeInterval(86400 * 14), teamSize: 3, tasksCompleted: 11, tasksTotal: 20)
    ]
    
    let habits: [HabitItem] = [
        HabitItem(id: "h1", name: "Morning meditation", icon: "leaf.fill", streak: 28, completionRate: 0.92, frequency: "Daily", completedToday: true),
        HabitItem(id: "h2", name: "Deep work block", icon: "brain.head.profile", streak: 14, completionRate: 0.78, frequency: "Weekdays", completedToday: true),
        HabitItem(id: "h3", name: "Evening journal", icon: "book.fill", streak: 21, completionRate: 0.85, frequency: "Daily", completedToday: false),
        HabitItem(id: "h4", name: "Run 5K", icon: "figure.run", streak: 9, completionRate: 0.65, frequency: "3× weekly", completedToday: false)
    ]
    
    var calendarEvents: [CalendarEvent] {
        let cal = Calendar.current
        let today = Date()
        return [
            CalendarEvent(id: "e1", title: "Focus: Roadmap draft", start: cal.date(bySettingHour: 9, minute: 0, second: 0, of: today)!, end: cal.date(bySettingHour: 10, minute: 30, second: 0, of: today)!, colorName: "blue", location: "Home office"),
            CalendarEvent(id: "e2", title: "Investor call", start: cal.date(bySettingHour: 14, minute: 0, second: 0, of: today)!, end: cal.date(bySettingHour: 15, minute: 0, second: 0, of: today)!, colorName: "purple", location: "Zoom"),
            CalendarEvent(id: "e3", title: "Evening run", start: cal.date(bySettingHour: 18, minute: 30, second: 0, of: today)!, end: cal.date(bySettingHour: 19, minute: 15, second: 0, of: today)!, colorName: "green", location: "Park trail")
        ]
    }
    
    let insights: [InsightItem] = [
        InsightItem(id: "i1", title: "Peak focus window", body: "Your best deep work happens between 9–11 AM on weekdays.", category: "Productivity", impact: "High", date: Date()),
        InsightItem(id: "i2", title: "Sleep correlation", body: "7.5h sleep correlates with +18% habit completion.", category: "Health", impact: "Medium", date: Date().addingTimeInterval(-86400)),
        InsightItem(id: "i3", title: "Meeting load", body: "Afternoon meetings reduce evening exercise by 32%.", category: "Balance", impact: "Medium", date: Date().addingTimeInterval(-86400 * 2))
    ]
    
    let predictions: [PredictionItem] = [
        PredictionItem(id: "pr1", title: "Goal completion", probability: 0.84, timeframe: "This quarter", recommendation: "Maintain current sprint pace on AI Life OS."),
        PredictionItem(id: "pr2", title: "Burnout risk", probability: 0.22, timeframe: "Next 2 weeks", recommendation: "Block one recovery evening this week."),
        PredictionItem(id: "pr3", title: "Habit streak break", probability: 0.15, timeframe: "This week", recommendation: "Set a 10-min journal reminder at 9 PM.")
    ]
    
    let analytics: [AnalyticsMetric] = [
        AnalyticsMetric(id: "a1", label: "Focus hours", value: "32.5h", change: 12.4, icon: "clock.fill"),
        AnalyticsMetric(id: "a2", label: "Tasks done", value: "47", change: 8.2, icon: "checkmark.circle.fill"),
        AnalyticsMetric(id: "a3", label: "Wellness score", value: "82", change: -2.1, icon: "heart.fill"),
        AnalyticsMetric(id: "a4", label: "AI sessions", value: "156", change: 24.0, icon: "sparkles")
    ]
    
    let progressAreas: [ProgressSnapshot] = [
        ProgressSnapshot(id: "ps1", area: "Career", score: 78, trend: 5.2, icon: "briefcase.fill"),
        ProgressSnapshot(id: "ps2", area: "Health", score: 85, trend: 3.1, icon: "heart.fill"),
        ProgressSnapshot(id: "ps3", area: "Relationships", score: 71, trend: -1.4, icon: "person.2.fill"),
        ProgressSnapshot(id: "ps4", area: "Growth", score: 82, trend: 6.8, icon: "book.fill")
    ]
    
  var notifications: [NotificationItem] = [
        NotificationItem(id: "n1", title: "Focus block starting", message: "Your 90-min deep work session begins in 5 minutes.", date: Date(), type: .reminder, isRead: false),
        NotificationItem(id: "n2", title: "Streak milestone", message: "28-day meditation streak — incredible consistency!", date: Date().addingTimeInterval(-3600), type: .achievement, isRead: false),
        NotificationItem(id: "n3", title: "New insight", message: "Afternoon meetings may impact your evening run habit.", date: Date().addingTimeInterval(-7200), type: .insight, isRead: true),
        NotificationItem(id: "n4", title: "Project update", message: "AI Life OS reached 72% completion.", date: Date().addingTimeInterval(-86400), type: .system, isRead: true)
    ]
    
    let lifeMapNodes: [LifeMapNode] = [
        LifeMapNode(id: "lm1", title: "Career", category: "Work", x: 0.5, y: 0.3, connections: ["lm2", "lm4"], strength: 0.9),
        LifeMapNode(id: "lm2", title: "Health", category: "Body", x: 0.25, y: 0.55, connections: ["lm1", "lm3"], strength: 0.85),
        LifeMapNode(id: "lm3", title: "Family", category: "Relationships", x: 0.75, y: 0.55, connections: ["lm2", "lm4"], strength: 0.8),
        LifeMapNode(id: "lm4", title: "Growth", category: "Mind", x: 0.5, y: 0.75, connections: ["lm1", "lm3"], strength: 0.88),
        LifeMapNode(id: "lm5", title: "Finance", category: "Wealth", x: 0.15, y: 0.25, connections: ["lm1"], strength: 0.7),
        LifeMapNode(id: "lm6", title: "Creativity", category: "Passion", x: 0.85, y: 0.25, connections: ["lm4"], strength: 0.75)
    ]
    
    let subscriptionPlans: [SubscriptionPlan] = [
        SubscriptionPlan(id: "s1", name: "Free", price: "$0", period: "forever", features: ["Basic AI chat", "3 goals", "Weekly insights"], isPopular: false),
        SubscriptionPlan(id: "s2", name: "Pro", price: "$12.99", period: "per month", features: ["Unlimited AI", "Voice chat", "Life map", "Predictions", "Priority support"], isPopular: true),
        SubscriptionPlan(id: "s3", name: "Family", price: "$19.99", period: "per month", features: ["Everything in Pro", "5 members", "Shared goals", "Family insights"], isPopular: false)
    ]
    
    let searchResults: [SearchResult] = [
        SearchResult(id: "sr1", title: "Goals", subtitle: "3 active goals", icon: "target", route: .goals),
        SearchResult(id: "sr2", title: "AI Chat", subtitle: "Continue conversation", icon: "bubble.left.and.bubble.right.fill", route: .aiChat),
        SearchResult(id: "sr3", title: "Calendar", subtitle: "3 events today", icon: "calendar", route: .calendar),
        SearchResult(id: "sr4", title: "Habits", subtitle: "4 tracked habits", icon: "repeat.circle.fill", route: .habits),
        SearchResult(id: "sr5", title: "Settings", subtitle: "App preferences", icon: "gearshape.fill", route: .settings)
    ]
}
