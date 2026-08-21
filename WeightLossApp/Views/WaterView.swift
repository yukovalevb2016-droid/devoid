import SwiftUI
import SwiftData

struct WaterView: View {
    @Environment(\.modelContext) private var context
    @EnvironmentObject private var store: ProfileStore
    @Query(sort: \WaterEntry.date, order: .reverse) private var all: [WaterEntry]

    @State private var customMl = ""

    private var dailyGoal: Int {
        max(1000, Int(store.profile.weightKg * 30))
    }
    private var todays: [WaterEntry] {
        all.filter { Calendar.current.isDateInToday($0.date) }
    }
    private var totalToday: Int {
        todays.reduce(0) { $0 + $1.amountMl }
    }
    private var progress: Double {
        min(1, Double(totalToday) / Double(dailyGoal))
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    ZStack {
                        Circle().stroke(Color.blue.opacity(0.2), lineWidth: 18)
                        Circle().trim(from: 0, to: progress)
                            .stroke(Color.blue, lineWidth: 18)
                            .rotationEffect(.degrees(-90))
                            .animation(.easeInOut, value: progress)
                        VStack {
                            Text("\(totalToday)").font(.largeTitle.bold())
                            Text("из \(dailyGoal) мл").foregroundStyle(.secondary)
                        }
                    }
                    .frame(width: 220, height: 220)

                    HStack(spacing: 12) {
                        ForEach([200, 250, 500], id: \.self) { ml in
                            Button { add(ml) } label: {
                                Text("+\(ml) мл").frame(maxWidth: .infinity)
                            }.buttonStyle(.borderedProminent)
                        }
                    }

                    HStack {
                        TextField("Свой объём (мл)", text: $customMl).keyboardType(.numberPad).textFieldStyle(.roundedBorder)
                        Button("Добавить") {
                            if let v = Int(customMl) { add(v); customMl = "" }
                        }.buttonStyle(.bordered)
                    }

                    VStack(alignment: .leading) {
                        Text("Сегодня").font(.headline)
                        if todays.isEmpty { Text("Пока не пили").foregroundStyle(.secondary) }
                        ForEach(todays) { w in
                            HStack {
                                Text("\(w.amountMl) мл")
                                Spacer()
                                Text(w.date, style: .time)
                                Button { context.delete(w); try? context.save() } label: { Image(systemName: "trash").foregroundStyle(.red) }
                            }
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Вода")
        }
    }

    private func add(_ ml: Int) {
        context.insert(WaterEntry(amountMl: ml))
        try? context.save()
    }
}
