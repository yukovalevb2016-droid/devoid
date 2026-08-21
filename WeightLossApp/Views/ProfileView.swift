import SwiftUI

struct ProfileView: View {
    @EnvironmentObject private var store: ProfileStore
    @State private var showSaved = false

    private var p: Profile { store.profile }

    var body: some View {
        NavigationStack {
            VStack(spacing: 12) {
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("ИМТ \(String(format: "%.1f", p.bmi))")
                            .font(.title2.bold())
                        Text(p.bmiCategory)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    Spacer()
                    ZStack {
                        Circle().stroke(Color.green.opacity(0.2), lineWidth: 8)
                        Circle().trim(from: 0, to: p.goalProgress)
                            .stroke(Color.green, lineWidth: 8)
                            .rotationEffect(.degrees(-90))
                        Text("\(Int(p.goalProgress * 100))%")
                            .font(.caption.bold())
                    }
                    .frame(width: 64, height: 64)
                }
                .padding()
                .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 16))
            }
            .padding(.horizontal)

            Form {
                Section("Параметры тела") {
                    Stepper("Рост: \(Int(p.heightCm)) см", value: $store.profile.heightCm, in: 120...220, step: 1)
                    Stepper("Вес: \(String(format: "%.1f", p.weightKg)) кг", value: $store.profile.weightKg, in: 30...250, step: 0.1)
                    Stepper("Стартовый вес: \(String(format: "%.1f", p.startWeightKg)) кг", value: $store.profile.startWeightKg, in: 30...250, step: 0.1)
                    Stepper("Желательный вес: \(String(format: "%.1f", p.targetWeightKg)) кг", value: $store.profile.targetWeightKg, in: 30...250, step: 0.1)
                    Stepper("Возраст: \(p.age) лет", value: $store.profile.age, in: 10...100, step: 1)
                }

                Section("Пол и активность") {
                    Picker("Пол", selection: $store.profile.sex) {
                        ForEach(Sex.allCases) { Text($0.rawValue).tag($0) }
                    }
                    Picker("Активность", selection: $store.profile.activity) {
                        ForEach(ActivityLevel.allCases) { Text($0.rawValue).tag($0) }
                    }
                    Picker("Цель", selection: $store.profile.goal) {
                        ForEach(Goal.allCases) { Text($0.rawValue).tag($0) }
                    }
                }

                Section("Расчёты") {
                    HStack { Text("ИМТ"); Spacer(); Text(String(format: "%.1f", p.bmi)).bold() }
                    HStack { Text("Категория ИМТ"); Spacer(); Text(p.bmiCategory).foregroundStyle(.secondary) }
                    HStack { Text("Базовый метаболизм (BMR)"); Spacer(); Text("\(p.bmr, specifier: "%.0f") ккал").bold() }
                    HStack { Text("Расход с активностью (TDEE)"); Spacer(); Text("\(p.tdee, specifier: "%.0f") ккал").bold() }
                    HStack { Text("Цель калорий в день"); Spacer(); Text("\(p.dailyTargetCalories) ккал").bold().foregroundStyle(.green) }

                    let delta = p.weightDeltaNeeded
                    HStack {
                        Text("Нужно")
                        Spacer()
                        if abs(delta) < 0.05 {
                            Text("Вес уже в цели").foregroundStyle(.green).bold()
                        } else if delta < 0 {
                            Text("сбросить \(String(format: "%.1f", abs(delta))) кг").foregroundStyle(.orange).bold()
                        } else {
                            Text("набрать \(String(format: "%.1f", delta)) кг").foregroundStyle(.blue).bold()
                        }
                    }

                    VStack(alignment: .leading, spacing: 4) {
                        Text("Прогресс к цели: \(Int(p.goalProgress * 100))%").font(.footnote).foregroundStyle(.secondary)
                        ProgressView(value: p.goalProgress)
                            .tint(.green)
                    }
                }
            }
            .navigationTitle("Профиль")
            .toolbar {
                Button("Сохранить") {
                    store.save()
                    withAnimation { showSaved = true }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { showSaved = false }
                }
            }
            .overlay(alignment: .center) {
                if showSaved { Text("Сохранено ✓").padding().background(.ultraThinMaterial).clipShape(RoundedRectangle(cornerRadius: 10)) }
            }
        }
    }
}
