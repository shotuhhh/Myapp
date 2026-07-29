//
//  SubscriptionScreen.swift
//  AI Life OS
//

import SwiftUI

struct SubscriptionScreen: View {
    @ObservedObject private var data = MockDataStore.shared
    @EnvironmentObject var appState: AppState
    @Environment(\.colorScheme) private var colorScheme
    @State private var selectedPlanId = "s2"
    
    var body: some View {
        let theme = colorScheme == .dark ? ThemeColors.dark : ThemeColors.light
        
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 20) {
                Text("Subscription")
                    .font(.system(size: 34, weight: .bold, design: .rounded))
                    .foregroundColor(theme.primaryText)
                    .padding(.top, 8)
                
                Text("Unlock the full power of AI Life OS")
                    .foregroundColor(theme.secondaryText)
                
                ForEach(data.subscriptionPlans) { plan in
                    Button(action: { selectedPlanId = plan.id; HapticFeedback.selection() }) {
                        GlassCard {
                            VStack(alignment: .leading, spacing: 12) {
                                HStack {
                                    Text(plan.name)
                                        .font(.system(size: 20, weight: .bold, design: .rounded))
                                        .foregroundColor(theme.primaryText)
                                    if plan.isPopular {
                                        Text("POPULAR")
                                            .font(.system(size: 10, weight: .bold))
                                            .foregroundColor(.white)
                                            .padding(.horizontal, 8)
                                            .padding(.vertical, 4)
                                            .background(theme.accent)
                                            .clipShape(Capsule())
                                    }
                                    Spacer()
                                    Image(systemName: selectedPlanId == plan.id ? "checkmark.circle.fill" : "circle")
                                        .foregroundColor(theme.accent)
                                        .font(.system(size: 22))
                                }
                                HStack(alignment: .firstTextBaseline, spacing: 4) {
                                    Text(plan.price)
                                        .font(.system(size: 28, weight: .bold))
                                        .foregroundColor(theme.primaryText)
                                    Text(plan.period)
                                        .font(.system(size: 14))
                                        .foregroundColor(theme.secondaryText)
                                }
                                ForEach(plan.features, id: \.self) { feature in
                                    HStack(spacing: 8) {
                                        Image(systemName: "checkmark")
                                            .font(.system(size: 12, weight: .bold))
                                            .foregroundColor(theme.success)
                                        Text(feature)
                                            .font(.system(size: 14))
                                            .foregroundColor(theme.secondaryText)
                                    }
                                }
                            }
                        }
                        .overlay(
                            RoundedRectangle(cornerRadius: AppTheme.cardRadius)
                                .stroke(selectedPlanId == plan.id ? theme.accent : Color.clear, lineWidth: 2)
                        )
                    }
                    .buttonStyle(PressableButtonStyle())
                }
                
                PremiumButton("Subscribe", icon: "crown.fill", action: { appState.showToast("Welcome to Pro!") })
                Text("Cancel anytime. Demo — no real payment.")
                    .font(.system(size: 12))
                    .foregroundColor(theme.tertiaryText)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity)
            }
            .padding(AppTheme.padding)
        }
        .themedBackground()
        .navigationBarHidden(true)
    }
}
