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
        SearchResult(id: "sr1", title: "AI Brain", subtitle: "Living AI universe", icon: "brain", route: .home),
        SearchResult(id: "sr2", title: "AI DNA", subtitle: "Auto-evolving traits", icon: "dna", route: .aiDNA),
        SearchResult(id: "sr3", title: "Universal Memory", subtitle: "Living memory graph", icon: "brain.head.profile", route: .memory),
        SearchResult(id: "sr4", title: "World Model", subtitle: "Dynamic life graph", icon: "globe.americas.fill", route: .lifeMap),
        SearchResult(id: "sr5", title: "Future Simulation", subtitle: "Scenario modeling", icon: "sparkle.magnifyingglass", route: .futureSimulation),
        SearchResult(id: "sr6", title: "Decision Engine", subtitle: "Optimal paths", icon: "arrow.triangle.branch", route: .decisionEngine),
        SearchResult(id: "sr7", title: "Knowledge Fusion", subtitle: "Hidden connections", icon: "point.3.connected.trianglepath.dotted", route: .knowledgeFusion),
        SearchResult(id: "sr8", title: "AI Assistant", subtitle: "Continue conversation", icon: "bubble.left.and.bubble.right.fill", route: .aiChat),
        SearchResult(id: "sr9", title: "Goals", subtitle: "3 active goals", icon: "target", route: .goals),
        SearchResult(id: "sr10", title: "Settings", subtitle: "App preferences", icon: "gearshape.fill", route: .settings)
    ]
    
    let aiDNATraits: [AIDNATrait] = [
        AIDNATrait(id: "t1", name: "Analytical Thinking", value: 0.89, trend: 0.02, lastUpdated: Date().addingTimeInterval(-3600), source: "Decision patterns"),
        AIDNATrait(id: "t2", name: "Risk Tolerance", value: 0.72, trend: -0.01, lastUpdated: Date().addingTimeInterval(-7200), source: "Investment behavior"),
        AIDNATrait(id: "t3", name: "Social Energy", value: 0.65, trend: 0.03, lastUpdated: Date().addingTimeInterval(-1800), source: "Calendar analysis"),
        AIDNATrait(id: "t4", name: "Morning Person", value: 0.91, trend: 0.01, lastUpdated: Date().addingTimeInterval(-5400), source: "Sleep & activity data"),
        AIDNATrait(id: "t5", name: "Growth Mindset", value: 0.88, trend: 0.04, lastUpdated: Date().addingTimeInterval(-900), source: "Learning patterns"),
        AIDNATrait(id: "t6", name: "Stress Resilience", value: 0.76, trend: -0.02, lastUpdated: Date().addingTimeInterval(-10800), source: "Health correlations")
    ]
    
    let knowledgeLinks: [KnowledgeLink] = [
        KnowledgeLink(id: "kl1", from: "Sleep", to: "Mood", strength: 0.87, discovery: "7+ hours sleep increases next-day mood by 34%"),
        KnowledgeLink(id: "kl2", from: "Mood", to: "Work Output", strength: 0.79, discovery: "Positive mood days produce 28% more completed tasks"),
        KnowledgeLink(id: "kl3", from: "Work Output", to: "Income", strength: 0.72, discovery: "Deep work hours correlate with project milestones"),
        KnowledgeLink(id: "kl4", from: "Exercise", to: "Stress", strength: 0.84, discovery: "Morning runs reduce afternoon stress by 41%"),
        KnowledgeLink(id: "kl5", from: "Meditation", to: "Focus", strength: 0.91, discovery: "28-day streak linked to +18% focus score"),
        KnowledgeLink(id: "kl6", from: "Meetings", to: "Evening Habits", strength: 0.68, discovery: "Afternoon meetings reduce exercise completion by 32%")
    ]
    
    let futureScenarios: [FutureScenario] = [
        FutureScenario(id: "fs1", name: "Scenario A — Optimal", probability: 0.62, risk: "Low", outcome: "Ship v1 on time, maintain health habits, close seed round", recommendation: "Protect morning focus blocks"),
        FutureScenario(id: "fs2", name: "Scenario B — Stretched", probability: 0.28, risk: "Medium", outcome: "Delayed launch by 2 weeks, habit streaks at risk", recommendation: "Delegate non-critical tasks this week"),
        FutureScenario(id: "fs3", name: "Scenario C — Burnout", probability: 0.10, risk: "High", outcome: "Health decline, missed deadlines, relationship strain", recommendation: "Schedule recovery day immediately")
    ]
    
    let decisionOptions: [DecisionOption] = [
        DecisionOption(id: "d1", title: "Accept Friday meeting", score: 0.78, pros: ["High-value investor", "Momentum for fundraise"], cons: ["Conflicts with deep work", "Evening run at risk"], confidence: 0.78),
        DecisionOption(id: "d2", title: "Reschedule to Monday", score: 0.85, pros: ["Protects focus block", "Better preparation time"], cons: ["Slight delay in momentum"], confidence: 0.85),
        DecisionOption(id: "d3", title: "Decline politely", score: 0.42, pros: ["Full schedule control"], cons: ["Missed opportunity", "Investor perception risk"], confidence: 0.42)
    ]
    
    let agents: [AgentItem] = [
        AgentItem(id: "a1", name: "Memory Agent", role: "Indexing & retrieval", status: "Active", taskProgress: 0.73, icon: "brain.head.profile"),
        AgentItem(id: "a2", name: "Planning Agent", role: "Schedule optimization", status: "Active", taskProgress: 0.91, icon: "calendar.badge.clock"),
        AgentItem(id: "a3", name: "Health Agent", role: "Wellness monitoring", status: "Active", taskProgress: 0.65, icon: "heart.fill"),
        AgentItem(id: "a4", name: "Finance Agent", role: "Budget & projections", status: "Idle", taskProgress: 0.30, icon: "dollarsign.circle"),
        AgentItem(id: "a5", name: "Growth Agent", role: "Learning paths", status: "Active", taskProgress: 0.58, icon: "book.fill")
    ]
    
    let evolutionMetrics: [EvolutionMetric] = [
        EvolutionMetric(id: "e1", area: "Response Accuracy", before: 0.82, after: 0.91, change: "+11% this month"),
        EvolutionMetric(id: "e2", area: "Prediction Precision", before: 0.75, after: 0.84, change: "+12% this month"),
        EvolutionMetric(id: "e3", area: "Personalization Depth", before: 0.68, after: 0.79, change: "+16% this month"),
        EvolutionMetric(id: "e4", area: "Context Awareness", before: 0.71, after: 0.88, change: "+24% this month")
    ]
    
    let personalityDimensions: [PersonalityDimension] = [
        PersonalityDimension(id: "p1", name: "Openness", score: 0.87, description: "Highly curious, embraces new experiences and ideas"),
        PersonalityDimension(id: "p2", name: "Conscientiousness", score: 0.82, description: "Organized and goal-driven with strong follow-through"),
        PersonalityDimension(id: "p3", name: "Extraversion", score: 0.64, description: "Balanced social energy — selective about interactions"),
        PersonalityDimension(id: "p4", name: "Agreeableness", score: 0.78, description: "Collaborative and empathetic in team settings"),
        PersonalityDimension(id: "p5", name: "Emotional Stability", score: 0.73, description: "Generally calm with occasional stress spikes during deadlines")
    ]
    
    let extendedMemories: [ExtendedMemoryItem] = [
        ExtendedMemoryItem(id: "em1", title: "Morning routine preference", summary: "Prefers 6:30 AM wake, meditation before email.", category: "Routine", date: Date().addingTimeInterval(-86400 * 3), importance: 4, tags: ["health", "routine"], emotionalImpact: 0.7, goalImpact: 0.8, futureImpact: 0.6, connections: ["em2", "em4"], x: 0.3, y: 0.4),
        ExtendedMemoryItem(id: "em2", title: "Investor meeting notes", summary: "Focus on traction metrics and retention story.", category: "Work", date: Date().addingTimeInterval(-86400 * 5), importance: 5, tags: ["startup", "fundraising"], emotionalImpact: 0.5, goalImpact: 0.95, futureImpact: 0.9, connections: ["em1", "em3"], x: 0.7, y: 0.3),
        ExtendedMemoryItem(id: "em3", title: "Weekend hiking spot", summary: "Loved Eagle Peak trail — schedule monthly hikes.", category: "Personal", date: Date().addingTimeInterval(-86400 * 12), importance: 3, tags: ["outdoors", "family"], emotionalImpact: 0.9, goalImpact: 0.4, futureImpact: 0.5, connections: ["em4"], x: 0.5, y: 0.7),
        ExtendedMemoryItem(id: "em4", title: "Sleep pattern insight", summary: "7.5h sleep optimal for focus and mood.", category: "Health", date: Date().addingTimeInterval(-86400 * 2), importance: 5, tags: ["health", "sleep"], emotionalImpact: 0.8, goalImpact: 0.85, futureImpact: 0.92, connections: ["em1", "em3"], x: 0.2, y: 0.6),
        ExtendedMemoryItem(id: "em5", title: "Team collaboration style", summary: "Prefers async updates, weekly sync meetings.", category: "Work", date: Date().addingTimeInterval(-86400 * 8), importance: 4, tags: ["team", "communication"], emotionalImpact: 0.6, goalImpact: 0.7, futureImpact: 0.65, connections: ["em2"], x: 0.8, y: 0.55)
    ]
    
    let trustMetrics: [TrustMetric] = [
        TrustMetric(id: "tr1", category: "Recommendations", score: 0.89, factors: ["847 data points analyzed", "92% historical accuracy", "Cross-validated with 3 agents"]),
        TrustMetric(id: "tr2", category: "Predictions", score: 0.84, factors: ["14-day forecast track record", "Scenario modeling active", "Confidence intervals calibrated"]),
        TrustMetric(id: "tr3", category: "Memory Accuracy", score: 0.93, factors: ["Auto-verified memories", "Conflict resolution active", "User feedback incorporated"])
    ]
    
    let curiosityProbes: [CuriosityProbe] = [
        CuriosityProbe(id: "cp1", question: "Why does your focus drop after 3 PM on Tuesdays?", relevance: 0.87, status: "Active"),
        CuriosityProbe(id: "cp2", question: "What triggers your best creative sessions?", relevance: 0.92, status: "Active"),
        CuriosityProbe(id: "cp3", question: "How does weather affect your exercise habits?", relevance: 0.71, status: "Exploring"),
        CuriosityProbe(id: "cp4", question: "What patterns emerge before your streak breaks?", relevance: 0.85, status: "Active")
    ]
    
    let goalEvolution: [GoalEvolutionEntry] = [
        GoalEvolutionEntry(id: "ge1", goalTitle: "Ship AI Life OS v1", previousState: "Complete UI prototype", currentState: "Living AI OS with 15+ modules", aiAdjustment: "Expanded scope based on user vision alignment", date: Date().addingTimeInterval(-86400 * 7)),
        GoalEvolutionEntry(id: "ge2", goalTitle: "Marathon ready", previousState: "Base mileage 20mi/week", currentState: "Base mileage 28mi/week", aiAdjustment: "Accelerated training — fitness data shows readiness", date: Date().addingTimeInterval(-86400 * 14)),
        GoalEvolutionEntry(id: "ge3", goalTitle: "Read 24 books", previousState: "14 books completed", currentState: "14 books — shifted to audiobooks for commute", aiAdjustment: "Format adaptation for better completion rate", date: Date().addingTimeInterval(-86400 * 3))
    ]
    
    let integrations: [IntegrationItem] = [
        IntegrationItem(id: "i1", name: "Apple Health", icon: "heart.fill", connected: true, lastSync: Date().addingTimeInterval(-1800)),
        IntegrationItem(id: "i2", name: "Google Calendar", icon: "calendar", connected: true, lastSync: Date().addingTimeInterval(-600)),
        IntegrationItem(id: "i3", name: "Notion", icon: "doc.text.fill", connected: true, lastSync: Date().addingTimeInterval(-3600)),
        IntegrationItem(id: "i4", name: "Spotify", icon: "music.note", connected: false, lastSync: nil),
        IntegrationItem(id: "i5", name: "Plaid Finance", icon: "dollarsign.circle.fill", connected: true, lastSync: Date().addingTimeInterval(-7200)),
        IntegrationItem(id: "i6", name: "Slack", icon: "number", connected: false, lastSync: nil)
    ]
    
    let securityItems: [SecurityItem] = [
        SecurityItem(id: "s1", title: "End-to-End Encryption", status: "Active", detail: "All memories encrypted with AES-256", icon: "lock.fill"),
        SecurityItem(id: "s2", title: "Biometric Lock", status: "Active", detail: "Face ID required for sensitive data", icon: "faceid"),
        SecurityItem(id: "s3", title: "Data Sovereignty", status: "Active", detail: "Your data never used for model training", icon: "hand.raised.fill"),
        SecurityItem(id: "s4", title: "Audit Log", status: "Active", detail: "All AI actions logged and reviewable", icon: "list.bullet.clipboard.fill")
    ]
}
