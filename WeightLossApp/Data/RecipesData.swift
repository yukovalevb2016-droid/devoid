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
                steps: "1. Нарежь фрукты.\n2. Подавай свежими.", emoji: "🍓"),

        Recipe(name: "Гречка с индейкой", category: "Обед",
                calories: 380, protein: 32, fat: 10, carbs: 42,
                ingredients: "Гречка 60г, филе индейки 150г, лук 1 шт, масло 1 ч.л.",
                steps: "1. Отвари гречку.\n2. Обжарь индейку с луком.\n3. Подавай вместе.", emoji: "🍛"),

        Recipe(name: "Творожная запеканка", category: "Завтрак",
                calories: 250, protein: 20, fat: 8, carbs: 24,
                ingredients: "Творог 200г, яйцо 1 шт, манка 1 ст.л., изюм, подсластитель.",
                steps: "1. Смешай творог, яйцо, манку, изюм.\n2. Выложи в форму.\n3. Запекай 30 мин при 180°C.", emoji: "🍮"),

        Recipe(name: "Овощной суп", category: "Обед",
                calories: 160, protein: 6, fat: 5, carbs: 20,
                ingredients: "Капуста 100г, морковь 1 шт, картофель 1 шт, лук, бульон 300мл.",
                steps: "1. Нарежь овощи.\n2. Вари в бульоне 20 мин.\n3. Посоли по вкусу.", emoji: "🍲"),

        Recipe(name: "Стейк из лосося", category: "Ужин",
                calories: 400, protein: 38, fat: 26, carbs: 0,
                ingredients: "Филе лосося 180г, лимон, розмарин, масло 1 ч.л.",
                steps: "1. Посыпь рыбу специями.\n2. Обжарь 3-4 мин с каждой стороны.\n3. Сбрызни лимоном.", emoji: "🐟"),

        Recipe(name: "Киноа с овощами", category: "Гарнир",
                calories: 300, protein: 12, fat: 10, carbs: 40,
                ingredients: "Киноа 60г, перец 50г, кабачок 80г, масло 1 ст.л.",
                steps: "1. Отвари киноа.\n2. Обжарь овощи.\n3. Смешай.", emoji: "🥗"),

        Recipe(name: "Салат Цезарь с курицей", category: "Обед",
                calories: 380, protein: 34, fat: 22, carbs: 10,
                ingredients: "Грудка 150г, салат романо, пармезан, сухарики, соус цезарь.",
                steps: "1. Запеки грудку.\n2. Нарежь салат и курицу.\n3. Заправь соусом, посыпь сыром.", emoji: "🥗"),

        Recipe(name: "Тост с авокадо и яйцом", category: "Завтрак",
                calories: 290, protein: 14, fat: 16, carbs: 24,
                ingredients: "Хлеб 2 ломтика, авокадо 1/2, яйцо 1 шт, лимон.",
                steps: "1. Поджарь хлеб.\n2. Разомни авокадо на тосте.\n3. Сверху яйцо (варёное/жареное).", emoji: "🥑"),

        Recipe(name: "Гуляш с подливой", category: "Ужин",
                calories: 420, protein: 30, fat: 22, carbs: 18,
                ingredients: "Говядина 180г, лук 1 шт, томатная паста, мука 1 ч.л., специи.",
                steps: "1. Обжарь мясо с луком.\n2. Добавь пасту и муку, туши 40 мин.\n3. Подавай с гарниром.", emoji: "🍲"),

        Recipe(name: "Смузи с бананом и шпинатом", category: "Перекус",
                calories: 180, protein: 5, fat: 3, carbs: 34,
                ingredients: "Банан 1 шт, шпинат 30г, молоко 150мл, лёд.",
                steps: "1. Положи всё в блендер.\n2. Взбей до однородности.", emoji: "🥤"),

        Recipe(name: "Паста с томатами и чесноком", category: "Ужин",
                calories: 430, protein: 14, fat: 12, carbs: 68,
                ingredients: "Паста 80г, помидоры 150г, чеснок 2 зуб., масло 1 ст.л., базилик.",
                steps: "1. Отвари пасту.\n2. Обжарь томаты с чесноком.\n3. Смешай с пастой, добавь базилик.", emoji: "🍝"),

        Recipe(name: "Запечённые овощи с хумусом", category: "Перекус",
                calories: 220, protein: 7, fat: 11, carbs: 24,
                ingredients: "Баклажан, цукини, перец по 100г, хумус 2 ст.л., масло.",
                steps: "1. Нарежь овощи.\n2. Запеки 20 мин при 200°C.\n3. Подавай с хумусом.", emoji: "🥦"),

        Recipe(name: "Рис с креветками", category: "Обед",
                calories: 360, protein: 26, fat: 8, carbs: 46,
                ingredients: "Рис 60г, креветки 150г, чеснок, лимон, масло 1 ч.л.",
                steps: "1. Отвари рис.\n2. Обжарь креветки с чесноком.\n3. Смешай с рисом, сбрызни лимоном.", emoji: "🍤"),

        Recipe(name: "Сырники", category: "Завтрак",
                calories: 300, protein: 16, fat: 12, carbs: 30,
                ingredients: "Творог 200г, яйцо 1 шт, мука 2 ст.л., сахар по вкусу.",
                steps: "1. Смешай творог, яйцо, муку.\n2. Сформируй лепёшки.\n3. Обжарь до золотистости.", emoji: "🧀"),

        Recipe(name: "Шакшука", category: "Завтрак",
                calories: 260, protein: 16, fat: 16, carbs: 12,
                ingredients: "Яйца 2 шт, помидоры 150г, перец 50г, лук, специи.",
                steps: "1. Потуши лук, перец и помидоры.\n2. Вбей яйца.\n3. Туши до готовности желтков.", emoji: "🍳")
    ]

    static func seedIfNeeded(context: ModelContext) {
        let descriptor = FetchDescriptor<Recipe>()
        let existing = (try? context.fetch(descriptor)) ?? []
        let existingNames = Set(existing.map { $0.name })
        for r in seed where !existingNames.contains(r.name) {
            context.insert(r)
        }
        try? context.save()
    }
}
