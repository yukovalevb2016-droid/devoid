import Foundation
import SwiftData
import Combine

@MainActor
final class ProfileStore: ObservableObject {
    @Published var profile: Profile
    private let context: ModelContext

    init(context: ModelContext) {
        self.context = context
        let descriptor = FetchDescriptor<Profile>()
        if let existing = (try? context.fetch(descriptor))?.first {
            self.profile = existing
        } else {
            let p = Profile()
            context.insert(p)
            try? context.save()
            self.profile = p
        }
    }

    func save() {
        try? context.save()
        objectWillChange.send()
    }
}
