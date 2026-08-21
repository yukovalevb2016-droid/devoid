import SwiftUI
import SwiftData

struct ActivityView: View {
    @Environment(\.modelContext) private var context
    @Query(sort: \ActivityEntry.date, order: .reverse) private var all: [ActivityEntry]

    @State private var name = ""
    @State private var calories = ""
    @State private var duration = ""

    private var todays: [ActivityEntry] {
        all.filter { Calendar.current.isDateInToday($0.date) }
    }
    private var burnedToday: Int {
        todays.reduce(0) { $0 + $1.caloriesBurned }
    }

    private let presets: [(String, Int, Int)] = [
        ("Ходьба", 150, 30),
        ("Бег", 300, 30),
        ("Йога", 120, 40),
        ("Зал", 250, 50),
        ("Велосипед", 220, 35),
        ("Плавание", 280, 30)
    ]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    VStack {
                        Text("Сожжено сегодня: \(burnedToday) ккал").font(.headline)
                        Text("Активность увеличивает дневной запас калорий").font(.caption).foregroundStyle(.secondary)
                    }
                    .padding().frame(maxWidth: .infinity).background(.thinMaterial).clipShape(RoundedRectangle(cornerRadius: 12))

                    Text("Быстрые активности").font(.headline)
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 150))]) {
                        ForEach(presets, id: \.0) { p in
                            Button {
                                context.insert(ActivityEntry(name: p.0, caloriesBurned: p.1, durationMin: p.2))
                                try? context.save()
                            } label: {
                                VStack(alignment: .leading) {
                                    Text(p.0).bold()
                                    Text("\(p.1) ккал · \(p.2) мин").font(.caption).foregroundStyle(.secondary)
                                }.frame(maxWidth: .infinity, alignment: .leading)
                                    .padding().background(Color.orange.opacity(0.12))
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                            }
                        }
                    }

                    Group {
                        TextField("Название", text: $name)
                        HStack {
                            TextField("Ккал сожжено", text: $calories).keyboardType(.numberPad)
                            TextField("Минуты", text: $duration).keyboardType(.numberPad)
                        }
                    }.textFieldStyle(.roundedBorder)

                    Button {
                        guard let cal = Int(calories), let dur = Int(duration), !name.isEmpty else { return }
                        context.insert(ActivityEntry(name: name, caloriesBurned: cal, durationMin: dur))
                        try? context.save()
                        name = ""; calories = ""; duration = ""
                    } label: {
                        Label("Добавить активность", systemImage: "plus").frame(maxWidth: .infinity)
                    }.buttonStyle(.borderedProminent)
                    .disabled(name.isEmpty || Int(calories) == nil)

                    VStack(alignment: .leading) {
                        Text("Сегодня").font(.headline)
                        if todays.isEmpty { Text("Нет активностей").foregroundStyle(.secondary) }
                        ForEach(todays) { a in
                            HStack {
                                Text(a.name)
                                Spacer()
                                Text("\(a.caloriesBurned) ккал · \(a.durationMin) мин")
                                Button { context.delete(a); try? context.save() } label: { Image(systemName: "trash").foregroundStyle(.red) }
                            }
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Активность")
        }
    }
}
