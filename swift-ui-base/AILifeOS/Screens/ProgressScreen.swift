//
//  ProgressScreen.swift
//  AI Life OS
//

import SwiftUI

struct ProgressScreen: View {
    @ObservedObject private var data = MockDataStore.shared
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        let theme = colorScheme == .dark ? ThemeColors.dark : ThemeColors.light
        
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 16) {
                Text("Progress")
                    .font(.system(size: 34, weight: .bold, design: .rounded))
                    .foregroundColor(theme.primaryText)
                    .padding(.top, 8)
                
                GlassCard {
                    HStack(spacing: 20) {
                        ForEach(data.progressAreas) { area in
                            ProgressRing(progress: Double(area.score) / 100, label: area.area, size: 64)
                        }
                    }
                }
                
                ForEach(data.progressAreas) { area in
                    GlassCard {
                        HStack {
                            Image(systemName: area.icon)
                                .foregroundColor(theme.accent)
                                .frame(width: 40, height: 40)
                                .background(theme.accent.opacity(0.12))
                                .clipShape(Circle())
                            VStack(alignment: .leading, spacing: 4) {
                                Text(area.area)
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(theme.primaryText)
                                HStack(spacing: 4) {
                                    Image(systemName: area.trend >= 0 ? "arrow.up.right" : "arrow.down.right")
                                        .font(.system(size: 11, weight: .bold))
                                    Text(String(format: "%.1f%% this month", abs(area.trend)))
                                        .font(.system(size: 13))
                                }
                                .foregroundColor(area.trend >= 0 ? theme.success : theme.error)
                            }
                            Spacer()
                            Text("\(area.score)")
                                .font(.system(size: 28, weight: .bold, design: .rounded))
                                .foregroundColor(theme.primaryText)
                        }
                    }
                }
            }
            .padding(AppTheme.padding)
        }
        .themedBackground()
        .navigationBarHidden(true)
    }
}
