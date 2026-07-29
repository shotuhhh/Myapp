//
//  SearchScreen.swift
//  AI Life OS
//

import SwiftUI

struct SearchScreen: View {
    @ObservedObject private var data = MockDataStore.shared
    @EnvironmentObject var appState: AppState
    @Environment(\.colorScheme) private var colorScheme
    @State private var query = ""
    @State private var isSearching = false
    
    private var results: [SearchResult] {
        guard !query.isEmpty else { return data.searchResults }
        return data.searchResults.filter {
            $0.title.localizedCaseInsensitiveContains(query) || $0.subtitle.localizedCaseInsensitiveContains(query)
        }
    }
    
    var body: some View {
        let theme = colorScheme == .dark ? ThemeColors.dark : ThemeColors.light
        
        VStack(spacing: 16) {
            HStack(spacing: 10) {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(theme.secondaryText)
                TextField("Search goals, habits, chats...", text: $query, onEditingChanged: { editing in
                    isSearching = editing
                })
                if !query.isEmpty {
                    Button(action: { query = "" }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(theme.tertiaryText)
                    }
                }
            }
            .padding(14)
            .background(RoundedRectangle(cornerRadius: 14).fill(theme.cardBackground))
            .padding(.horizontal, AppTheme.padding)
            .padding(.top, 8)
            
            ScrollView(showsIndicators: false) {
                if isSearching && query.isEmpty {
                    VStack(spacing: 12) {
                        Text("Recent")
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundColor(theme.secondaryText)
                            .padding(.horizontal, AppTheme.padding)
                        ForEach(data.searchResults) { result in
                            resultRow(result, theme: theme)
                        }
                    }
                } else if results.isEmpty {
                    EmptyStateView(icon: "magnifyingglass", title: "No results", message: "Try a different search term.")
                        .padding(.top, 40)
                } else {
                    VStack(spacing: 8) {
                        ForEach(results) { result in
                            resultRow(result, theme: theme)
                        }
                    }
                    .padding(.horizontal, AppTheme.padding)
                }
            }
        }
        .themedBackground()
        .navigationBarHidden(true)
    }
    
    private func resultRow(_ result: SearchResult, theme: ThemeColors) -> some View {
        Button(action: {
            appState.pop()
            appState.navigate(to: result.route)
        }) {
            NavigationRow(icon: result.icon, title: result.title, subtitle: result.subtitle)
                .padding(12)
                .background(RoundedRectangle(cornerRadius: AppTheme.cornerRadius).fill(theme.cardBackground))
        }
        .buttonStyle(PressableButtonStyle())
    }
}
