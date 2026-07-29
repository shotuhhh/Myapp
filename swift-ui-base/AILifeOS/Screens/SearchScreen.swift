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
            $0.title.localizedCaseInsensitiveContains(query) ||
            $0.subtitle.localizedCaseInsensitiveContains(query)
        }
    }

    var body: some View {
        let theme = colorScheme == .dark ? ThemeColors.dark : ThemeColors.light

        ZStack {
            FuturisticBackground()
            VStack(spacing: 14) {
                // Search bar
                HStack(spacing: 10) {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(theme.secondaryText)
                    TextField("Search modules, goals, memories...", text: $query, onEditingChanged: {
                        isSearching = $0
                    })
                    .foregroundColor(theme.primaryText)
                    if !query.isEmpty {
                        Button(action: { query = "" }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(theme.tertiaryText)
                        }
                    }
                }
                .padding(14)
                .glassSurface(cornerRadius: 14)
                .padding(.horizontal, AppTheme.padding)
                .padding(.top, 8)

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 8) {
                        if results.isEmpty {
                            EmptyStateView(
                                icon: "magnifyingglass",
                                title: "No results",
                                message: "Try a different search term."
                            )
                            .padding(.top, 40)
                        } else {
                            ForEach(results) { result in
                                resultRow(result, theme: theme)
                            }
                        }
                    }
                    .padding(.horizontal, AppTheme.padding)
                }
            }
        }
        .navigationBarHidden(true)
    }

    private func resultRow(_ result: SearchResult, theme: ThemeColors) -> some View {
        Button(action: {
            appState.pop()
            appState.navigate(to: result.route)
        }) {
            HStack(spacing: 14) {
                Image(systemName: result.icon)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(theme.accent)
                    .frame(width: 36, height: 36)
                    .background(theme.accent.opacity(0.12))
                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                    .glow(theme.accent, radius: 4, intensity: 0.25)
                VStack(alignment: .leading, spacing: 2) {
                    Text(result.title)
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(theme.primaryText)
                    Text(result.subtitle)
                        .font(.system(size: 13))
                        .foregroundColor(theme.secondaryText)
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(theme.tertiaryText)
            }
            .padding(12)
            .glassSurface(cornerRadius: 14)
        }
        .buttonStyle(PressableButtonStyle())
    }
}
