import SwiftUI
import SwiftData

struct ContentView: View {
    @Query(sort: \Client.createdDate) private var clients: [Client]
    @Environment(\.modelContext) private var context
    @State private var selection: Client?
    @State private var showIncomeSheet = false
    @State private var showExpenseSheet = false
    @StateObject private var vm: CashFlowViewModel

    public init(vm: CashFlowViewModel) {
        _vm = StateObject(wrappedValue: vm)
    }

    var body: some View {
        NavigationSplitView {
            List(clients, selection: $selection) { client in
                Text(client.displayName)
            }
            .toolbar {
                Button(action: addClient) { Label("Add", systemImage: "plus") }
            }
        } detail: {
            if let client = selection {
                ClientDetailView(client: $client)
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
    @StateObject private var vm: CashFlowViewModel
    @State private var showIncome = false
    @State private var showExpense = false

    init(client: Binding<Client>) {
        self._client = client
        _vm = StateObject(wrappedValue: CashFlowViewModel(client: client.wrappedValue))
    }

    var body: some View {
        TabView {
            VStack {
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
                .toolbar {
                    Button("Add Income") { showIncome = true }
                    Button("Add Expense") { showExpense = true }
                }
            }
            .tabItem { Text("Income & Expenses") }

            CashFlowDiagram()
                .tabItem { Text("Sankey Diagram") }

            VStack {
                TextField("Name", text: $client.displayName)
                Button("Delete") { /* deletion logic */ }
            }
            .padding()
            .tabItem { Text("Settings") }
        }
        .sheet(isPresented: $showIncome) {
            IncomeFormView { showIncome = false }
        }
        .sheet(isPresented: $showExpense) {
            ExpenseFormView { showExpense = false }
        }
    }
}
