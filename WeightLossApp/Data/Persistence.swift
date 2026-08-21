import Foundation
import SwiftData

enum Persistence {
    static let configuration = ModelConfiguration(
        schema: Schema([
            Profile.self, Recipe.self, FoodEntry.self,
            WaterEntry.self, ActivityEntry.self, WeightEntry.self
        ]),
        isStoredInMemoryOnly: false,
        allowsSave: true
    )

    static func makeContainer() -> ModelContainer {
        do {
            return try ModelContainer(
                for: Profile.self, Recipe.self, FoodEntry.self,
                WaterEntry.self, ActivityEntry.self, WeightEntry.self,
                configurations: configuration
            )
        } catch {
            fatalError("Не удалось создать ModelContainer: \(error)")
        }
    }
}
