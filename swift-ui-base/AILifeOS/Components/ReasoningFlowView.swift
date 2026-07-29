//
//  ReasoningFlowView.swift
//  AI Life OS
//

import SwiftUI

enum ReasoningStage: Int, CaseIterable, Identifiable {
    case memoryEngine, worldModel, knowledgeFusion, futureSimulation, decisionEngine, trustEngine, response
    
    var id: Int { rawValue }
    
    var title: String {
        switch self {
        case .memoryEngine: return "Memory Engine"
        case .worldModel: return "World Model"
        case .knowledgeFusion: return "Knowledge Fusion"
        case .futureSimulation: return "Future Simulation"
        case .decisionEngine: return "Decision Engine"
        case .trustEngine: return "Trust Engine"
        case .response: return "Response"
        }
    }
    
    var icon: String {
        switch self {
        case .memoryEngine: return "brain.head.profile"
        case .worldModel: return "globe.americas.fill"
        case .knowledgeFusion: return "point.3.connected.trianglepath.dotted"
        case .futureSimulation: return "sparkle.magnifyingglass"
        case .decisionEngine: return "arrow.triangle.branch"
        case .trustEngine: return "shield.checkered"
        case .response: return "text.bubble.fill"
        }
    }
    
    var detail: String {
        switch self {
        case .memoryEngine: return "Scanning 847 memories..."
        case .worldModel: return "Mapping life graph nodes..."
        case .knowledgeFusion: return "Discovering hidden relations..."
        case .futureSimulation: return "Running 3 scenarios..."
        case .decisionEngine: return "Evaluating optimal paths..."
        case .trustEngine: return "Calibrating confidence..."
        case .response: return "Synthesizing answer..."
        }
    }
}

struct ReasoningFlowView: View {
    @Binding var currentStage: ReasoningStage?
    @Environment(\.colorScheme) private var colorScheme
    @State private var completedStages: Set<ReasoningStage> = []
    @State private var activeGlow = false
    
    var body: some View {
        let theme = colorScheme == .dark ? ThemeColors.dark : ThemeColors.light
        
        VStack(alignment: .leading, spacing: 0) {
            HStack(spacing: 8) {
                Image(systemName: "cpu.fill")
                    .foregroundColor(theme.accent)
                    .pulse()
                Text("AI Reasoning Pipeline")
                    .font(.system(size: 14, weight: .bold, design: .rounded))
                    .foregroundColor(theme.primaryText)
            }
            .padding(.bottom, 12)
            
            ForEach(ReasoningStage.allCases) { stage in
                ReasoningStageRow(
                    stage: stage,
                    isActive: currentStage == stage,
                    isCompleted: completedStages.contains(stage),
                    theme: theme
                )
                
                if stage != .response {
                    ReasoningConnector(isActive: completedStages.contains(stage), theme: theme)
                }
            }
        }
        .padding(14)
        .glassSurface(cornerRadius: 16)
        .onChange(of: currentStage) { stage in
            guard let stage = stage else { return }
            if let prev = ReasoningStage(rawValue: stage.rawValue - 1) {
                withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                    completedStages.insert(prev)
                }
            }
        }
    }
    
    func reset() {
        completedStages = []
        currentStage = nil
    }
}

struct ReasoningStageRow: View {
    let stage: ReasoningStage
    let isActive: Bool
    let isCompleted: Bool
    let theme: ThemeColors
    
    @State private var shimmer = false
    
    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(statusColor.opacity(isActive ? 0.25 : 0.1))
                    .frame(width: 36, height: 36)
                if isCompleted {
                    Image(systemName: "checkmark")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(theme.success)
                } else {
                    Image(systemName: stage.icon)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(isActive ? theme.accent : theme.tertiaryText)
                        .scaleEffect(isActive ? 1.1 : 1.0)
                }
            }
            .glow(isActive ? theme.accent : .clear, radius: 8, intensity: 0.5)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(stage.title)
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(isActive || isCompleted ? theme.primaryText : theme.tertiaryText)
                if isActive {
                    Text(stage.detail)
                        .font(.system(size: 11))
                        .foregroundColor(theme.accent)
                        .transition(.opacity)
                }
            }
            Spacer()
            if isActive {
                ProgressView()
                    .scaleEffect(0.7)
                    .tint(theme.accent)
            }
        }
        .padding(.vertical, 4)
        .animation(.spring(response: 0.4, dampingFraction: 0.8), value: isActive)
    }
    
    private var statusColor: Color {
        if isCompleted { return theme.success }
        if isActive { return theme.accent }
        return theme.tertiaryText
    }
}

struct ReasoningConnector: View {
    let isActive: Bool
    let theme: ThemeColors
    @State private var flowOffset: CGFloat = 0
    
    var body: some View {
        HStack {
            Rectangle()
                .fill(isActive ? theme.accent.opacity(0.5) : theme.border.opacity(0.3))
                .frame(width: 2, height: 16)
                .offset(x: 17)
            Spacer()
        }
    }
}
