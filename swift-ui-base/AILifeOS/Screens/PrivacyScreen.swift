//
//  PrivacyScreen.swift
//  AI Life OS
//

import SwiftUI

struct PrivacyScreen: View {
    @Environment(\.colorScheme) private var colorScheme
    
    private let sections: [(title: String, body: String)] = [
        ("Data Collection", "This prototype uses local mock data only. No information is transmitted to external servers."),
        ("AI Processing", "AI features in this demo simulate responses locally. No real AI inference occurs."),
        ("Your Memories", "Memory items are stored as demo data within the app bundle for UI demonstration."),
        ("Third Parties", "No third-party analytics or tracking is included in this prototype."),
        ("Your Rights", "You can reset the app by clearing UserDefaults or reinstalling the application.")
    ]
    
    var body: some View {
        let theme = colorScheme == .dark ? ThemeColors.dark : ThemeColors.light
        
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 16) {
                Text("Privacy")
                    .font(.system(size: 34, weight: .bold, design: .rounded))
                    .foregroundColor(theme.primaryText)
                    .padding(.top, 8)
                
                Text("Last updated: July 2026")
                    .font(.system(size: 14))
                    .foregroundColor(theme.secondaryText)
                
                ForEach(sections.indices, id: \.self) { index in
                    GlassCard {
                        VStack(alignment: .leading, spacing: 8) {
                            Text(sections[index].title)
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(theme.primaryText)
                            Text(sections[index].body)
                                .font(.system(size: 14))
                                .foregroundColor(theme.secondaryText)
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
