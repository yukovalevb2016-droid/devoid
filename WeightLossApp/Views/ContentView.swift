import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            ProfileView()
                .tabItem { Label("Профиль", systemImage: "person.fill") }

            RecipesView()
                .tabItem { Label("Рецепты", systemImage: "book.fill") }

            FoodLogView()
                .tabItem { Label("Еда", systemImage: "camera.fill") }

            WaterView()
                .tabItem { Label("Вода", systemImage: "drop.fill") }

            ActivityView()
                .tabItem { Label("Активность", systemImage: "figure.run") }

            WeightView()
                .tabItem { Label("Вес", systemImage: "scalemass.fill") }

            WeekView()
                .tabItem { Label("Неделя", systemImage: "calendar") }

            RemindersView()
                .tabItem { Label("Напоминания", systemImage: "bell.fill") }
        }
        .tint(.green)
    }
}
