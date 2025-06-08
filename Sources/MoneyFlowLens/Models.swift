import Foundation
import SwiftData   // still needed

// MARK: - Frequency enum used by both models
enum Frequency: String, CaseIterable, Codable, Identifiable {
    case weekly, fortnightly, monthly, yearly

    /// Conformance to ``Identifiable`` allows use in `ForEach` without extra `id:` parameter.
    var id: Self { self }

    /// User-facing label for picker rows.
    var rawValueLabel: String { rawValue.capitalized }
}

// MARK: - ExpenseCategory used by ExpenseItem
enum ExpenseCategory: String, CaseIterable, Codable {
    case housing, investing, savings, householdOverhead, discretionary
}

// MARK: - SwiftData models  (must be classes in Xcode 16+)
@Model final class Client {
    var id          : UUID          = UUID()
    var displayName : String        = ""
    var createdDate : Date          = Date()
    @Relationship(deleteRule: .cascade, inverse: \IncomeItem.owner)
    var income      : [IncomeItem]  = []
    @Relationship(deleteRule: .cascade, inverse: \ExpenseItem.incomeOwner)
    var expenses    : [ExpenseItem] = []

    init(
        id: UUID = UUID(),
        displayName: String = "",
        createdDate: Date = Date(),
        income: [IncomeItem] = [],
        expenses: [ExpenseItem] = []
    ) {
        self.id = id
        self.displayName = displayName
        self.createdDate = createdDate
        self.income = income
        self.expenses = expenses
    }
}

@Model final class IncomeItem {
    var id         : UUID        = UUID()
    var sourceName : String      = ""
    var amount     : Decimal     = Decimal.zero
    var frequency  : Frequency   = Frequency.monthly
    var nextDue    : Date        = Date()
    @Relationship(inverse: \Client.income)
    var owner      : Client?     // optional back-link

    init(
        id: UUID = UUID(),
        sourceName: String = "",
        amount: Decimal = Decimal.zero,
        frequency: Frequency = Frequency.monthly,
        nextDue: Date = Date(),
        owner: Client? = nil
    ) {
        self.id = id
        self.sourceName = sourceName
        self.amount = amount
        self.frequency = frequency
        self.nextDue = nextDue
        self.owner = owner
    }
}

@Model final class ExpenseItem {
    var id         : UUID            = UUID()
    var payee      : String          = ""
    var amount     : Decimal         = Decimal.zero
    var frequency  : Frequency       = Frequency.monthly
    var nextDue    : Date            = Date()
    var category   : ExpenseCategory = ExpenseCategory.discretionary
    @Relationship(inverse: \Client.expenses) var incomeOwner: Client? // inverse side

    init(
        id: UUID = UUID(),
        payee: String = "",
        amount: Decimal = Decimal.zero,
        frequency: Frequency = Frequency.monthly,
        nextDue: Date = Date(),
        category: ExpenseCategory = ExpenseCategory.discretionary,
        incomeOwner: Client? = nil
    ) {
        self.id = id
        self.payee = payee
        self.amount = amount
        self.frequency = frequency
        self.nextDue = nextDue
        self.category = category
        self.incomeOwner = incomeOwner
    }
}
