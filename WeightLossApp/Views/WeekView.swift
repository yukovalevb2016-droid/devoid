import SwiftUI
import SwiftData
import Charts

struct WeekView: View {
    @EnvironmentObject private var store: ProfileStore
    @Query(sort: \FoodEntry.date) private var food: [FoodEntry]
    @Query(sort: \ActivityEntry.date) private var activity: [ActivityEntry]

    private var report: WeekReport {
        WeekCalculator.report(for: .now, dailyTarget: store.profile.dailyTargetCalories, food: food, activity: activity)
    }

    private let weekdayFmt: DateFormatter = {
        let f = DateFormatter(); f.dateFormat = "EE"; return f
    }()

    var body: some View {
        NavigationStack {
            ScrollView {
                let r = report
                VStack(spacing: 16) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Неделя: \(r.weekStart, style: .date) — \(r.weekEnd, style: .date)")
                            .font(.headline)
                        Text("Дневная цель: \(r.dailyTarget) ккал · Недельный бюджет: \(r.weeklyBudget) ккал")
                            .font(.caption).foregroundStyle(.secondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)

                    Chart(r.perDay) { d in
                        BarMark(x: .value("День", weekdayFmt.string(from: d.date)),
                                y: .value("Ккал", max(0, d.net)))
                            .foregroundStyle(d.net > r.dailyTarget ? Color.red : Color.green)
                    }
                    .frame(height: 200)
                    .padding().background(.thinMaterial, in: RoundedRectangle(cornerRadius: 12))

                    VStack(alignment: .leading, spacing: 6) {
                        HStack { Text("Съедено (нетто) за неделю:"); Spacer(); Text("\(r.consumedPastAndToday) ккал").bold() }
                        HStack { Text("Остаток бюджета недели:"); Spacer(); Text("\(r.remainingForWeek) ккал").bold().foregroundStyle(r.isOverForWeek ? .red : .green) }
                    }
                    .padding().background(.thinMaterial, in: RoundedRectangle(cornerRadius: 12))

                    if r.futureDaysCount > 0 {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("⚖️ Балансировка недели").font(.headline)
                            if r.isOverForWeek {
                                Text("Ты уже вышел за недельный бюджет. Чтобы выровнять неделю, в оставшиеся \(r.futureDaysCount) дн. ешь примерно по \(r.suggestedFutureDailyTarget) ккал/день.")
                                    .foregroundStyle(.orange)
                            } else {
                                Text("В оставшиеся \(r.futureDaysCount) дн. можешь съедать до \(r.suggestedFutureDailyTarget) ккал/день, чтобы уложиться в бюджет.")
                                    .foregroundStyle(.green)
                            }
                        }
                        .padding().frame(maxWidth: .infinity, alignment: .leading)
                        .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 12))
                    }
                }
                .padding()
            }
            .navigationTitle("Неделя")
        }
    }
}

extension WeekReport {
    var futureDaysCount: Int {
        perDay.filter { $0.date > Calendar.current.startOfDay(for: .now) }.count
    }
}
