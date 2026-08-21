import SwiftUI
import UIKit
import SwiftData

struct ImagePicker: UIViewControllerRepresentable {
    var sourceType: UIImagePickerController.SourceType
    @Binding var imageData: Data?
    @Environment(\.dismiss) private var dismiss

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = sourceType
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    func makeCoordinator() -> Coordinator { Coordinator(self) }

    final class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: ImagePicker
        init(_ parent: ImagePicker) { self.parent = parent }
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let image = info[.originalImage] as? UIImage,
               let data = image.jpegData(compressionQuality: 0.8) {
                parent.imageData = data
            }
            parent.dismiss()
        }
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) { parent.dismiss() }
    }
}

struct FoodLogView: View {
    @Environment(\.modelContext) private var context
    @EnvironmentObject private var store: ProfileStore
    @Query(sort: \FoodEntry.date, order: .reverse) private var allEntries: [FoodEntry]

    @State private var showPicker = false
    @State private var pickerSource: UIImagePickerController.SourceType = .photoLibrary
    @State private var imageData: Data?
    @State private var suggestions: [(label: String, confidence: Double)] = []
    @State private var selectedLabel = ""
    @State private var name = ""
    @State private var calories = ""
    @State private var meal: MealType = .lunch
    @State private var analyzing = false
    @State private var showManualHint = false

    private var todays: [FoodEntry] {
        allEntries.filter { Calendar.current.isDateInToday($0.date) }
    }
    private var totalToday: Int {
        todays.reduce(0) { $0 + $1.calories }
    }
    private var remaining: Int {
        max(0, store.profile.dailyTargetCalories - totalToday)
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    summaryCard

                    if let data = imageData, let ui = UIImage(data: data) {
                        Image(uiImage: ui)
                            .resizable().scaledToFit().frame(maxHeight: 220)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    }

                    HStack {
                        Button { pickerSource = .camera; showPicker = true } label: {
                            Label("Камера", systemImage: "camera").frame(maxWidth: .infinity)
                        }.buttonStyle(.bordered)
                        Button { pickerSource = .photoLibrary; showPicker = true } label: {
                            Label("Галерея", systemImage: "photo").frame(maxWidth: .infinity)
                        }.buttonStyle(.bordered)
                    }

                    if analyzing { ProgressView("Анализирую фото…") }

                    if !suggestions.isEmpty {
                        VStack(alignment: .leading) {
                            Text("Распознано (выбери):").font(.headline)
                            ForEach(suggestions, id: \.label) { s in
                                Button {
                                    selectedLabel = s.label
                                    let est = FoodDatabase.estimateCalories(label: s.label)
                                    name = est.name
                                    calories = "\(est.calories)"
                                } label: {
                                    HStack {
                                        Text("\(FoodDatabase.estimateCalories(label: s.label).emoji) \(s.label.capitalized)")
                                        Spacer()
                                        Text("\(Int(s.confidence * 100))%")
                                        if selectedLabel == s.label { Image(systemName: "checkmark.circle.fill").foregroundStyle(.green) }
                                    }
                                    .padding(8)
                                    .background(selectedLabel == s.label ? Color.green.opacity(0.15) : Color.gray.opacity(0.1))
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                                }
                            }
                        }
                    } else if imageData != nil && !analyzing {
                        Text("Не удалось распознать автоматически — введи калории вручную или подключи модель FoodClassifier.")
                            .font(.footnote).foregroundStyle(.secondary)
                    }

                    Group {
                        TextField("Название блюда", text: $name)
                        HStack {
                            TextField("Ккал", text: $calories).keyboardType(.numberPad)
                            Picker("Приём", selection: $meal) {
                                ForEach(MealType.allCases) { Text($0.rawValue).tag($0) }
                            }.pickerStyle(.segmented)
                        }
                    }
                    .textFieldStyle(.roundedBorder)

                    Button {
                        saveEntry()
                    } label: {
                        Label("Сохранить приём пищи", systemImage: "checkmark")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(name.isEmpty || Int(calories) == nil)

                    todayList
                }
                .padding()
            }
            .navigationTitle("Дневник еды")
            .sheet(isPresented: $showPicker) {
                ImagePicker(sourceType: pickerSource, imageData: $imageData)
            }
            .onChange(of: imageData) { _, newData in
                if let newData { analyze(newData) }
            }
        }
    }

    private var summaryCard: some View {
        VStack {
            Text("Сегодня съедено: \(totalToday) ккал").font(.headline)
            ProgressView(value: Double(min(totalToday, store.profile.dailyTargetCalories)),
                         total: Double(max(1, store.profile.dailyTargetCalories)))
                .tint(totalToday > store.profile.dailyTargetCalories ? .red : .green)
            Text("Остаток: \(remaining) ккал из \(store.profile.dailyTargetCalories)")
                .font(.caption).foregroundStyle(.secondary)
        }
        .padding().background(.thinMaterial).clipShape(RoundedRectangle(cornerRadius: 12))
    }

    private var todayList: some View {
        VStack(alignment: .leading) {
            Text("Приёмы сегодня").font(.headline)
            if todays.isEmpty { Text("Пока пусто").foregroundStyle(.secondary) }
            ForEach(todays) { e in
                HStack {
                    Text(e.meal.rawValue).font(.caption).foregroundStyle(.secondary).frame(width: 60, alignment: .leading)
                    Text(e.name)
                    Spacer()
                    Text("\(e.calories) ккал")
                    Button { context.delete(e); try? context.save() } label: { Image(systemName: "trash").foregroundStyle(.red) }
                }
            }
        }
    }

    private func analyze(_ data: Data) {
        analyzing = true
        suggestions = []
        Task {
            if let results = await FoodRecognizer.recognize(imageData: data) {
                await MainActor.run {
                    suggestions = results
                    analyzing = false
                }
            } else {
                await MainActor.run { analyzing = false; showManualHint = true }
            }
        }
    }

    private func saveEntry() {
        guard let cal = Int(calories), !name.isEmpty else { return }
        let photo = imageData
        let source = selectedLabel.isEmpty ? "Ручной ввод" : "ИИ: \(selectedLabel)"
        let entry = FoodEntry(name: name, calories: cal, meal: meal, source: source, photo: photo)
        context.insert(entry)
        try? context.save()
        imageData = nil; suggestions = []; selectedLabel = ""; name = ""; calories = ""
    }
}
