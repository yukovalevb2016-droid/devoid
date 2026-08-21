import SwiftUI
import SwiftData

@main
struct WeightLossAppApp: App {
    let container: ModelContainer
    @StateObject private var profileStore: ProfileStore

    init() {
        let c = Persistence.makeContainer()
        container = c
        let ctx = c.mainContext
        _profileStore = StateObject(wrappedValue: ProfileStore(context: ctx))
        RecipesData.seedIfNeeded(context: ctx)
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(profileStore)
                .onAppear {
                    Task { _ = await ReminderManager.shared.requestAuthorization() }
                }
        }
        .modelContainer(container)
    }
}
