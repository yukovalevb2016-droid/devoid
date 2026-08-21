import SwiftUI
import SwiftData
import Charts

struct WeightView: View {
    @Environment(\.modelContext) private var context
    @Query(sort: \WeightEntry.date) private var entries: [WeightEntry]

    @State private var weight = ""
    @State private var note = ""

    private var startWeight: Double? { entries.first?.weightKg }
    private var latest: Double? { entries.last?.weightKg }
    private var change: Double? {
        guard let s = startWeight, let l = latest else { return nil }
        return l - s
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    HStack {
                        StatCard(title: "Старт", value: startWeight.map { String(format: "%.1f", $0) } ?? "—", color: .gray)
                        StatCard(title: "Текущий", value: latest.map { String(format: "%.1f", $0) } ?? "—", color: .blue)
                        StatCard(title: "Изменение", value: change.map { String(format: "%+.1f", $0) } ?? "—",
                                 color: (change ?? 0) < 0 ? .green : .orange)
                    }

                    if !entries.isEmpty {
                        Chart(entries) { e in
                            LineMark(x: .value("Дата", e.date), y: .value("Вес", e.weightKg))
                                .symbol(Circle())
                            PointMark(x: .value("Дата", e.date), y: .value("Вес", e.weightKg))
                        }
                        .frame(height: 200)
                        .padding()
                        .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 12))
                    }

                    Group {
                        TextField("Вес, кг", text: $weight).keyboardType(.decimalPad).textFieldStyle(.roundedBorder)
                        TextField("Заметка (напр. ДО / ПОСЛЕ)", text: $note).textFieldStyle(.roundedBorder)
                        Button {
                            if let w = Double(weight.replacingOccurrences(of: ",", with: ".")) {
                                context.insert(WeightEntry(weightKg: w, note: note))
                                try? context.save()
                                weight = ""; note = ""
                            }
                        } label: {
                            Label("Записать вес", systemImage: "plus").frame(maxWidth: .infinity)
                        }.buttonStyle(.borderedProminent)
                        .disabled(Double(weight.replacingOccurrences(of: ",", with: ".")) == nil)
                    }

                    VStack(alignment: .leading) {
                        Text("История").font(.headline)
                        ForEach(entries.reversed()) { e in
                            HStack {
                                Text(e.date, style: .date)
                                Spacer()
                                Text(String(format: "%.1f кг", e.weightKg))
                                if !e.note.isEmpty { Text("· \(e.note)").foregroundStyle(.secondary) }
                                Button { context.delete(e); try? context.save() } label: { Image(systemName: "trash").foregroundStyle(.red) }
                            }
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Контроль веса")
        }
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let color: Color
    var body: some View {
        VStack {
            Text(value).font(.title3.bold()).foregroundStyle(color)
            Text(title).font(.caption).foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding().background(Color.gray.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}
