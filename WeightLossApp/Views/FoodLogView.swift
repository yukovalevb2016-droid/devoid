import SwiftUI
import UIKit
import SwiftData
import AVFoundation

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
    @State private var selectedLabels: [String] = []
    @State private var selectedCalories: [String: String] = [:]
    @State private var name = ""
    @State private var calories = ""
    @State private var meal: MealType = .lunch
    @State private var analyzing = false

    @State private var recognitionError: String?
    @State private var showCameraAlert = false
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
                    if !FoodRecognizer.isModelAvailable {
                        HStack(spacing: 8) {
                            Image(systemName: "brain").foregroundStyle(.orange)
                            Text("Модель FoodClassifier не подключена — калории вводи вручную или выбери из списка после съёмки.")
                                .font(.footnote).foregroundStyle(.secondary)
                        }
                        .padding(10)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.orange.opacity(0.12), in: RoundedRectangle(cornerRadius: 12))
                    }

                    summaryCard

                    if let data = imageData, let ui = UIImage(data: data) {
                        Image(uiImage: ui)
                            .resizable().scaledToFit().frame(maxHeight: 220)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    }

                    HStack {
                        Button {
                            openCamera()
                        } label: {
                            Label("Камера", systemImage: "camera").frame(maxWidth: .infinity)
                        }.buttonStyle(.bordered)
                        Button { pickerSource = .photoLibrary; showPicker = true } label: {
                            Label("Галерея", systemImage: "photo").frame(maxWidth: .infinity)
                        }.buttonStyle(.bordered)
                    }

                    if analyzing { ProgressView("Анализирую фото…") }

                    if let err = recognitionError, imageData != nil && !analyzing {
                        Text(err)
                            .font(.footnote).foregroundStyle(.red)
                            .padding(10)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color.red.opacity(0.1), in: RoundedRectangle(cornerRadius: 12))
                    }

                    let foodSuggestions = suggestions.filter { FoodDatabase.match(for: $0.label) != nil }

                    if !foodSuggestions.isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Распознанные продукты (нажми, чтобы выбрать несколько):").font(.headline)
                            ForEach(foodSuggestions, id: \.label) { s in
                                let info = FoodDatabase.info(for: s.label)
                                Button {
                                    toggleSelection(s.label)
                                } label: {
                                    HStack {
                                        Text("\(info.emoji) \(info.name)")
                                        Spacer()
                                        Text("\(Int(s.confidence * 100))%")
                                        if selectedLabels.contains(s.label) {
                                            Image(systemName: "checkmark.circle.fill").foregroundStyle(.green)
                                        }
                                    }
                                    .padding(8)
                                    .background(selectedLabels.contains(s.label) ? Color.green.opacity(0.15) : Color.gray.opacity(0.1))
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                                }
                            }
                        }
                    } else if imageData != nil && !analyzing && recognitionError == nil {
                        Text("Еду не удалось распознать — выбери продукты вручную ниже или введи название.")
                            .font(.footnote).foregroundStyle(.secondary)
                    }

                    if !selectedLabels.isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Выбрано:").font(.headline)
                            ForEach(selectedLabels, id: \.self) { label in
                                let info = FoodDatabase.info(for: label)
                                HStack {
                                    Text("\(info.emoji) \(info.name)")
                                    Spacer()
                                    TextField("Ккал", text: calorieBinding(for: label))
                                        .keyboardType(.numberPad)
                                        .frame(width: 72)
                                        .textFieldStyle(.roundedBorder)
                                }
                            }
                            Button {
                                saveSelected()
                            } label: {
                                Label("Добавить выбранное (\(selectedLabels.count))", systemImage: "checkmark")
                                    .frame(maxWidth: .infinity)
                            }
                            .buttonStyle(.borderedProminent)
                        }
                    }

                    Group {
                        TextField("Название блюда (вручную)", text: $name)
                        HStack {
                            TextField("Ккал", text: $calories).keyboardType(.numberPad)
                            Picker("Приём", selection: $meal) {
                                ForEach(MealType.allCases) { Text($0.rawValue).tag($0) }
                            }.pickerStyle(.segmented)
                        }
                    }
                    .textFieldStyle(.roundedBorder)

                    Button {
                        saveManual()
                    } label: {
                        Label("Добавить вручную", systemImage: "plus")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.bordered)
                    .disabled(name.isEmpty || Int(calories) == nil)

                    todayList
                }
                .padding()
            }
            .navigationTitle("Дневник еды")
            .sheet(isPresented: $showPicker) {
                ImagePicker(sourceType: pickerSource, imageData: $imageData)
            }
            .alert("Камера недоступна", isPresented: $showCameraAlert) {
                Button("ОК", role: .cancel) {}
            } message: {
                Text("Разреши доступ к камере в Настройки → Стройность → Камера, либо используй кнопку «Галерея».")
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

    private func openCamera() {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            showCameraAlert = true
            return
        }
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        switch status {
        case .authorized:
            pickerSource = .camera
            showPicker = true
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                DispatchQueue.main.async {
                    if granted {
                        pickerSource = .camera
                        showPicker = true
                    } else {
                        showCameraAlert = true
                    }
                }
            }
        default:
            showCameraAlert = true
        }
    }

    private func analyze(_ data: Data) {
        analyzing = true
        suggestions = []
        selectedLabels = []
        selectedCalories = [:]
        recognitionError = nil
        Task {
            let (results, error) = await FoodRecognizer.recognize(imageData: data)
            await MainActor.run {
                if let results, !results.isEmpty {
                    suggestions = results
                    recognitionError = nil
                } else {
                    suggestions = []
                    recognitionError = error
                }
                analyzing = false
            }
        }
    }

    private func calorieBinding(for label: String) -> Binding<String> {
        Binding(
            get: { selectedCalories[label] ?? "" },
            set: { selectedCalories[label] = $0 }
        )
    }

    private func toggleSelection(_ label: String) {
        if let idx = selectedLabels.firstIndex(of: label) {
            selectedLabels.remove(at: idx)
            selectedCalories[label] = nil
        } else {
            selectedLabels.append(label)
            let info = FoodDatabase.info(for: label)
            selectedCalories[label] = info.calories > 0 ? "\(info.calories)" : ""
        }
    }

    private func saveSelected() {
        for label in selectedLabels {
            let info = FoodDatabase.info(for: label)
            let calText = selectedCalories[label] ?? ""
            let cal = Int(calText) ?? info.calories
            let entry = FoodEntry(
                name: info.name,
                calories: max(0, cal),
                meal: meal,
                source: "ИИ: \(label)",
                photo: imageData
            )
            context.insert(entry)
        }
        try? context.save()
        resetAfterSave()
    }

    private func saveManual() {
        guard let cal = Int(calories), !name.isEmpty else { return }
        let entry = FoodEntry(
            name: name,
            calories: cal,
            meal: meal,
            source: "Ручной ввод",
            photo: imageData
        )
        context.insert(entry)
        try? context.save()
        resetAfterSave()
    }

    private func resetAfterSave() {
        imageData = nil
        suggestions = []
        selectedLabels = []
        selectedCalories = [:]
        name = ""
        calories = ""
    }
}
