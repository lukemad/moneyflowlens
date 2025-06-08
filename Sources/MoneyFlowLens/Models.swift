import Foundation
import SwiftData   // still needed

// MARK: - Frequency enum used by both models
enum Frequency: String, CaseIterable, Codable {
    case weekly, fortnightly, monthly, yearly
}

// MARK: - ExpenseCategory used by ExpenseItem
enum ExpenseCategory: String, CaseIterable, Codable {
    case housing, investing, savings, householdOverhead, discretionary
}

// MARK: - SwiftData models  (must be classes in Xcode 16+)
@Model final class Client {
    var id          : UUID          = .init()
    var displayName : String        = ""
    var createdDate : Date          = .now
    @Relationship(deleteRule: .cascade)
    var income      : [IncomeItem]  = []
    @Relationship(deleteRule: .cascade)
    var expenses    : [ExpenseItem] = []

    init(
        id: UUID = .init(),
        displayName: String = "",
        createdDate: Date = .now,
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
    var id         : UUID        = .init()
    var sourceName : String      = ""
    var amount     : Decimal     = .zero
    var frequency  : Frequency   = Frequency.monthly
    var nextDue    : Date        = .now
    @Relationship(inverse: \ExpenseItem.incomeOwner)
    var owner      : Client?     // optional back-link

    init(
        id: UUID = .init(),
        sourceName: String = "",
        amount: Decimal = .zero,
        frequency: Frequency = Frequency.monthly,
        nextDue: Date = .now,
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
    var id         : UUID            = .init()
    var payee      : String          = ""
    var amount     : Decimal         = .zero
    var frequency  : Frequency       = Frequency.monthly
    var nextDue    : Date            = .now
    var category   : ExpenseCategory = ExpenseCategory.discretionary
    @Relationship var incomeOwner    : Client?   // inverse side

    init(
        id: UUID = .init(),
        payee: String = "",
        amount: Decimal = .zero,
        frequency: Frequency = Frequency.monthly,
        nextDue: Date = .now,
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
