//
//  PredictionsScreen.swift
//  AI Life OS
//

import SwiftUI

struct PredictionsScreen: View {
    @ObservedObject private var data = MockDataStore.shared
    @EnvironmentObject var appState: AppState
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        let theme = colorScheme == .dark ? ThemeColors.dark : ThemeColors.light
        
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 16) {
                Text("Predictions")
                    .font(.system(size: 34, weight: .bold, design: .rounded))
                    .foregroundColor(theme.primaryText)
                    .padding(.top, 8)
                
                Text("AI forecasts based on your patterns")
                    .foregroundColor(theme.secondaryText)
                
                ForEach(data.predictions) { prediction in
                    GlassCard {
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Text(prediction.title)
                                    .font(.system(size: 17, weight: .semibold))
                                    .foregroundColor(theme.primaryText)
                                Spacer()
                                probabilityRing(prediction.probability, theme: theme)
                            }
                            Text(prediction.timeframe)
                                .font(.system(size: 13, weight: .medium))
                                .foregroundColor(theme.accent)
                            Text(prediction.recommendation)
                                .font(.system(size: 14))
                                .foregroundColor(theme.secondaryText)
                                .padding(10)
                                .background(RoundedRectangle(cornerRadius: 10).fill(theme.accent.opacity(0.08)))
                        }
                    }
                }
            }
            .padding(AppTheme.padding)
        }
        .themedBackground()
        .navigationBarHidden(true)
    }
    
    private func probabilityRing(_ value: Double, theme: ThemeColors) -> some View {
        ZStack {
            Circle()
                .stroke(theme.border, lineWidth: 4)
                .frame(width: 44, height: 44)
            Circle()
                .trim(from: 0, to: CGFloat(value))
                .stroke(theme.accent, style: StrokeStyle(lineWidth: 4, lineCap: .round))
                .frame(width: 44, height: 44)
                .rotationEffect(.degrees(-90))
            Text("\(Int(value * 100))%")
                .font(.system(size: 11, weight: .bold))
                .foregroundColor(theme.primaryText)
        }
    }
}
