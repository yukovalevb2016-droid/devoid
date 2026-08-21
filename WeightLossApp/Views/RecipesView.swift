import SwiftUI
import SwiftData

struct RecipesView: View {
    @Query(sort: \Recipe.name) private var recipes: [Recipe]
    @State private var search = ""
    @State private var selectedCategory = "Все"

    private var categories: [String] {
        ["Все"] + Array(Set(recipes.map { $0.category })).sorted()
    }

    private var filtered: [Recipe] {
        recipes.filter {
            (selectedCategory == "Все" || $0.category == selectedCategory) &&
            (search.isEmpty || $0.name.localizedCaseInsensitiveContains(search))
        }
    }

    var body: some View {
        NavigationStack {
            List {
                ForEach(filtered) { r in
                    NavigationLink {
                        RecipeDetailView(recipe: r)
                    } label: {
                        HStack {
                            Text(r.emoji).font(.largeTitle)
                            VStack(alignment: .leading) {
                                Text(r.name).font(.headline)
                                Text(r.category).font(.caption).foregroundStyle(.secondary)
                            }
                            Spacer()
                            Text("\(r.calories) ккал").bold().foregroundStyle(.green)
                        }
                    }
                }
            }
            .searchable(text: $search, prompt: "Поиск рецепта")
            .navigationTitle("Рецепты")
            .toolbar {
                Menu {
                    Picker("Категория", selection: $selectedCategory) {
                        ForEach(categories, id: \.self) { Text($0) }
                    }
                } label: {
                    Label("Фильтр", systemImage: "line.3.horizontal.decrease.circle")
                }
            }
        }
    }
}

struct RecipeDetailView: View {
    let recipe: Recipe
    @Environment(\.modelContext) private var context

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Text(recipe.emoji).font(.system(size: 60))
                    VStack(alignment: .leading) {
                        Text(recipe.name).font(.title2.bold())
                        Text(recipe.category).foregroundStyle(.secondary)
                    }
                }

                HStack {
                    NutrientBadge(label: "Ккал", value: "\(recipe.calories)", color: .green)
                    NutrientBadge(label: "Белки", value: "\(recipe.protein) г", color: .blue)
                    NutrientBadge(label: "Жиры", value: "\(recipe.fat) г", color: .orange)
                    NutrientBadge(label: "Углев.", value: "\(recipe.carbs) г", color: .purple)
                }

                Group {
                    Text("Ингредиенты").font(.headline)
                    Text(recipe.ingredients)
                    Text("Приготовление").font(.headline)
                    Text(recipe.steps)
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                Button {
                    let entry = FoodEntry(name: recipe.name, calories: recipe.calories, meal: .lunch, source: "Рецепт")
                    context.insert(entry)
                    try? context.save()
                } label: {
                    Label("Добавить в дневник еды", systemImage: "plus.circle.fill")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .padding(.top)
            }
            .padding()
        }
        .navigationTitle("Рецепт")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct NutrientBadge: View {
    let label: String
    let value: String
    let color: Color
    var body: some View {
        VStack {
            Text(value).bold()
            Text(label).font(.caption).foregroundStyle(.secondary)
        }
        .padding(8)
        .frame(maxWidth: .infinity)
        .background(color.opacity(0.15))
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}
