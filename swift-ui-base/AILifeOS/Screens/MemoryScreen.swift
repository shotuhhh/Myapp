//
//  MemoryScreen.swift
//  AI Life OS
//

import SwiftUI

struct MemoryScreen: View {
    @ObservedObject private var data = MockDataStore.shared
    @EnvironmentObject var appState: AppState
    @Environment(\.colorScheme) private var colorScheme
    @State private var selectedCategory = "All"
    @State private var showError = false
    
    private var categories: [String] {
        ["All"] + Array(Set(data.memories.map { $0.category })).sorted()
    }
    
    private var filtered: [MemoryItem] {
        if selectedCategory == "All" { return data.memories }
        return data.memories.filter { $0.category == selectedCategory }
    }
    
    var body: some View {
        let theme = colorScheme == .dark ? ThemeColors.dark : ThemeColors.light
        
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 16) {
                Text("Memory")
                    .font(.system(size: 34, weight: .bold, design: .rounded))
                    .foregroundColor(theme.primaryText)
                    .padding(.top, 8)
                
                Text("What AI remembers about you")
                    .foregroundColor(theme.secondaryText)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(categories, id: \.self) { cat in
                            Button(action: { selectedCategory = cat; HapticFeedback.selection() }) {
                                ChipView(text: cat, isSelected: selectedCategory == cat)
                            }
                        }
                    }
                }
                
                if showError {
                    ErrorStateView(message: "Couldn't sync memories.", retryAction: { showError = false })
                } else if filtered.isEmpty {
                    EmptyStateView(icon: "brain", title: "No memories", message: "Chat with AI to build your memory graph.", actionTitle: "Open Chat", action: { appState.navigate(to: .aiChat) })
                } else {
                    ForEach(filtered) { memory in
                        GlassCard {
                            VStack(alignment: .leading, spacing: 8) {
                                HStack {
                                    Text(memory.title)
                                        .font(.system(size: 17, weight: .semibold))
                                        .foregroundColor(theme.primaryText)
                                    Spacer()
                                    importanceBadge(memory.importance, theme: theme)
                                }
                                Text(memory.summary)
                                    .font(.system(size: 14))
                                    .foregroundColor(theme.secondaryText)
                                HStack {
                                    ChipView(text: memory.category)
                                    ForEach(memory.tags.prefix(2), id: \.self) { tag in
                                        ChipView(text: tag)
                                    }
                                }
                            }
                        }
                    }
                }
                
                PremiumButton("Add Memory", icon: "plus", style: .secondary, action: { appState.showToast("Memory saved") })
            }
            .padding(AppTheme.padding)
        }
        .themedBackground()
        .navigationBarHidden(true)
    }
    
    private func importanceBadge(_ level: Int, theme: ThemeColors) -> some View {
        HStack(spacing: 2) {
            ForEach(0..<level, id: \.self) { _ in
                Image(systemName: "star.fill")
                    .font(.system(size: 10))
                    .foregroundColor(theme.warning)
            }
        }
    }
}
