import Foundation

struct FoodItem {
    let label: String
    let caloriesPer100g: Int
    let typicalPortionG: Int
    let emoji: String
}

struct FoodDatabase {
    static let items: [FoodItem] = [
        FoodItem(label: "apple", caloriesPer100g: 52, typicalPortionG: 150, emoji: "🍎"),
        FoodItem(label: "banana", caloriesPer100g: 89, typicalPortionG: 120, emoji: "🍌"),
        FoodItem(label: "orange", caloriesPer100g: 47, typicalPortionG: 130, emoji: "🍊"),
        FoodItem(label: "salad", caloriesPer100g: 20, typicalPortionG: 150, emoji: "🥗"),
        FoodItem(label: "pizza", caloriesPer100g: 266, typicalPortionG: 200, emoji: "🍕"),
        FoodItem(label: "burger", caloriesPer100g: 295, typicalPortionG: 200, emoji: "🍔"),
        FoodItem(label: "sushi", caloriesPer100g: 150, typicalPortionG: 200, emoji: "🍣"),
        FoodItem(label: "pasta", caloriesPer100g: 160, typicalPortionG: 250, emoji: "🍝"),
        FoodItem(label: "rice", caloriesPer100g: 130, typicalPortionG: 200, emoji: "🍚"),
        FoodItem(label: "chicken", caloriesPer100g: 165, typicalPortionG: 150, emoji: "🍗"),
        FoodItem(label: "egg", caloriesPer100g: 155, typicalPortionG: 100, emoji: "🥚"),
        FoodItem(label: "bread", caloriesPer100g: 265, typicalPortionG: 50, emoji: "🍞"),
        FoodItem(label: "soup", caloriesPer100g: 60, typicalPortionG: 300, emoji: "🥣"),
        FoodItem(label: "yogurt", caloriesPer100g: 59, typicalPortionG: 150, emoji: "🥛"),
        FoodItem(label: "cake", caloriesPer100g: 350, typicalPortionG: 100, emoji: "🍰"),
        FoodItem(label: "fish", caloriesPer100g: 140, typicalPortionG: 150, emoji: "🐟"),
        FoodItem(label: "potato", caloriesPer100g: 77, typicalPortionG: 150, emoji: "🥔"),
        FoodItem(label: "carrot", caloriesPer100g: 41, typicalPortionG: 100, emoji: "🥕"),
        FoodItem(label: "tomato", caloriesPer100g: 18, typicalPortionG: 100, emoji: "🍅"),
        FoodItem(label: "cucumber", caloriesPer100g: 15, typicalPortionG: 100, emoji: "🥒"),
        FoodItem(label: "broccoli", caloriesPer100g: 34, typicalPortionG: 150, emoji: "🥦"),
        FoodItem(label: "mushroom", caloriesPer100g: 22, typicalPortionG: 100, emoji: "🍄"),
        FoodItem(label: "strawberry", caloriesPer100g: 32, typicalPortionG: 100, emoji: "🍓"),
        FoodItem(label: "lettuce", caloriesPer100g: 15, typicalPortionG: 100, emoji: "🥬"),
        FoodItem(label: "corn", caloriesPer100g: 86, typicalPortionG: 100, emoji: "🌽"),
        FoodItem(label: "hotdog", caloriesPer100g: 290, typicalPortionG: 100, emoji: "🌭"),
        FoodItem(label: "ice cream", caloriesPer100g: 207, typicalPortionG: 100, emoji: "🍦"),
        FoodItem(label: "cheese", caloriesPer100g: 402, typicalPortionG: 50, emoji: "🧀"),
        FoodItem(label: "cheeseburger", caloriesPer100g: 303, typicalPortionG: 200, emoji: "🍔"),
        FoodItem(label: "mashed potato", caloriesPer100g: 88, typicalPortionG: 200, emoji: "🥔"),
        FoodItem(label: "cauliflower", caloriesPer100g: 25, typicalPortionG: 150, emoji: "🥦"),
        FoodItem(label: "zucchini", caloriesPer100g: 17, typicalPortionG: 150, emoji: "🥒"),
        FoodItem(label: "bell pepper", caloriesPer100g: 31, typicalPortionG: 100, emoji: "🫑"),
        FoodItem(label: "artichoke", caloriesPer100g: 47, typicalPortionG: 120, emoji: "🥬"),
        FoodItem(label: "pineapple", caloriesPer100g: 50, typicalPortionG: 150, emoji: "🍍"),
        FoodItem(label: "pomegranate", caloriesPer100g: 83, typicalPortionG: 150, emoji: "🍎"),
        FoodItem(label: "fig", caloriesPer100g: 74, typicalPortionG: 100, emoji: "🍇"),
        FoodItem(label: "lemon", caloriesPer100g: 29, typicalPortionG: 50, emoji: "🍋"),
        FoodItem(label: "carbonara", caloriesPer100g: 175, typicalPortionG: 250, emoji: "🍝"),
        FoodItem(label: "meat loaf", caloriesPer100g: 240, typicalPortionG: 200, emoji: "🍖"),
        FoodItem(label: "potpie", caloriesPer100g: 250, typicalPortionG: 250, emoji: "🥧"),
        FoodItem(label: "burrito", caloriesPer100g: 206, typicalPortionG: 300, emoji: "🌯"),
        FoodItem(label: "guacamole", caloriesPer100g: 160, typicalPortionG: 100, emoji: "🥑"),
        FoodItem(label: "consomme", caloriesPer100g: 30, typicalPortionG: 250, emoji: "🍲"),
        FoodItem(label: "hot pot", caloriesPer100g: 150, typicalPortionG: 400, emoji: "🍲"),
        FoodItem(label: "trifle", caloriesPer100g: 230, typicalPortionG: 200, emoji: "🍰"),
        FoodItem(label: "french loaf", caloriesPer100g: 280, typicalPortionG: 100, emoji: "🥖"),
        FoodItem(label: "bagel", caloriesPer100g: 250, typicalPortionG: 100, emoji: "🥯"),
        FoodItem(label: "pretzel", caloriesPer100g: 380, typicalPortionG: 80, emoji: "🥨"),
        FoodItem(label: "chocolate sauce", caloriesPer100g: 320, typicalPortionG: 50, emoji: "🍫"),
        FoodItem(label: "eggnog", caloriesPer100g: 120, typicalPortionG: 200, emoji: "🥛"),
        FoodItem(label: "red wine", caloriesPer100g: 85, typicalPortionG: 150, emoji: "🍷"),
        FoodItem(label: "espresso", caloriesPer100g: 3, typicalPortionG: 50, emoji: "☕"),
        FoodItem(label: "head cabbage", caloriesPer100g: 25, typicalPortionG: 150, emoji: "🥬"),
        FoodItem(label: "acorn squash", caloriesPer100g: 40, typicalPortionG: 150, emoji: "🎃"),
        FoodItem(label: "butternut squash", caloriesPer100g: 45, typicalPortionG: 150, emoji: "🎃"),
        FoodItem(label: "spaghetti squash", caloriesPer100g: 31, typicalPortionG: 150, emoji: "🎃")
    ]

    static func match(for query: String) -> FoodItem? {
        let q = query.lowercased()
        return items.first { q.contains($0.label) || $0.label.contains(q) }
            ?? items.first { q.contains($0.emoji) }
    }

    static func estimateCalories(label: String) -> (calories: Int, emoji: String, name: String) {
        if let item = match(for: label) {
            let c = Int(Double(item.caloriesPer100g) * Double(item.typicalPortionG) / 100.0)
            return (c, item.emoji, label.capitalized)
        }
        return (0, "❓", label.capitalized)
    }
}
