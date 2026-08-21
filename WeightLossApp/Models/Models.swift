import Foundation
import SwiftData

enum Sex: String, Codable, CaseIterable, Identifiable {
    case male = "Мужской"
    case female = "Женский"
    var id: String { rawValue }
}

enum ActivityLevel: String, Codable, CaseIterable, Identifiable {
    case sedentary = "Сидячий"
    case light = "Лёгкая (1-3 раза/нед)"
    case moderate = "Средняя (3-5 раз/нед)"
    case active = "Высокая (6-7 раз/нед)"
    case athlete = "Очень высокая (2 раза/день)"

    var coefficient: Double {
        switch self {
        case .sedentary: return 1.2
        case .light: return 1.375
        case .moderate: return 1.55
        case .active: return 1.725
        case .athlete: return 1.9
        }
    }
    var id: String { rawValue }
}

enum Goal: String, Codable, CaseIterable, Identifiable {
    case lose = "Похудение"
    case maintain = "Удержание"
    case gain = "Набор массы"
    var id: String { rawValue }
}

@Model
final class Profile {
    var heightCm: Double
    var weightKg: Double
    var targetWeightKg: Double
    var startWeightKg: Double
    var age: Int
    var sex: Sex
    var activity: ActivityLevel
    var goal: Goal

    init(heightCm: Double = 165, weightKg: Double = 70, targetWeightKg: Double = 65,
         startWeightKg: Double? = nil,
         age: Int = 30, sex: Sex = .female, activity: ActivityLevel = .light, goal: Goal = .lose) {
        self.heightCm = heightCm
        self.weightKg = weightKg
        self.targetWeightKg = targetWeightKg
        self.startWeightKg = startWeightKg ?? weightKg
        self.age = age
        self.sex = sex
        self.activity = activity
        self.goal = goal
    }

    var bmi: Double {
        guard heightCm > 0 else { return 0 }
        let m = heightCm / 100.0
        return weightKg / (m * m)
    }

    var bmiCategory: String {
        switch bmi {
        case ..<16: return "Выраженный дефицит"
        case 16..<18.5: return "Недостаток массы"
        case 18.5..<25: return "Норма"
        case 25..<30: return "Избыточная масса"
        case 30..<35: return "Ожирение I ст."
        case 35..<40: return "Ожирение II ст."
        default: return "Ожирение III ст."
        }
    }

    var bmr: Double {
        let s = (sex == .male) ? 5.0 : -161.0
        return 10.0 * weightKg + 6.25 * heightCm - 5.0 * Double(age) + s
    }

    var tdee: Double {
        bmr * activity.coefficient
    }

    var dailyTargetCalories: Int {
        let adjust: Double = {
            switch goal {
            case .lose: return -400
            case .maintain: return 0
            case .gain: return +300
            }
        }()
        return Int(max(1000, tdee + adjust))
    }

    /// Целевой вес рассчитывается автоматически из роста и цели,
    /// чтобы пользователю не нужно было задавать его вручную.
    var healthyTargetWeight: Double {
        let m = heightCm / 100.0
        let base = 22.0 * m * m
        switch goal {
        case .lose: return base
        case .maintain: return weightKg
        case .gain: return max(base, weightKg * 1.05)
        }
    }

    var weightDeltaNeeded: Double {
        healthyTargetWeight - weightKg
    }

    var goalProgress: Double {
        let start = startWeightKg
        let target = healthyTargetWeight
        let current = weightKg
        if abs(start - target) < 0.01 { return current <= target ? 1 : 0 }
        let done = (start - current) / (start - target)
        return min(1, max(0, done))
    }
}

@Model
final class Recipe {
    var name: String
    var category: String
    var calories: Int
    var protein: Int
    var fat: Int
    var carbs: Int
    var ingredients: String
    var steps: String
    var emoji: String

    init(name: String, category: String, calories: Int, protein: Int, fat: Int,
         carbs: Int, ingredients: String, steps: String, emoji: String = "🍽️") {
        self.name = name
        self.category = category
        self.calories = calories
        self.protein = protein
        self.fat = fat
        self.carbs = carbs
        self.ingredients = ingredients
        self.steps = steps
        self.emoji = emoji
    }
}

enum MealType: String, Codable, CaseIterable, Identifiable {
    case breakfast = "Завтрак"
    case lunch = "Обед"
    case dinner = "Ужин"
    case snack = "Перекус"
    var id: String { rawValue }
}

@Model
final class FoodEntry {
    var date: Date
    var name: String
    var calories: Int
    var meal: MealType
    var source: String
    @Attribute(.externalStorage) var photo: Data?

    init(date: Date = .now, name: String, calories: Int, meal: MealType, source: String, photo: Data? = nil) {
        self.date = date
        self.name = name
        self.calories = calories
        self.meal = meal
        self.source = source
        self.photo = photo
    }
}

@Model
final class WaterEntry {
    var date: Date
    var amountMl: Int
    init(date: Date = .now, amountMl: Int) {
        self.date = date
        self.amountMl = amountMl
    }
}

@Model
final class ActivityEntry {
    var date: Date
    var name: String
    var caloriesBurned: Int
    var durationMin: Int
    init(date: Date = .now, name: String, caloriesBurned: Int, durationMin: Int) {
        self.date = date
        self.name = name
        self.caloriesBurned = caloriesBurned
        self.durationMin = durationMin
    }
}

@Model
final class WeightEntry {
    var date: Date
    var weightKg: Double
    var note: String
    init(date: Date = .now, weightKg: Double, note: String = "") {
        self.date = date
        self.weightKg = weightKg
        self.note = note
    }
}
