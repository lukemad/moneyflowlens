import SwiftUI
import SwiftData

struct IncomeFormView: View {
    @Environment(\.modelContext) private var context
    let client: Client
    var onClose: () -> Void

    @State private var sourceName = ""
    @State private var amount: Double = 0
    @State private var frequency: Frequency = .monthly
    @State private var nextDue = Date()
    @State private var errorMessage: String?

    private var amountFormatter: NumberFormatter {
        let f = NumberFormatter()
        f.numberStyle = .decimal
        f.minimumFractionDigits = 0
        f.maximumFractionDigits = 2
        return f
    }

    private var canSave: Bool {
        !sourceName.trimmingCharacters(in: .whitespaces).isEmpty && amount > 0
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Add Income").font(.headline)
            Form {
                TextField("Source",   text: $sourceName)
                TextField("Amount",   value: $amount, formatter: amountFormatter)
                Picker("Frequency",   selection: $frequency) {
                    ForEach(Frequency.allCases) { freq in
                        Text(freq.rawValueLabel).tag(freq)
                    }
                }
                DatePicker("Next Due", selection: $nextDue)
            }
            if let errorMessage {
                Text(errorMessage)
                    .font(.callout)
                    .foregroundStyle(.red)
            }
            HStack {
                Spacer()
                Button("Cancel", action: onClose)
                    .keyboardShortcut(.cancelAction)
                Button("Save", action: save)
                    .keyboardShortcut(.defaultAction)
                    .disabled(!canSave)
            }
        }
        .padding()
        .frame(minWidth: 380, minHeight: 240)
    }

    private func save() {
        let item = IncomeItem(
            sourceName: sourceName.trimmingCharacters(in: .whitespaces),
            amount: Decimal(amount),
            frequency: frequency,
            nextDue: nextDue
        )
        context.insert(item)
        client.income.append(item)
        do {
            try context.save()
            onClose()
        } catch {
            errorMessage = "Save failed: \(error.localizedDescription)"
            print("IncomeFormView save error: \(error)")
        }
    }
}
