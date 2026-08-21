import Foundation

struct DayStat: Identifiable {
    let date: Date
    let foodCalories: Int
    let activityBurned: Int
    var id: Date { date }
    var net: Int { foodCalories - activityBurned }
}

struct WeekReport {
    let weekStart: Date
    let weekEnd: Date
    let dailyTarget: Int
    let weeklyBudget: Int
    let perDay: [DayStat]
    let consumedPastAndToday: Int
    let remainingForWeek: Int
    let suggestedFutureDailyTarget: Int
    let isOverForWeek: Bool
}

enum WeekCalculator {
    static func startOfWeek(_ date: Date) -> Date {
        let cal = Calendar.current
        let weekday = cal.component(.weekday, from: date) // 1=Sun..7=Sat
        let daysFromMonday = (weekday + 5) % 7
        return cal.startOfDay(for: cal.date(byAdding: .day, value: -daysFromMonday, to: date)!)
    }

    static func report(for date: Date, dailyTarget: Int,
                       food: [FoodEntry], activity: [ActivityEntry]) -> WeekReport {
        let cal = Calendar.current
        let start = startOfWeek(date)
        let end = cal.date(byAdding: .day, value: 6, to: start)!
        let weeklyBudget = dailyTarget * 7

        var perDay: [DayStat] = []
        var consumedPastAndToday = 0
        var futureDays = 0

        for i in 0..<7 {
            let day = cal.date(byAdding: .day, value: i, to: start)!
            let foodCal = food.filter { cal.isDate($0.date, inSameDayAs: day) }
                              .reduce(0) { $0 + $1.calories }
            let actBurn = activity.filter { cal.isDate($0.date, inSameDayAs: day) }
                                  .reduce(0) { $0 + $1.caloriesBurned }
            let stat = DayStat(date: day, foodCalories: foodCal, activityBurned: actBurn)
            perDay.append(stat)

            if day < cal.startOfDay(for: date) {
                consumedPastAndToday += stat.net
            } else if cal.isDate(day, inSameDayAs: date) {
                consumedPastAndToday += stat.net
            } else {
                futureDays += 1
            }
        }

        let remainingForWeek = weeklyBudget - consumedPastAndToday
        let suggested = futureDays > 0 ? max(0, remainingForWeek / futureDays) : 0

        return WeekReport(
            weekStart: start, weekEnd: end,
            dailyTarget: dailyTarget, weeklyBudget: weeklyBudget,
            perDay: perDay,
            consumedPastAndToday: consumedPastAndToday,
            remainingForWeek: remainingForWeek,
            suggestedFutureDailyTarget: suggested,
            isOverForWeek: remainingForWeek < 0
        )
    }
}
