//
//  AIChatScreen.swift
//  AI Life OS
//

import SwiftUI

struct AIChatScreen: View {
    @EnvironmentObject var appState: AppState
    @ObservedObject private var data = MockDataStore.shared
    @Environment(\.colorScheme) private var colorScheme
    @State private var inputText = ""
    @State private var messages: [ChatMessage] = MockDataStore.shared.chatMessages
    @State private var isReasoning = false
    @State private var currentReasoningStage: ReasoningStage?
    @State private var pendingResponse = ""
    
    var body: some View {
        let theme = colorScheme == .dark ? ThemeColors.dark : ThemeColors.light
        
        ZStack {
            FuturisticBackground()
            
            VStack(spacing: 0) {
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("AI Assistant")
                            .font(.system(size: 28, weight: .bold, design: .rounded))
                            .foregroundColor(theme.primaryText)
                        Text("Reasoning-powered responses")
                            .font(.system(size: 13))
                            .foregroundColor(theme.secondaryText)
                    }
                    Spacer()
                    IconButton(icon: "waveform.circle.fill", action: { appState.navigate(to: .voiceChat) })
                }
                .padding(.horizontal, AppTheme.padding)
                .padding(.top, 8)
                
                ScrollViewReader { proxy in
                    ScrollView(showsIndicators: false) {
                        LazyVStack(spacing: 12) {
                            ForEach(messages) { message in
                                ChatBubble(message: message, theme: theme)
                                    .id(message.id)
                            }
                            
                            if isReasoning {
                                ReasoningFlowView(currentStage: $currentReasoningStage)
                                    .padding(.horizontal, AppTheme.padding)
                                    .transition(.move(edge: .bottom).combined(with: .opacity))
                                    .id("reasoning")
                            }
                        }
                        .padding(AppTheme.padding)
                    }
                    .onChange(of: messages.count) { _ in
                        scrollToBottom(proxy: proxy)
                    }
                    .onChange(of: isReasoning) { _ in
                        scrollToBottom(proxy: proxy)
                    }
                }
                
                inputBar(theme: theme)
            }
        }
        .navigationBarHidden(true)
    }
    
    private func scrollToBottom(proxy: ScrollViewProxy) {
        if isReasoning {
            withAnimation { proxy.scrollTo("reasoning", anchor: .bottom) }
        } else if let last = messages.last {
            withAnimation { proxy.scrollTo(last.id, anchor: .bottom) }
        }
    }
    
    private func inputBar(theme: ThemeColors) -> some View {
        HStack(spacing: 10) {
            TextField("Ask your AI Life OS...", text: $inputText)
                .padding(12)
                .glassSurface(cornerRadius: 14)
            Button(action: sendMessage) {
                Image(systemName: "arrow.up.circle.fill")
                    .font(.system(size: 36))
                    .foregroundColor(theme.accent)
                    .glow(theme.accent, radius: 8, intensity: 0.5)
            }
            .disabled(inputText.trimmingCharacters(in: .whitespaces).isEmpty || isReasoning)
        }
        .padding(AppTheme.padding)
    }
    
    private func sendMessage() {
        let text = inputText.trimmingCharacters(in: .whitespaces)
        guard !text.isEmpty, !isReasoning else { return }
        HapticFeedback.light()
        messages.append(ChatMessage(id: UUID().uuidString, role: .user, content: text, timestamp: Date()))
        inputText = ""
        
        pendingResponse = generateResponse(for: text)
        runReasoningPipeline()
    }
    
    private func generateResponse(for query: String) -> String {
        if query.lowercased().contains("priorit") {
            return "Based on my analysis across Memory, World Model, and Future Simulation: Top priority is finishing the Q2 roadmap draft (high impact, 91% confidence). Your 9–11 AM focus window is optimal. I've adjusted today's schedule accordingly."
        }
        if query.lowercased().contains("sleep") || query.lowercased().contains("health") {
            return "Memory Engine found a strong Sleep→Mood→Work correlation in your data. 7.5 hours is your sweet spot (+18% habit completion). I recommend maintaining your 10:30 PM wind-down routine."
        }
        return "I've processed your request through all reasoning stages. Based on your goals, patterns, and future simulations, I recommend scheduling this during your peak focus window (9–11 AM) with 87% confidence."
    }
    
    private func runReasoningPipeline() {
        isReasoning = true
        currentReasoningStage = .memoryEngine
        HapticFeedback.medium()
        
        let stages = ReasoningStage.allCases
        let stageDuration = 0.7
        
        for (index, stage) in stages.enumerated() {
            DispatchQueue.main.asyncAfter(deadline: .now() + stageDuration * Double(index)) {
                withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                    currentReasoningStage = stage
                }
                HapticFeedback.light()
            }
        }
        
        let totalDuration = stageDuration * Double(stages.count) + 0.3
        DispatchQueue.main.asyncAfter(deadline: .now() + totalDuration) {
            withAnimation {
                isReasoning = false
                currentReasoningStage = nil
            }
            messages.append(ChatMessage(
                id: UUID().uuidString,
                role: .assistant,
                content: pendingResponse,
                timestamp: Date()
            ))
            HapticFeedback.success()
        }
    }
}

struct ChatBubble: View {
    let message: ChatMessage
    let theme: ThemeColors
    
    var isUser: Bool { message.role == .user }
    
    var body: some View {
        HStack {
            if isUser { Spacer(minLength: 48) }
            Text(message.content)
                .font(.system(size: 15))
                .foregroundColor(isUser ? .white : theme.primaryText)
                .padding(14)
                .background(
                    Group {
                        if isUser {
                            RoundedRectangle(cornerRadius: 18, style: .continuous)
                                .fill(LinearGradient(colors: [theme.gradientStart, theme.gradientEnd], startPoint: .topLeading, endPoint: .bottomTrailing))
                        } else {
                            RoundedRectangle(cornerRadius: 18, style: .continuous)
                                .fill(.ultraThinMaterial)
                        }
                    }
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .stroke(isUser ? Color.clear : theme.border.opacity(0.3), lineWidth: 0.5)
                )
            if !isUser { Spacer(minLength: 48) }
        }
    }
}
