//
//  HabitsScreen.swift
//  AI Life OS
//

import SwiftUI

struct HabitsScreen: View {
    @ObservedObject private var data = MockDataStore.shared
    @EnvironmentObject var appState: AppState
    @Environment(\.colorScheme) private var colorScheme
    @State private var habits: [HabitItem] = MockDataStore.shared.habits
    
    var body: some View {
        let theme = colorScheme == .dark ? ThemeColors.dark : ThemeColors.light
        
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 16) {
                Text("Habits")
                    .font(.system(size: 34, weight: .bold, design: .rounded))
                    .foregroundColor(theme.primaryText)
                    .padding(.top, 8)
                
                HStack(spacing: 12) {
                    StatCard(label: "Streak avg", value: "18d", icon: "flame.fill", accent: theme.warning)
                    StatCard(label: "Today", value: "\(habits.filter { $0.completedToday }.count)/\(habits.count)", icon: "checkmark.circle.fill")
                }
                
                ForEach(habits.indices, id: \.self) { index in
                    let habit = habits[index]
                    GlassCard {
                        HStack(spacing: 14) {
                            Button(action: { toggleHabit(at: index) }) {
                                Image(systemName: habit.completedToday ? "checkmark.circle.fill" : "circle")
                                    .font(.system(size: 28))
                                    .foregroundColor(habit.completedToday ? theme.success : theme.tertiaryText)
                            }
                            Image(systemName: habit.icon)
                                .foregroundColor(theme.accent)
                                .frame(width: 36, height: 36)
                                .background(theme.accent.opacity(0.12))
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                            VStack(alignment: .leading, spacing: 4) {
                                Text(habit.name)
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(theme.primaryText)
                                Text("\(habit.frequency) · \(habit.streak)-day streak")
                                    .font(.system(size: 13))
                                    .foregroundColor(theme.secondaryText)
                            }
                            Spacer()
                            Text("\(Int(habit.completionRate * 100))%")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(theme.accent)
                        }
                    }
                }
                
                PremiumButton("Add Habit", icon: "plus", action: { appState.showToast("Habit added") })
            }
            .padding(AppTheme.padding)
        }
        .themedBackground()
        .navigationBarHidden(true)
    }
    
    private func toggleHabit(at index: Int) {
        HapticFeedback.success()
        let h = habits[index]
        habits[index] = HabitItem(id: h.id, name: h.name, icon: h.icon, streak: h.streak, completionRate: h.completionRate, frequency: h.frequency, completedToday: !h.completedToday)
        if habits[index].completedToday {
            appState.showToast("Habit completed!")
        }
    }
}
