import SwiftUI
import SwiftData

struct IncomeFormView: View {
    @Environment(\.modelContext) private var context
    @State private var sourceName = ""
    @State private var amount = 0.0
    @State private var frequency: Frequency = .monthly
    @State private var nextDue = Date()
    var onSave: () -> Void

    var body: some View {
        Form {
            TextField("Source", text: $sourceName)
            TextField("Amount", value: $amount, formatter: NumberFormatter())
            Picker("Frequency", selection: $frequency) {
                ForEach(Frequency.allCases) { freq in
                    Text(freq.rawValue).tag(freq)
                }
            }
            DatePicker("Next Due", selection: $nextDue)
            Button("Save") {
                let item = IncomeItem(sourceName: sourceName, amount: Decimal(amount), frequency: frequency, nextDue: nextDue)
                context.insert(item)
                try? context.save()
                onSave()
            }
        }
        .padding()
    }
}
