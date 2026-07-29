//
//  VoiceChatScreen.swift
//  AI Life OS — Voice with Reasoning Pipeline
//

import SwiftUI

struct VoiceChatScreen: View {
    @EnvironmentObject var appState: AppState
    @ObservedObject private var motion = MotionManager.shared
    @Environment(\.colorScheme) private var colorScheme

    enum VoiceState { case idle, listening, reasoning, responding }

    @State private var voiceState: VoiceState = .idle
    @State private var transcript = ""
    @State private var response = ""
    @State private var currentReasoningStage: ReasoningStage?
    @State private var completedStages: Set<Int> = []
    @State private var ringPulse = false

    var body: some View {
        let theme = colorScheme == .dark ? ThemeColors.dark : ThemeColors.light

        ZStack {
            FuturisticBackground()

            VStack(spacing: 0) {
                // Header
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Voice AI")
                            .font(.system(size: 28, weight: .bold, design: .rounded))
                            .foregroundColor(theme.primaryText)
                        Text("Reasoning-powered voice")
                            .font(.system(size: 13))
                            .foregroundColor(theme.secondaryText)
                    }
                    Spacer()
                    IconButton(icon: "keyboard", action: { appState.navigate(to: .aiChat) })
                }
                .padding(.horizontal, AppTheme.padding)
                .padding(.top, 8)

                Spacer()

                // Orb + rings
                ZStack {
                    ForEach(0..<4, id: \.self) { i in
                        Circle()
                            .stroke(
                                theme.accent.opacity(voiceState == .listening ? 0.35 : 0.08),
                                lineWidth: 1.5
                            )
                            .frame(width: CGFloat(110 + i * 44), height: CGFloat(110 + i * 44))
                            .scaleEffect(ringPulse ? 1.06 : 0.96)
                            .animation(
                                .easeInOut(duration: 1.1 + Double(i) * 0.15)
                                    .repeatForever(autoreverses: true)
                                    .delay(Double(i) * 0.1),
                                value: ringPulse
                            )
                    }

                    // Core orb
                    ZStack {
                        BreathingGlow(color: theme.accent, size: 150)
                        Circle()
                            .fill(LinearGradient(
                                colors: [theme.gradientStart, theme.gradientEnd],
                                startPoint: .topLeading, endPoint: .bottomTrailing
                            ))
                            .frame(width: 100, height: 100)
                            .glow(theme.accent, radius: 16, intensity: 0.7)
                        Image(systemName: orbIcon)
                            .font(.system(size: 38, weight: .semibold))
                            .foregroundColor(.white)
                            .animation(.spring(response: 0.35, dampingFraction: 0.7), value: orbIcon)
                    }
                    .rotation3DEffect(
                        .degrees(motion.tiltRotation),
                        axis: (x: 0, y: 1, z: 0)
                    )
                    .offset(motion.parallaxOffset)
                }
                .frame(height: 260)

                // Status label
                Text(statusText)
                    .font(.system(size: 20, weight: .semibold, design: .rounded))
                    .foregroundColor(theme.primaryText)
                    .padding(.top, 8)
                    .animation(.spring(response: 0.4, dampingFraction: 0.8), value: statusText)

                Spacer()

                // Reasoning pipeline (shown during reasoning state)
                if voiceState == .reasoning {
                    VoiceReasoningView(
                        currentStage: $currentReasoningStage,
                        completedStages: $completedStages
                    )
                    .padding(.horizontal, AppTheme.padding)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                }

                // Transcript / response card
                if !transcript.isEmpty {
                    VStack(spacing: 8) {
                        GlassCard(padding: 14) {
                            VStack(alignment: .leading, spacing: 6) {
                                Label("You said", systemImage: "person.fill")
                                    .font(.system(size: 11, weight: .semibold))
                                    .foregroundColor(theme.secondaryText)
                                Text(transcript)
                                    .font(.system(size: 15))
                                    .foregroundColor(theme.primaryText)
                                    .multilineTextAlignment(.leading)
                            }
                        }
                        if !response.isEmpty {
                            GlassCard(padding: 14) {
                                VStack(alignment: .leading, spacing: 6) {
                                    Label("AI Response", systemImage: "sparkles")
                                        .font(.system(size: 11, weight: .semibold))
                                        .foregroundColor(theme.accent)
                                    Text(response)
                                        .font(.system(size: 15))
                                        .foregroundColor(theme.primaryText)
                                        .multilineTextAlignment(.leading)
                                }
                            }
                        }
                    }
                    .padding(.horizontal, AppTheme.padding)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                }

                Spacer()

                // Controls
                HStack(spacing: 28) {
                    IconButton(icon: "ellipsis", action: { appState.showToast("Voice settings") })

                    Button(action: handleMicTap) {
                        ZStack {
                            Circle()
                                .fill(voiceState == .listening ? theme.error : theme.accent)
                                .frame(width: 72, height: 72)
                                .glow(voiceState == .listening ? theme.error : theme.accent,
                                      radius: 12, intensity: 0.6)
                            Image(systemName: voiceState == .listening ? "stop.fill" : "mic.fill")
                                .font(.system(size: 26, weight: .semibold))
                                .foregroundColor(.white)
                        }
                    }
                    .buttonStyle(PressableButtonStyle())
                    .disabled(voiceState == .reasoning)

                    IconButton(icon: "waveform", action: { appState.showToast("Audio settings") })
                }
                .padding(.bottom, 36)
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            motion.start()
            ringPulse = true
        }
        .onDisappear { motion.stop() }
    }

    // MARK: - Computed

    private var orbIcon: String {
        switch voiceState {
        case .idle:       return "mic.fill"
        case .listening:  return "waveform"
        case .reasoning:  return "cpu.fill"
        case .responding: return "text.bubble.fill"
        }
    }

    private var statusText: String {
        switch voiceState {
        case .idle:       return "Tap to speak with AI"
        case .listening:  return "Listening…"
        case .reasoning:  return "Reasoning through \(currentReasoningStage?.title ?? "pipeline")…"
        case .responding: return "AI response ready"
        }
    }

    // MARK: - Logic

    private func handleMicTap() {
        HapticFeedback.medium()
        if voiceState == .listening {
            // User finished speaking → run reasoning
            withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                transcript = "Block my afternoon and summarize today's priorities."
                voiceState = .reasoning
                completedStages = []
            }
            runReasoningPipeline()
        } else if voiceState == .idle || voiceState == .responding {
            // Start listening
            withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                voiceState = .listening
                transcript = ""
                response = ""
                completedStages = []
            }
        }
    }

    private func runReasoningPipeline() {
        let stages = ReasoningStage.allCases
        let stageDuration = 0.65

        for (index, stage) in stages.enumerated() {
            DispatchQueue.main.asyncAfter(deadline: .now() + stageDuration * Double(index)) {
                withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                    currentReasoningStage = stage
                }
                HapticFeedback.light()
            }
        }

        let totalDuration = stageDuration * Double(stages.count) + 0.4
        DispatchQueue.main.asyncAfter(deadline: .now() + totalDuration) {
            withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                voiceState = .responding
                currentReasoningStage = nil
                response = "I've blocked 2–5 PM for focused work and muted non-urgent notifications. Your top 3 priorities: (1) finish Q2 roadmap draft, (2) investor deck slides 8–12, (3) evening run to maintain streak."
            }
            HapticFeedback.success()
        }
    }
}

// MARK: - Voice Reasoning View (compact version)

struct VoiceReasoningView: View {
    @Binding var currentStage: ReasoningStage?
    @Binding var completedStages: Set<Int>
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        let theme = colorScheme == .dark ? ThemeColors.dark : ThemeColors.light

        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(ReasoningStage.allCases) { stage in
                    let isActive = currentStage == stage
                    let isDone   = (currentStage.map { $0.rawValue } ?? -1) > stage.rawValue

                    VStack(spacing: 6) {
                        ZStack {
                            Circle()
                                .fill((isActive ? theme.accent : isDone ? theme.success : theme.border).opacity(0.15))
                                .frame(width: 38, height: 38)
                            if isDone {
                                Image(systemName: "checkmark")
                                    .font(.system(size: 13, weight: .bold))
                                    .foregroundColor(theme.success)
                            } else {
                                Image(systemName: stage.icon)
                                    .font(.system(size: 13))
                                    .foregroundColor(isActive ? theme.accent : theme.tertiaryText)
                            }
                        }
                        .glow(isActive ? theme.accent : .clear, radius: 6, intensity: 0.5)
                        Text(stage.title)
                            .font(.system(size: 9, weight: .semibold))
                            .foregroundColor(isActive ? theme.primaryText : theme.tertiaryText)
                            .lineLimit(2)
                            .multilineTextAlignment(.center)
                            .frame(width: 56)
                    }
                    .animation(.spring(response: 0.4, dampingFraction: 0.8), value: isActive)
                }
            }
            .padding(.horizontal, 4)
            .padding(.vertical, 10)
        }
        .glassSurface(cornerRadius: 16)
    }
}
