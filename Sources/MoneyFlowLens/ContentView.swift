import SwiftUI
import SwiftData

struct ContentView: View {
    @Query(sort: \Client.createdDate) private var clients: [Client]
    @Environment(\.modelContext) private var context
    @State private var selection: Client?

    @ToolbarContentBuilder
    private func clientListToolbar() -> some ToolbarContent {
        ToolbarItemGroup(placement: .primaryAction) {
            Button(action: addClient) {
                Label("Add", systemImage: "plus")
            }
        }
    }

    var body: some View {
        NavigationSplitView {
            List(clients, selection: $selection) { client in
                Text(client.displayName)
            }
            .toolbar(content: clientListToolbar)
        } detail: {
            if let client = selection {
                ClientDetailView(client: client)
            } else {
                Text("Select a client")
            }
        }
    }

    private func addClient() {
        let new = Client(displayName: "New Client")
        context.insert(new)
        try? context.save()
        selection = new
    }
}

struct ClientDetailView: View {
    @Bindable var client: Client
    @State private var showIncome = false
    @State private var showExpense = false

    @ToolbarContentBuilder
    private func detailToolbar() -> some ToolbarContent {
        ToolbarItemGroup(placement: .primaryAction) {
            Button("Add Income")  { showIncome  = true }
            Button("Add Expense") { showExpense = true }
        }
    }

    var body: some View {
        TabView {
            List {
                Section("Income") {
                    ForEach(client.income) { item in
                        Text(item.sourceName)
                    }
                }
                Section("Expenses") {
                    ForEach(client.expenses) { item in
                        Text(item.payee)
                    }
                }
            }
            .toolbar(content: detailToolbar)
            .tabItem { Text("Income & Expenses") }

            CashFlowDiagram(client: client)
                .tabItem { Text("Sankey Diagram") }

            VStack {
                TextField("Name", text: $client.displayName)
                Button("Delete") { /* deletion logic */ }
            }
            .padding()
            .tabItem { Text("Settings") }
        }
        .sheet(isPresented: $showIncome) {
            IncomeFormView(client: client, onClose: { showIncome = false })
        }
        .sheet(isPresented: $showExpense) {
            ExpenseFormView(client: client, onClose: { showExpense = false })
        }
    }
}
