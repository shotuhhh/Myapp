//
//  ModuleScreens.swift
//  AI Life OS
//

import SwiftUI

// MARK: - Shared Module Header

struct ModuleHeader: View {
    let title: String
    let subtitle: String
    let icon: String
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        let theme = colorScheme == .dark ? ThemeColors.dark : ThemeColors.light
        HStack(spacing: 14) {
            ZStack {
                Circle()
                    .fill(LinearGradient(colors: [theme.gradientStart, theme.gradientEnd], startPoint: .topLeading, endPoint: .bottomTrailing))
                    .frame(width: 48, height: 48)
                    .glow(theme.accent, radius: 10)
                Image(systemName: icon)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.white)
            }
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                    .foregroundColor(theme.primaryText)
                Text(subtitle)
                    .font(.system(size: 14))
                    .foregroundColor(theme.secondaryText)
            }
            Spacer()
        }
        .padding(.top, 8)
    }
}

// MARK: - AI DNA

struct AIDNAScreen: View {
    @ObservedObject private var data = MockDataStore.shared
    @Environment(\.colorScheme) private var colorScheme
    @State private var animateTraits = false
    
    var body: some View {
        let theme = colorScheme == .dark ? ThemeColors.dark : ThemeColors.light
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 16) {
                ModuleHeader(title: "AI DNA", subtitle: "Auto-updated · Never user-edited", icon: "dna")
                
                LiveActivityMock()
                
                Text("Your AI continuously evolves its understanding of you. These traits update automatically from your behavior patterns.")
                    .font(.system(size: 14))
                    .foregroundColor(theme.secondaryText)
                
                ForEach(data.aiDNATraits) { trait in
                    GlassCard {
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text(trait.name)
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(theme.primaryText)
                                Spacer()
                                HStack(spacing: 2) {
                                    Image(systemName: trait.trend >= 0 ? "arrow.up.right" : "arrow.down.right")
                                        .font(.system(size: 10, weight: .bold))
                                    Text("\(Int(trait.value * 100))%")
                                        .font(.system(size: 15, weight: .bold, design: .monospaced))
                                }
                                .foregroundColor(trait.trend >= 0 ? theme.success : theme.warning)
                            }
                            GeometryReader { geo in
                                ZStack(alignment: .leading) {
                                    Capsule().fill(theme.border.opacity(0.3)).frame(height: 6)
                                    Capsule()
                                        .fill(LinearGradient(colors: [theme.accent, theme.accentSecondary], startPoint: .leading, endPoint: .trailing))
                                        .frame(width: animateTraits ? geo.size.width * trait.value : 0, height: 6)
                                        .glow(theme.accent, radius: 4)
                                }
                            }
                            .frame(height: 6)
                            HStack {
                                Text("Source: \(trait.source)")
                                    .font(.system(size: 11))
                                    .foregroundColor(theme.tertiaryText)
                                Spacer()
                                Text("Updated \(trait.lastUpdated, style: .relative) ago")
                                    .font(.system(size: 11))
                                    .foregroundColor(theme.tertiaryText)
                            }
                        }
                    }
                }
            }
            .padding(AppTheme.padding)
        }
        .futuristicBackground()
        .navigationBarHidden(true)
        .onAppear {
            withAnimation(.spring(response: 1.0, dampingFraction: 0.8).delay(0.2)) {
                animateTraits = true
            }
        }
    }
}

// MARK: - Future Simulation

struct FutureSimulationScreen: View {
    @ObservedObject private var data = MockDataStore.shared
    @Environment(\.colorScheme) private var colorScheme
    @State private var selectedScenario: FutureScenario?
    
    var body: some View {
        let theme = colorScheme == .dark ? ThemeColors.dark : ThemeColors.light
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 16) {
                ModuleHeader(title: "Future Simulation", subtitle: "Scenario A/B/C before recommendations", icon: "sparkle.magnifyingglass")
                
                ForEach(data.futureScenarios) { scenario in
                    Button(action: { selectedScenario = scenario; HapticFeedback.selection() }) {
                        GlassCard {
                            VStack(alignment: .leading, spacing: 10) {
                                HStack {
                                    Text(scenario.name)
                                        .font(.system(size: 18, weight: .bold, design: .rounded))
                                        .foregroundColor(theme.primaryText)
                                    Spacer()
                                    Text("\(Int(scenario.probability * 100))%")
                                        .font(.system(size: 20, weight: .bold, design: .monospaced))
                                        .foregroundColor(theme.accent)
                                }
                                HStack {
                                    ChipView(text: "Risk: \(scenario.risk)", isSelected: scenario.risk == "Low")
                                    Spacer()
                                }
                                Text(scenario.outcome)
                                    .font(.system(size: 14))
                                    .foregroundColor(theme.secondaryText)
                                HStack {
                                    Image(systemName: "lightbulb.fill")
                                        .foregroundColor(theme.warning)
                                    Text(scenario.recommendation)
                                        .font(.system(size: 13, weight: .medium))
                                        .foregroundColor(theme.primaryText)
                                }
                            }
                        }
                    }
                    .buttonStyle(PressableButtonStyle())
                    .scaleEffect(selectedScenario?.id == scenario.id ? 1.02 : 1.0)
                    .animation(AppTheme.springAnimation, value: selectedScenario?.id)
                }
            }
            .padding(AppTheme.padding)
        }
        .futuristicBackground()
        .navigationBarHidden(true)
    }
}

// MARK: - Decision Engine

struct DecisionEngineScreen: View {
    @ObservedObject private var data = MockDataStore.shared
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        let theme = colorScheme == .dark ? ThemeColors.dark : ThemeColors.light
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 16) {
                ModuleHeader(title: "Decision Engine", subtitle: "Evaluating optimal life paths", icon: "arrow.triangle.branch")
                
                GlassCard {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Active Decision")
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundColor(theme.accent)
                        Text("Should I accept the investor meeting on Friday afternoon?")
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundColor(theme.primaryText)
                    }
                }
                
                ForEach(data.decisionOptions) { option in
                    GlassCard {
                        VStack(alignment: .leading, spacing: 10) {
                            HStack {
                                Text(option.title)
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundColor(theme.primaryText)
                                Spacer()
                                Text("\(Int(option.score * 100))")
                                    .font(.system(size: 22, weight: .bold, design: .monospaced))
                                    .foregroundColor(theme.accent)
                                    .glow(theme.accent, radius: 6)
                            }
                            HStack(spacing: 16) {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Pros").font(.system(size: 12, weight: .bold)).foregroundColor(theme.success)
                                    ForEach(option.pros, id: \.self) { pro in
                                        Text("• \(pro)").font(.system(size: 12)).foregroundColor(theme.secondaryText)
                                    }
                                }
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Cons").font(.system(size: 12, weight: .bold)).foregroundColor(theme.error)
                                    ForEach(option.cons, id: \.self) { con in
                                        Text("• \(con)").font(.system(size: 12)).foregroundColor(theme.secondaryText)
                                    }
                                }
                            }
                            Text("Confidence: \(Int(option.confidence * 100))%")
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(theme.accent)
                        }
                    }
                }
            }
            .padding(AppTheme.padding)
        }
        .futuristicBackground()
        .navigationBarHidden(true)
    }
}

// MARK: - Curiosity Engine

struct CuriosityEngineScreen: View {
    @ObservedObject private var data = MockDataStore.shared
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        let theme = colorScheme == .dark ? ThemeColors.dark : ThemeColors.light
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 16) {
                ModuleHeader(title: "Curiosity Engine", subtitle: "AI actively exploring your life", icon: "questionmark.circle")
                
                ForEach(data.curiosityProbes) { probe in
                    GlassCard {
                        HStack(spacing: 12) {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(theme.accent)
                                .frame(width: 32, height: 32)
                                .background(theme.accent.opacity(0.15))
                                .clipShape(Circle())
                            VStack(alignment: .leading, spacing: 4) {
                                Text(probe.question)
                                    .font(.system(size: 15, weight: .medium))
                                    .foregroundColor(theme.primaryText)
                                HStack {
                                    ChipView(text: probe.status, isSelected: probe.status == "Active")
                                    Text("Relevance: \(Int(probe.relevance * 100))%")
                                        .font(.system(size: 11))
                                        .foregroundColor(theme.secondaryText)
                                }
                            }
                        }
                    }
                }
            }
            .padding(AppTheme.padding)
        }
        .futuristicBackground()
        .navigationBarHidden(true)
    }
}

// MARK: - Goal Evolution

struct GoalEvolutionScreen: View {
    @ObservedObject private var data = MockDataStore.shared
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        let theme = colorScheme == .dark ? ThemeColors.dark : ThemeColors.light
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 16) {
                ModuleHeader(title: "Goal Evolution", subtitle: "Goals adapt as you grow", icon: "arrow.up.right.circle.fill")
                
                ForEach(data.goalEvolution) { entry in
                    GlassCard {
                        VStack(alignment: .leading, spacing: 8) {
                            Text(entry.goalTitle)
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(theme.primaryText)
                            HStack {
                                VStack(alignment: .leading) {
                                    Text("Before").font(.system(size: 11, weight: .bold)).foregroundColor(theme.tertiaryText)
                                    Text(entry.previousState).font(.system(size: 13)).foregroundColor(theme.secondaryText)
                                }
                                Image(systemName: "arrow.right")
                                    .foregroundColor(theme.accent)
                                VStack(alignment: .leading) {
                                    Text("Now").font(.system(size: 11, weight: .bold)).foregroundColor(theme.accent)
                                    Text(entry.currentState).font(.system(size: 13, weight: .medium)).foregroundColor(theme.primaryText)
                                }
                            }
                            HStack {
                                Image(systemName: "sparkles")
                                    .foregroundColor(theme.accent)
                                Text(entry.aiAdjustment)
                                    .font(.system(size: 12, weight: .medium))
                                    .foregroundColor(theme.accent)
                            }
                            Text(entry.date, style: .relative)
                                .font(.system(size: 11))
                                .foregroundColor(theme.tertiaryText)
                        }
                    }
                }
            }
            .padding(AppTheme.padding)
        }
        .futuristicBackground()
        .navigationBarHidden(true)
    }
}

// MARK: - Multi-Agent Engine

struct MultiAgentEngineScreen: View {
    @ObservedObject private var data = MockDataStore.shared
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        let theme = colorScheme == .dark ? ThemeColors.dark : ThemeColors.light
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 16) {
                ModuleHeader(title: "Multi-Agent Engine", subtitle: "Coordinated AI specialists", icon: "person.3.fill")
                
                ForEach(data.agents) { agent in
                    GlassCard {
                        HStack(spacing: 14) {
                            Image(systemName: agent.icon)
                                .font(.system(size: 22))
                                .foregroundColor(theme.accent)
                                .frame(width: 44, height: 44)
                                .background(theme.accent.opacity(0.12))
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                                .glow(theme.accent, radius: 6, intensity: 0.3)
                            VStack(alignment: .leading, spacing: 4) {
                                Text(agent.name)
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(theme.primaryText)
                                Text(agent.role)
                                    .font(.system(size: 13))
                                    .foregroundColor(theme.secondaryText)
                                HStack {
                                    ChipView(text: agent.status, isSelected: agent.status == "Active")
                                    ProgressView(value: agent.taskProgress)
                                        .tint(theme.accent)
                                }
                            }
                        }
                    }
                }
            }
            .padding(AppTheme.padding)
        }
        .futuristicBackground()
        .navigationBarHidden(true)
    }
}

// MARK: - Knowledge Fusion

struct KnowledgeFusionScreen: View {
    @ObservedObject private var data = MockDataStore.shared
    @Environment(\.colorScheme) private var colorScheme
    @State private var animateLinks = false
    
    var body: some View {
        let theme = colorScheme == .dark ? ThemeColors.dark : ThemeColors.light
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 16) {
                ModuleHeader(title: "Knowledge Fusion", subtitle: "Discovering hidden life connections", icon: "point.3.connected.trianglepath.dotted")
                
                // Visual chain
                GlassCard {
                    HStack(spacing: 4) {
                        ForEach(["Sleep", "Mood", "Work", "Income", "Stress"], id: \.self) { node in
                            Text(node)
                                .font(.system(size: 11, weight: .bold))
                                .foregroundColor(.white)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 6)
                                .background(Capsule().fill(theme.accent.opacity(animateLinks ? 0.9 : 0.4)))
                                .glow(theme.accent, radius: 4, intensity: animateLinks ? 0.6 : 0.2)
                            if node != "Stress" {
                                Image(systemName: "arrow.right")
                                    .font(.system(size: 10))
                                    .foregroundColor(theme.accent)
                            }
                        }
                    }
                }
                
                ForEach(data.knowledgeLinks) { link in
                    GlassCard {
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text(link.from)
                                    .font(.system(size: 14, weight: .bold))
                                    .foregroundColor(theme.accent)
                                Image(systemName: "arrow.right")
                                    .foregroundColor(theme.secondaryText)
                                Text(link.to)
                                    .font(.system(size: 14, weight: .bold))
                                    .foregroundColor(theme.accentSecondary)
                                Spacer()
                                Text("\(Int(link.strength * 100))%")
                                    .font(.system(size: 14, weight: .bold, design: .monospaced))
                                    .foregroundColor(theme.primaryText)
                            }
                            Text(link.discovery)
                                .font(.system(size: 13))
                                .foregroundColor(theme.secondaryText)
                        }
                    }
                }
            }
            .padding(AppTheme.padding)
        }
        .futuristicBackground()
        .navigationBarHidden(true)
        .onAppear {
            withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                animateLinks = true
            }
        }
    }
}

// MARK: - Self Evolution

struct SelfEvolutionScreen: View {
    @ObservedObject private var data = MockDataStore.shared
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        let theme = colorScheme == .dark ? ThemeColors.dark : ThemeColors.light
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 16) {
                ModuleHeader(title: "Self Evolution", subtitle: "AI continuously improving", icon: "arrow.triangle.2.circlepath")
                
                ForEach(data.evolutionMetrics) { metric in
                    GlassCard {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(metric.area)
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(theme.primaryText)
                                Text(metric.change)
                                    .font(.system(size: 13))
                                    .foregroundColor(theme.success)
                            }
                            Spacer()
                            HStack(spacing: 8) {
                                Text("\(Int(metric.before * 100))%")
                                    .font(.system(size: 14, design: .monospaced))
                                    .foregroundColor(theme.tertiaryText)
                                Image(systemName: "arrow.right")
                                    .foregroundColor(theme.accent)
                                Text("\(Int(metric.after * 100))%")
                                    .font(.system(size: 16, weight: .bold, design: .monospaced))
                                    .foregroundColor(theme.accent)
                                    .glow(theme.accent, radius: 4)
                            }
                        }
                    }
                }
            }
            .padding(AppTheme.padding)
        }
        .futuristicBackground()
        .navigationBarHidden(true)
    }
}

// MARK: - Trust Engine

struct TrustEngineScreen: View {
    @ObservedObject private var data = MockDataStore.shared
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        let theme = colorScheme == .dark ? ThemeColors.dark : ThemeColors.light
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 16) {
                ModuleHeader(title: "Trust Engine", subtitle: "Confidence calibration", icon: "shield.checkered")
                
                ForEach(data.trustMetrics) { metric in
                    GlassCard {
                        VStack(alignment: .leading, spacing: 10) {
                            HStack {
                                Text(metric.category)
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(theme.primaryText)
                                Spacer()
                                ProgressRing(progress: metric.score, label: "", size: 48)
                            }
                            ForEach(metric.factors, id: \.self) { factor in
                                HStack(spacing: 8) {
                                    Image(systemName: "checkmark.circle.fill")
                                        .font(.system(size: 12))
                                        .foregroundColor(theme.success)
                                    Text(factor)
                                        .font(.system(size: 13))
                                        .foregroundColor(theme.secondaryText)
                                }
                            }
                        }
                    }
                }
            }
            .padding(AppTheme.padding)
        }
        .futuristicBackground()
        .navigationBarHidden(true)
    }
}

// MARK: - Life OS Orchestrator

struct LifeOSOrchestratorScreen: View {
    @ObservedObject private var data = MockDataStore.shared
    @Environment(\.colorScheme) private var colorScheme
    @State private var pulseIndex = 0
    
    var body: some View {
        let theme = colorScheme == .dark ? ThemeColors.dark : ThemeColors.light
        let modules = ["Memory", "Goals", "Planning", "Health", "Finance", "Prediction", "Decision", "Trust"]
        
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 16) {
                ModuleHeader(title: "Life OS Orchestrator", subtitle: "Coordinating all AI modules", icon: "gearshape.2.fill")
                
                GlassCard {
                    VStack(spacing: 12) {
                        Text("System Status")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(theme.accent)
                        HStack {
                            Circle().fill(theme.success).frame(width: 8, height: 8)
                            Text("All \(modules.count) modules operational")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(theme.primaryText)
                        }
                    }
                }
                
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                    ForEach(Array(modules.enumerated()), id: \.offset) { idx, mod in
                        HStack {
                            Circle()
                                .fill(theme.accent)
                                .frame(width: 6, height: 6)
                                .opacity(pulseIndex == idx ? 1 : 0.3)
                            Text(mod)
                                .font(.system(size: 13, weight: .medium))
                                .foregroundColor(theme.primaryText)
                            Spacer()
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(theme.success)
                                .font(.system(size: 14))
                        }
                        .padding(12)
                        .glassSurface(cornerRadius: 12)
                    }
                }
                
                AIActivityPanel()
            }
            .padding(AppTheme.padding)
        }
        .futuristicBackground()
        .navigationBarHidden(true)
        .onAppear {
            Timer.scheduledTimer(withTimeInterval: 0.8, repeats: true) { _ in
                withAnimation { pulseIndex = (pulseIndex + 1) % modules.count }
            }
        }
    }
}

// MARK: - Personality

struct PersonalityScreen: View {
    @ObservedObject private var data = MockDataStore.shared
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        let theme = colorScheme == .dark ? ThemeColors.dark : ThemeColors.light
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 16) {
                ModuleHeader(title: "Personality", subtitle: "AI-modeled personality dimensions", icon: "person.crop.circle.badge.checkmark")
                
                ForEach(data.personalityDimensions) { dim in
                    GlassCard {
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text(dim.name)
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(theme.primaryText)
                                Spacer()
                                Text("\(Int(dim.score * 100))%")
                                    .font(.system(size: 18, weight: .bold, design: .monospaced))
                                    .foregroundColor(theme.accent)
                            }
                            Text(dim.description)
                                .font(.system(size: 13))
                                .foregroundColor(theme.secondaryText)
                        }
                    }
                }
            }
            .padding(AppTheme.padding)
        }
        .futuristicBackground()
        .navigationBarHidden(true)
    }
}

// MARK: - Learning

struct LearningScreen: View {
    @ObservedObject private var data = MockDataStore.shared
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        let theme = colorScheme == .dark ? ThemeColors.dark : ThemeColors.light
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 16) {
                ModuleHeader(title: "Learning", subtitle: "Knowledge acquisition & growth", icon: "book.fill")
                
                ForEach(data.goals.filter { $0.category == "Growth" }) { goal in
                    GlassCard {
                        VStack(alignment: .leading, spacing: 8) {
                            Text(goal.title)
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(theme.primaryText)
                            Text(goal.description)
                                .font(.system(size: 13))
                                .foregroundColor(theme.secondaryText)
                            ProgressView(value: goal.progress)
                                .tint(theme.accent)
                            Text("\(Int(goal.progress * 100))% complete")
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(theme.accent)
                        }
                    }
                }
                
                SectionHeader(title: "Recent Insights")
                ForEach(data.insights.filter { $0.category == "Growth" }.prefix(3)) { insight in
                    GlassCard {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(insight.title).font(.system(size: 15, weight: .semibold)).foregroundColor(theme.primaryText)
                            Text(insight.body).font(.system(size: 13)).foregroundColor(theme.secondaryText)
                        }
                    }
                }
            }
            .padding(AppTheme.padding)
        }
        .futuristicBackground()
        .navigationBarHidden(true)
    }
}

// MARK: - Adaptation

struct AdaptationScreen: View {
    @ObservedObject private var data = MockDataStore.shared
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        let theme = colorScheme == .dark ? ThemeColors.dark : ThemeColors.light
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 16) {
                ModuleHeader(title: "Adaptation", subtitle: "Behavioral tuning in real-time", icon: "arrow.triangle.2.circlepath.circle.fill")
                
                ForEach(data.evolutionMetrics) { metric in
                    GlassCard {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Adapted: \(metric.area)")
                                    .font(.system(size: 15, weight: .semibold))
                                    .foregroundColor(theme.primaryText)
                                Text(metric.change)
                                    .font(.system(size: 13))
                                    .foregroundColor(theme.accent)
                            }
                            Spacer()
                            Image(systemName: "arrow.triangle.2.circlepath")
                                .font(.system(size: 24))
                                .foregroundColor(theme.accent)
                                .glow(theme.accent, radius: 8)
                        }
                    }
                }
            }
            .padding(AppTheme.padding)
        }
        .futuristicBackground()
        .navigationBarHidden(true)
    }
}

// MARK: - Hidden Relations

struct HiddenRelationsScreen: View {
    @ObservedObject private var data = MockDataStore.shared
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        let theme = colorScheme == .dark ? ThemeColors.dark : ThemeColors.light
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 16) {
                ModuleHeader(title: "Hidden Relations", subtitle: "Patterns you can't see", icon: "link")
                
                ForEach(data.knowledgeLinks) { link in
                    GlassCard {
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Image(systemName: "link.circle.fill")
                                    .foregroundColor(theme.accent)
                                Text("\(link.from) ↔ \(link.to)")
                                    .font(.system(size: 15, weight: .semibold))
                                    .foregroundColor(theme.primaryText)
                            }
                            Text(link.discovery)
                                .font(.system(size: 13))
                                .foregroundColor(theme.secondaryText)
                            HStack {
                                Text("Correlation strength")
                                    .font(.system(size: 11))
                                    .foregroundColor(theme.tertiaryText)
                                Spacer()
                                Text("\(Int(link.strength * 100))%")
                                    .font(.system(size: 13, weight: .bold, design: .monospaced))
                                    .foregroundColor(theme.accent)
                            }
                        }
                    }
                }
            }
            .padding(AppTheme.padding)
        }
        .futuristicBackground()
        .navigationBarHidden(true)
    }
}

// MARK: - Integrations

struct IntegrationsScreen: View {
    @ObservedObject private var data = MockDataStore.shared
    @EnvironmentObject var appState: AppState
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        let theme = colorScheme == .dark ? ThemeColors.dark : ThemeColors.light
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 16) {
                ModuleHeader(title: "Integrations", subtitle: "Connected life data sources", icon: "puzzlepiece.extension.fill")
                
                ForEach(data.integrations) { item in
                    GlassCard {
                        HStack(spacing: 14) {
                            Image(systemName: item.icon)
                                .font(.system(size: 22))
                                .foregroundColor(item.connected ? theme.success : theme.tertiaryText)
                                .frame(width: 40, height: 40)
                                .background((item.connected ? theme.success : theme.tertiaryText).opacity(0.12))
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                            VStack(alignment: .leading, spacing: 2) {
                                Text(item.name)
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(theme.primaryText)
                                if let sync = item.lastSync {
                                    Text("Last sync: \(sync, style: .relative) ago")
                                        .font(.system(size: 12))
                                        .foregroundColor(theme.secondaryText)
                                }
                            }
                            Spacer()
                            ChipView(text: item.connected ? "Connected" : "Available", isSelected: item.connected)
                        }
                    }
                }
            }
            .padding(AppTheme.padding)
        }
        .futuristicBackground()
        .navigationBarHidden(true)
    }
}

// MARK: - Security

struct SecurityScreen: View {
    @ObservedObject private var data = MockDataStore.shared
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        let theme = colorScheme == .dark ? ThemeColors.dark : ThemeColors.light
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 16) {
                ModuleHeader(title: "Security", subtitle: "Privacy & data protection", icon: "lock.shield.fill")
                
                ForEach(data.securityItems) { item in
                    GlassCard {
                        HStack(spacing: 14) {
                            Image(systemName: item.icon)
                                .foregroundColor(theme.success)
                                .frame(width: 36, height: 36)
                                .background(theme.success.opacity(0.12))
                                .clipShape(Circle())
                            VStack(alignment: .leading, spacing: 2) {
                                Text(item.title)
                                    .font(.system(size: 15, weight: .semibold))
                                    .foregroundColor(theme.primaryText)
                                Text(item.detail)
                                    .font(.system(size: 13))
                                    .foregroundColor(theme.secondaryText)
                            }
                            Spacer()
                            ChipView(text: item.status, isSelected: item.status == "Active")
                        }
                    }
                }
            }
            .padding(AppTheme.padding)
        }
        .futuristicBackground()
        .navigationBarHidden(true)
    }
}

// MARK: - Planning Module

struct PlanningScreen: View {
    @ObservedObject private var data = MockDataStore.shared
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        let theme = colorScheme == .dark ? ThemeColors.dark : ThemeColors.light
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 16) {
                ModuleHeader(title: "Planning", subtitle: "AI-optimized schedule", icon: "calendar.badge.clock")
                
                AIConfidenceView()
                
                ForEach(data.calendarEvents) { event in
                    GlassCard(padding: 12) {
                        HStack(spacing: 12) {
                            RoundedRectangle(cornerRadius: 4)
                                .fill(event.color)
                                .frame(width: 4, height: 44)
                            VStack(alignment: .leading, spacing: 2) {
                                Text(event.title)
                                    .font(.system(size: 15, weight: .semibold))
                                    .foregroundColor(theme.primaryText)
                                Text(event.start, style: .time)
                                    .font(.system(size: 13))
                                    .foregroundColor(theme.secondaryText)
                            }
                            Spacer()
                            Image(systemName: "sparkles")
                                .foregroundColor(theme.accent)
                        }
                    }
                }
            }
            .padding(AppTheme.padding)
        }
        .futuristicBackground()
        .navigationBarHidden(true)
    }
}
