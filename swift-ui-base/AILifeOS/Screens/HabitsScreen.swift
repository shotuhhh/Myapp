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
        let completed = habits.filter { $0.completedToday }.count

        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 16) {
                ModuleHeader(title: "Health & Habits", subtitle: "AI-tracked · \(completed)/\(habits.count) done today", icon: "heart.fill")

                // Stats row
                HStack(spacing: 10) {
                    StatCard(label: "Avg streak", value: "18d", icon: "flame.fill", accent: theme.warning)
                    StatCard(label: "Today", value: "\(completed)/\(habits.count)", icon: "checkmark.circle.fill")
                }

                // Completion arc
                GlassCard {
                    HStack(spacing: 20) {
                        ProgressRing(
                            progress: habits.isEmpty ? 0 : Double(completed) / Double(habits.count),
                            label: "Today",
                            size: 72
                        )
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Daily completion")
                                .font(.system(size: 13, weight: .semibold))
                                .foregroundColor(theme.secondaryText)
                            Text(completed == habits.count ? "All done! 🎉" : "\(habits.count - completed) remaining")
                                .font(.system(size: 16, weight: .bold, design: .rounded))
                                .foregroundColor(theme.primaryText)
                            Text("Best streak: 28 days")
                                .font(.system(size: 12))
                                .foregroundColor(theme.accent)
                        }
                        Spacer()
                    }
                }

                ForEach(habits.indices, id: \.self) { index in
                    let habit = habits[index]
                    GlassCard(padding: 14) {
                        HStack(spacing: 14) {
                            Button(action: { toggleHabit(at: index) }) {
                                Image(systemName: habit.completedToday ? "checkmark.circle.fill" : "circle")
                                    .font(.system(size: 28))
                                    .foregroundColor(habit.completedToday ? theme.success : theme.tertiaryText)
                                    .glow(habit.completedToday ? theme.success : .clear, radius: 6, intensity: 0.5)
                            }
                            Image(systemName: habit.icon)
                                .font(.system(size: 17))
                                .foregroundColor(theme.accent)
                                .frame(width: 38, height: 38)
                                .background(theme.accent.opacity(0.12))
                                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                            VStack(alignment: .leading, spacing: 3) {
                                Text(habit.name)
                                    .font(.system(size: 15, weight: .semibold))
                                    .foregroundColor(theme.primaryText)
                                Text("\(habit.frequency) · \(habit.streak)-day streak")
                                    .font(.system(size: 12))
                                    .foregroundColor(theme.secondaryText)
                            }
                            Spacer()
                            Text("\(Int(habit.completionRate * 100))%")
                                .font(.system(size: 14, weight: .bold, design: .monospaced))
                                .foregroundColor(theme.accent)
                        }
                    }
                    .animation(AppTheme.springAnimation, value: habit.completedToday)
                }

                PremiumButton("Add Habit", icon: "plus", action: { appState.showToast("Habit added") })
            }
            .padding(AppTheme.padding)
        }
        .futuristicBackground()
        .navigationBarHidden(true)
    }

    private func toggleHabit(at index: Int) {
        HapticFeedback.success()
        let h = habits[index]
        habits[index] = HabitItem(
            id: h.id, name: h.name, icon: h.icon, streak: h.streak,
            completionRate: h.completionRate, frequency: h.frequency,
            completedToday: !h.completedToday
        )
        if habits[index].completedToday {
            appState.showToast("Habit completed!")
        }
    }
}
