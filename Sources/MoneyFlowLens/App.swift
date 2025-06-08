import SwiftUI
import SwiftData


@main
struct MoneyFlowLensApp: App {
    @State private var rootClient = Client(
        displayName : "New Client",
        createdDate : .now,
        income      : [],
        expenses    : []
    )
    var body: some Scene {
        WindowGroup {
            ContentView(
                vm     : CashFlowViewModel(client: rootClient)
            )
            .modelContainer(for: Client.self)
        }
    }
}
