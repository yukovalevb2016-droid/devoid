import SwiftUI
import SwiftData
import Charts
import AVFoundation
import UIKit

struct WeightView: View {
    @Environment(\.modelContext) private var context
    @Query(sort: \WeightEntry.date) private var entries: [WeightEntry]
    @Query(sort: \ProgressPhoto.date, order: .reverse) private var photos: [ProgressPhoto]

    @State private var weight = ""
    @State private var note = ""

    @State private var showPhotoLibrary = false
    @State private var showPhotoCamera = false
    @State private var pickedPhotoData: Data?
    @State private var photoNote = ""
    @State private var showCameraAlertPhoto = false

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

                    VStack(alignment: .leading, spacing: 10) {
                        Text("Фото прогресса").font(.headline)
                        HStack {
                            Button { openCameraForPhoto() } label: { Label("Камера", systemImage: "camera").frame(maxWidth: .infinity) }
                                .buttonStyle(.bordered)
                            Button { showPhotoLibrary = true } label: { Label("Галерея", systemImage: "photo").frame(maxWidth: .infinity) }
                                .buttonStyle(.bordered)
                        }

                        if let data = pickedPhotoData, let ui = UIImage(data: data) {
                            VStack(alignment: .leading, spacing: 6) {
                                Image(uiImage: ui).resizable().scaledToFit().frame(maxHeight: 180)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                TextField("Подпись: ДО / ПОСЛЕ / промежуточное", text: $photoNote)
                                    .textFieldStyle(.roundedBorder)
                                Button {
                                    context.insert(ProgressPhoto(note: photoNote, photo: pickedPhotoData))
                                    try? context.save()
                                    pickedPhotoData = nil
                                    photoNote = ""
                                } label: {
                                    Label("Сохранить фото", systemImage: "checkmark").frame(maxWidth: .infinity)
                                }
                                .buttonStyle(.borderedProminent)
                            }
                        }

                        if !photos.isEmpty {
                            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 8), count: 3), spacing: 8) {
                                ForEach(photos) { ph in
                                    VStack(alignment: .leading, spacing: 2) {
                                        if let d = ph.photo, let img = UIImage(data: d) {
                                            Image(uiImage: img).resizable().scaledToFill()
                                                .frame(height: 90).clipShape(RoundedRectangle(cornerRadius: 8)).clipped()
                                        } else {
                                            Color.gray.opacity(0.2).frame(height: 90)
                                                .clipShape(RoundedRectangle(cornerRadius: 8))
                                        }
                                        Text(ph.note.isEmpty ? "—" : ph.note).font(.caption).lineLimit(1)
                                        Text(ph.date, style: .date).font(.caption2).foregroundStyle(.secondary)
                                        Button { context.delete(ph); try? context.save() } label: {
                                            Image(systemName: "trash").foregroundStyle(.red)
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Контроль веса")
            .sheet(isPresented: $showPhotoLibrary) {
                ImagePicker(sourceType: .photoLibrary, imageData: $pickedPhotoData)
            }
            .sheet(isPresented: $showPhotoCamera) {
                ImagePicker(sourceType: .camera, imageData: $pickedPhotoData)
            }
            .alert("Камера недоступна", isPresented: $showCameraAlertPhoto) {
                Button("ОК", role: .cancel) {}
            } message: {
                Text("Разреши доступ к камере в Настройки → Стройность → Камера, либо используй кнопку «Галерея».")
            }
        }
    }

    private func openCameraForPhoto() {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            showCameraAlertPhoto = true
            return
        }
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        switch status {
        case .authorized:
            showPhotoCamera = true
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                DispatchQueue.main.async {
                    if granted { showPhotoCamera = true } else { showCameraAlertPhoto = true }
                }
            }
        default:
            showCameraAlertPhoto = true
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
