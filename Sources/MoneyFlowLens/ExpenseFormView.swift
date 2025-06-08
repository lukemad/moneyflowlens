import SwiftUI
import SwiftData

struct ExpenseFormView: View {
    @Environment(\.modelContext) private var context
    @State private var payee = ""
    @State private var amount = 0.0
    @State private var frequency: Frequency = Frequency.monthly
    @State private var nextDue = Date()
    var onSave: () -> Void

    var body: some View {
        Form {
            TextField("Payee", text: $payee)
            TextField("Amount", value: $amount, formatter: NumberFormatter())
            Picker("Frequency", selection: $frequency) {
                ForEach(Frequency.allCases) { freq in
                    Text(freq.rawValue).tag(freq)
                }
            }
            DatePicker("Next Due", selection: $nextDue)
            Button("Save") {
                var item = ExpenseItem(payee: payee, amount: Decimal(amount), frequency: frequency, nextDue: nextDue)
                item.autoCategorise()
                context.insert(item)
                try? context.save()
                onSave()
            }
        }
        .padding()
    }
}
