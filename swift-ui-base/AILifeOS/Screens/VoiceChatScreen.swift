//
//  VoiceChatScreen.swift
//  AI Life OS
//

import SwiftUI

struct VoiceChatScreen: View {
    @EnvironmentObject var appState: AppState
    @Environment(\.colorScheme) private var colorScheme
    @State private var isListening = false
    @State private var transcript = ""
    @State private var state: VoiceState = .idle
    
    enum VoiceState {
        case idle, listening, processing, responding
    }
    
    var body: some View {
        let theme = colorScheme == .dark ? ThemeColors.dark : ThemeColors.light
        
        VStack(spacing: 32) {
            Spacer()
            
            ZStack {
                ForEach(0..<3, id: \.self) { i in
                    Circle()
                        .stroke(theme.accent.opacity(isListening ? 0.3 : 0.1), lineWidth: 2)
                        .frame(width: CGFloat(120 + i * 40), height: CGFloat(120 + i * 40))
                        .scaleEffect(isListening ? 1.1 : 1.0)
                        .animation(.easeInOut(duration: 0.8).repeatForever(autoreverses: true).delay(Double(i) * 0.15), value: isListening)
                }
                
                Circle()
                    .fill(
                        LinearGradient(colors: [theme.gradientStart, theme.gradientEnd], startPoint: .topLeading, endPoint: .bottomTrailing)
                    )
                    .frame(width: 100, height: 100)
                    .overlay(
                        Image(systemName: state == .listening ? "waveform" : "mic.fill")
                            .font(.system(size: 36, weight: .semibold))
                            .foregroundColor(.white)
                    )
            }
            
            Text(statusText)
                .font(.system(size: 20, weight: .semibold, design: .rounded))
                .foregroundColor(theme.primaryText)
            
            if !transcript.isEmpty {
                GlassCard {
                    Text(transcript)
                        .font(.system(size: 16))
                        .foregroundColor(theme.primaryText)
                        .multilineTextAlignment(.center)
                }
                .padding(.horizontal, AppTheme.padding)
            }
            
            Spacer()
            
            HStack(spacing: 24) {
                IconButton(icon: "keyboard", action: { appState.navigate(to: .aiChat) })
                
                Button(action: toggleListening) {
                    Text(isListening ? "Stop" : "Speak")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(width: 120, height: 52)
                        .background(isListening ? theme.error : theme.accent)
                        .clipShape(Capsule())
                }
                .buttonStyle(PressableButtonStyle())
                
                IconButton(icon: "ellipsis", action: { appState.showToast("Voice settings") })
            }
            .padding(.bottom, 32)
        }
        .themedBackground()
        .navigationBarHidden(true)
    }
    
    private var statusText: String {
        switch state {
        case .idle: return "Tap to speak with AI"
        case .listening: return "Listening..."
        case .processing: return "Processing..."
        case .responding: return "AI is responding"
        }
    }
    
    private func toggleListening() {
        HapticFeedback.medium()
        if isListening {
            isListening = false
            state = .processing
            transcript = "Block my afternoon and summarize today's priorities."
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                state = .responding
                appState.showToast("Voice command processed")
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    state = .idle
                }
            }
        } else {
            isListening = true
            state = .listening
            transcript = ""
        }
    }
}
