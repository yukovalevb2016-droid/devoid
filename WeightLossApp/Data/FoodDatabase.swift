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
        FoodItem(label: "cucumber", caloriesPer100g: 15, typicalPortionG: 100, emoji: "🥒")
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
