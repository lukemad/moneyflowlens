import SwiftUI
import SwiftData

@main
struct MoneyFlowLensApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(vm: CashFlowViewModel())
                .modelContainer(for: Client.self)
        }
    }
}
