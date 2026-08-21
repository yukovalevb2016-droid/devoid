import Foundation
import SwiftData

struct RecipesData {
    static let seed: [Recipe] = [
        Recipe(name: "Овсянка с ягодами", category: "Завтрак",
               calories: 280, protein: 10, fat: 6, carbs: 45,
               ingredients: "Овсянка 50г, ягоды 100г, вода/молоко 150мл, мёд 1 ч.л.",
               steps: "1. Залей овсянку горячей водой/молоком.\n2. Добавь ягоды и мёд.\n3. Настаивай 3 минуты.", emoji: "🥣"),

        Recipe(name: "Салат с курицей и авокадо", category: "Обед",
               calories: 350, protein: 35, fat: 18, carbs: 12,
               ingredients: "Грудка 150г, авокадо 1/2, салат 50г, оливковое масло 1 ст.л., лимон.",
               steps: "1. Отвари или запеки грудку.\n2. Нарежь овощи и авокадо.\n3. Заправь маслом и лимоном.", emoji: "🥗"),

        Recipe(name: "Запечённая рыба с овощами", category: "Ужин",
               calories: 320, protein: 30, fat: 14, carbs: 18,
               ingredients: "Филе белой рыбы 150г, брокколи 100г, морковь 80г, специи.",
               steps: "1. Выложи рыбу и овощи на противень.\n2. Посыпь специями.\n3. Запекай 20 мин при 180°C.", emoji: "🐟"),

        Recipe(name: "Греческий йогурт с орехами", category: "Перекус",
               calories: 200, protein: 14, fat: 10, carbs: 12,
               ingredients: "Йогурт 150г, грецкие орехи 15г, ягоды 50г.",
               steps: "1. Выложи йогурт в миску.\n2. Добавь орехи и ягоды.", emoji: "🥛"),

        Recipe(name: "Омлет с овощами", category: "Завтрак",
               calories: 240, protein: 18, fat: 16, carbs: 6,
               ingredients: "Яйца 2 шт, помидор 50г, шпинат 30г, масло 1 ч.л.",
               steps: "1. Взбей яйца.\n2. Обжарь овощи.\n3. Залей яйцами и готовь до готовности.", emoji: "🥚"),

        Recipe(name: "Тёплый салат с тофу", category: "Обед",
               calories: 300, protein: 20, fat: 16, carbs: 15,
               ingredients: "Тофу 120г, брокколи 100г, перец 50г, соевый соус 1 ст.л.",
               steps: "1. Обжарь тофу до корочки.\n2. Добавь овощи.\n3. Сбрызни соевым соусом.", emoji: "🥦"),

        Recipe(name: "Крем-суп из тыквы", category: "Ужин",
               calories: 210, protein: 6, fat: 8, carbs: 28,
               ingredients: "Тыква 200г, лук 1 шт, бульон 200мл, сливки 1 ст.л.",
               steps: "1. Туши лук и тыкву.\n2. Залей бульоном, вари 15 мин.\n3. Взбей блендером, добавь сливки.", emoji: "🥣"),

        Recipe(name: "Фруктовая тарелка", category: "Перекус",
               calories: 150, protein: 2, fat: 1, carbs: 35,
               ingredients: "Яблоко, банан, апельсин по 1 шт.",
               steps: "1. Нарежь фрукты.\n2. Подавай свежими.", emoji: "🍓")
    ]

    static func seedIfNeeded(context: ModelContext) {
        let descriptor = FetchDescriptor<Recipe>()
        guard (try? context.fetch(descriptor))?.isEmpty ?? true else { return }
        for r in seed { context.insert(r) }
        try? context.save()
    }
}
