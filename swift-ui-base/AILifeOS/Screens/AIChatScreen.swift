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
    @State private var isTyping = false
    
    var body: some View {
        let theme = colorScheme == .dark ? ThemeColors.dark : ThemeColors.light
        
        VStack(spacing: 0) {
            HStack {
                Text("AI Chat")
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                    .foregroundColor(theme.primaryText)
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
                        if isTyping {
                            typingIndicator(theme: theme)
                        }
                    }
                    .padding(AppTheme.padding)
                }
                .onChange(of: messages.count) { _ in
                    if let last = messages.last {
                        withAnimation { proxy.scrollTo(last.id, anchor: .bottom) }
                    }
                }
            }
            
            inputBar(theme: theme)
        }
        .themedBackground()
        .navigationBarHidden(true)
    }
    
    private func typingIndicator(theme: ThemeColors) -> some View {
        HStack {
            HStack(spacing: 4) {
                ForEach(0..<3, id: \.self) { i in
                    Circle()
                        .fill(theme.secondaryText)
                        .frame(width: 6, height: 6)
                        .opacity(0.6)
                }
            }
            .padding(12)
            .background(RoundedRectangle(cornerRadius: 16).fill(theme.cardBackground))
            Spacer()
        }
    }
    
    private func inputBar(theme: ThemeColors) -> some View {
        HStack(spacing: 10) {
            TextField("Ask your AI assistant...", text: $inputText)
                .padding(12)
                .background(RoundedRectangle(cornerRadius: 14).fill(theme.cardBackground))
            Button(action: sendMessage) {
                Image(systemName: "arrow.up.circle.fill")
                    .font(.system(size: 36))
                    .foregroundColor(theme.accent)
            }
            .disabled(inputText.trimmingCharacters(in: .whitespaces).isEmpty)
        }
        .padding(AppTheme.padding)
        .background(theme.elevatedBackground)
    }
    
    private func sendMessage() {
        let text = inputText.trimmingCharacters(in: .whitespaces)
        guard !text.isEmpty else { return }
        HapticFeedback.light()
        messages.append(ChatMessage(id: UUID().uuidString, role: .user, content: text, timestamp: Date()))
        inputText = ""
        isTyping = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            isTyping = false
            messages.append(ChatMessage(
                id: UUID().uuidString,
                role: .assistant,
                content: "I've noted that. Based on your goals, I recommend scheduling this during your 9–11 AM focus window.",
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
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .fill(isUser ? theme.accent : theme.cardBackground)
                )
            if !isUser { Spacer(minLength: 48) }
        }
    }
}
