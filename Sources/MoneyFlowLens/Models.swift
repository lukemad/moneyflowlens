import Foundation
import SwiftData

@Model
struct Client {
    var id: UUID = UUID()
    var displayName: String
    var created: Date = Date()
    var income: [IncomeItem] = []
    var expenses: [ExpenseItem] = []
}

@Model
struct IncomeItem {
    var id: UUID = UUID()
    var sourceName: String
    var amount: Decimal
    var frequency: Frequency
    var nextDue: Date
}

@Model
struct ExpenseItem {
    var id: UUID = UUID()
    var payee: String
    var amount: Decimal
    var frequency: Frequency
    var nextDue: Date
    var category: ExpenseCategory = .discretionary

    mutating func autoCategorise() {
        let p = payee.lowercased()
        if p.contains("mortgage") || p.contains("rent") || p.contains("utility") || p.contains("insurance") {
            category = .householdOverhead
        } else if p.contains("401k") || p.contains("ira") || p.contains("brokerage") {
            category = .investing
        } else if p.contains("saving") || p.contains("emergency") {
            category = .savings
        } else {
            category = .discretionary
        }
    }

    mutating func save(in context: ModelContext) throws {
        autoCategorise()
        context.insert(self)
        try context.save()
    }
}

enum ExpenseCategory: String, CaseIterable, Identifiable {
    case householdOverhead, savings, investing, discretionary, other
    var id: Self { self }
}

enum Frequency: String, CaseIterable, Identifiable {
    case once, weekly, biweekly, monthly, quarterly, yearly
    var id: Self { self }
}
