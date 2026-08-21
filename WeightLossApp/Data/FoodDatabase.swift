import Foundation

struct FoodItem {
    let label: String
    let name: String
    let caloriesPer100g: Int
    let typicalPortionG: Int
    let emoji: String
}

struct FoodDatabase {
    static let items: [FoodItem] = [
        FoodItem(label: "apple", name: "Яблоко", caloriesPer100g: 52, typicalPortionG: 150, emoji: "🍎"),
        FoodItem(label: "banana", name: "Банан", caloriesPer100g: 89, typicalPortionG: 120, emoji: "🍌"),
        FoodItem(label: "orange", name: "Апельсин", caloriesPer100g: 47, typicalPortionG: 130, emoji: "🍊"),
        FoodItem(label: "lemon", name: "Лимон", caloriesPer100g: 29, typicalPortionG: 50, emoji: "🍋"),
        FoodItem(label: "strawberry", name: "Клубника", caloriesPer100g: 32, typicalPortionG: 100, emoji: "🍓"),
        FoodItem(label: "pineapple", name: "Ананас", caloriesPer100g: 50, typicalPortionG: 150, emoji: "🍍"),
        FoodItem(label: "pomegranate", name: "Гранат", caloriesPer100g: 83, typicalPortionG: 150, emoji: "🍎"),
        FoodItem(label: "fig", name: "Инжир", caloriesPer100g: 74, typicalPortionG: 100, emoji: "🍇"),
        FoodItem(label: "salad", name: "Салат", caloriesPer100g: 20, typicalPortionG: 150, emoji: "🥗"),
        FoodItem(label: "lettuce", name: "Листовой салат", caloriesPer100g: 15, typicalPortionG: 100, emoji: "🥬"),
        FoodItem(label: "tomato", name: "Помидор", caloriesPer100g: 18, typicalPortionG: 100, emoji: "🍅"),
        FoodItem(label: "cucumber", name: "Огурец", caloriesPer100g: 15, typicalPortionG: 100, emoji: "🥒"),
        FoodItem(label: "carrot", name: "Морковь", caloriesPer100g: 41, typicalPortionG: 100, emoji: "🥕"),
        FoodItem(label: "broccoli", name: "Брокколи", caloriesPer100g: 34, typicalPortionG: 150, emoji: "🥦"),
        FoodItem(label: "cauliflower", name: "Цветная капуста", caloriesPer100g: 25, typicalPortionG: 150, emoji: "🥦"),
        FoodItem(label: "zucchini", name: "Цуккини", caloriesPer100g: 17, typicalPortionG: 150, emoji: "🥒"),
        FoodItem(label: "bell pepper", name: "Болгарский перец", caloriesPer100g: 31, typicalPortionG: 100, emoji: "🫑"),
        FoodItem(label: "artichoke", name: "Артишок", caloriesPer100g: 47, typicalPortionG: 120, emoji: "🥬"),
        FoodItem(label: "corn", name: "Кукуруза", caloriesPer100g: 86, typicalPortionG: 100, emoji: "🌽"),
        FoodItem(label: "potato", name: "Картофель", caloriesPer100g: 77, typicalPortionG: 150, emoji: "🥔"),
        FoodItem(label: "mashed potato", name: "Картофельное пюре", caloriesPer100g: 88, typicalPortionG: 200, emoji: "🥔"),
        FoodItem(label: "head cabbage", name: "Капуста", caloriesPer100g: 25, typicalPortionG: 150, emoji: "🥬"),
        FoodItem(label: "acorn squash", name: "Тыква", caloriesPer100g: 40, typicalPortionG: 150, emoji: "🎃"),
        FoodItem(label: "butternut squash", name: "Тыква", caloriesPer100g: 45, typicalPortionG: 150, emoji: "🎃"),
        FoodItem(label: "spaghetti squash", name: "Тыква", caloriesPer100g: 31, typicalPortionG: 150, emoji: "🎃"),
        FoodItem(label: "mushroom", name: "Грибы", caloriesPer100g: 22, typicalPortionG: 100, emoji: "🍄"),
        FoodItem(label: "cheese", name: "Сыр", caloriesPer100g: 402, typicalPortionG: 50, emoji: "🧀"),
        FoodItem(label: "egg", name: "Яйцо", caloriesPer100g: 155, typicalPortionG: 100, emoji: "🥚"),
        FoodItem(label: "chicken", name: "Курица", caloriesPer100g: 165, typicalPortionG: 150, emoji: "🍗"),
        FoodItem(label: "fish", name: "Рыба", caloriesPer100g: 140, typicalPortionG: 150, emoji: "🐟"),
        FoodItem(label: "meat loaf", name: "Мясной рулет", caloriesPer100g: 240, typicalPortionG: 200, emoji: "🍖"),
        FoodItem(label: "hotdog", name: "Сосиски", caloriesPer100g: 290, typicalPortionG: 100, emoji: "🌭"),
        FoodItem(label: "burger", name: "Бургер", caloriesPer100g: 295, typicalPortionG: 200, emoji: "🍔"),
        FoodItem(label: "cheeseburger", name: "Чизбургер", caloriesPer100g: 303, typicalPortionG: 200, emoji: "🍔"),
        FoodItem(label: "pizza", name: "Пицца", caloriesPer100g: 266, typicalPortionG: 200, emoji: "🍕"),
        FoodItem(label: "pasta", name: "Паста", caloriesPer100g: 160, typicalPortionG: 250, emoji: "🍝"),
        FoodItem(label: "carbonara", name: "Карбонара", caloriesPer100g: 175, typicalPortionG: 250, emoji: "🍝"),
        FoodItem(label: "spaghetti", name: "Спагетти", caloriesPer100g: 160, typicalPortionG: 250, emoji: "🍝"),
        FoodItem(label: "rice", name: "Рис", caloriesPer100g: 130, typicalPortionG: 200, emoji: "🍚"),
        FoodItem(label: "sushi", name: "Суши", caloriesPer100g: 150, typicalPortionG: 200, emoji: "🍣"),
        FoodItem(label: "burrito", name: "Буррито", caloriesPer100g: 206, typicalPortionG: 300, emoji: "🌯"),
        FoodItem(label: "bread", name: "Хлеб", caloriesPer100g: 265, typicalPortionG: 50, emoji: "🍞"),
        FoodItem(label: "french loaf", name: "Багет", caloriesPer100g: 280, typicalPortionG: 100, emoji: "🥖"),
        FoodItem(label: "bagel", name: "Бейгл", caloriesPer100g: 250, typicalPortionG: 100, emoji: "🥯"),
        FoodItem(label: "pretzel", name: "Крендель", caloriesPer100g: 380, typicalPortionG: 80, emoji: "🥨"),
        FoodItem(label: "soup", name: "Суп", caloriesPer100g: 60, typicalPortionG: 300, emoji: "🍲"),
        FoodItem(label: "consomme", name: "Бульон", caloriesPer100g: 30, typicalPortionG: 250, emoji: "🍲"),
        FoodItem(label: "hot pot", name: "Азиатское рагу", caloriesPer100g: 150, typicalPortionG: 400, emoji: "🍲"),
        FoodItem(label: "guacamole", name: "Гуакамоле", caloriesPer100g: 160, typicalPortionG: 100, emoji: "🥑"),
        FoodItem(label: "potpie", name: "Мясной пирог", caloriesPer100g: 250, typicalPortionG: 250, emoji: "🥧"),
        FoodItem(label: "trifle", name: "Десерт", caloriesPer100g: 230, typicalPortionG: 200, emoji: "🍰"),
        FoodItem(label: "cake", name: "Торт", caloriesPer100g: 350, typicalPortionG: 100, emoji: "🍰"),
        FoodItem(label: "ice cream", name: "Мороженое", caloriesPer100g: 207, typicalPortionG: 100, emoji: "🍦"),
        FoodItem(label: "yogurt", name: "Йогурт", caloriesPer100g: 59, typicalPortionG: 150, emoji: "🥛"),
        FoodItem(label: "eggnog", name: "Яичный коктейль", caloriesPer100g: 120, typicalPortionG: 200, emoji: "🥛"),
        FoodItem(label: "chocolate sauce", name: "Шоколадный соус", caloriesPer100g: 320, typicalPortionG: 50, emoji: "🍫"),
        FoodItem(label: "red wine", name: "Красное вино", caloriesPer100g: 85, typicalPortionG: 150, emoji: "🍷"),
        FoodItem(label: "espresso", name: "Эспрессо", caloriesPer100g: 3, typicalPortionG: 50, emoji: "☕")
    ]

    static func match(for query: String) -> FoodItem? {
        let q = query.lowercased()
        return items.first { q.contains($0.label) || $0.label.contains(q) || q.contains($0.name.lowercased()) }
            ?? items.first { q.contains($0.emoji) }
    }

    static func info(for label: String) -> (name: String, calories: Int, emoji: String) {
        if let item = match(for: label) {
            let c = Int(Double(item.caloriesPer100g) * Double(item.typicalPortionG) / 100.0)
            return (item.name, c, item.emoji)
        }
        return (label.capitalized, 0, "🍽")
    }
}
