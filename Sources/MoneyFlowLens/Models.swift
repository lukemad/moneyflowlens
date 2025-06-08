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
}

@Model final class IncomeItem {
    var id         : UUID        = .init()
    var sourceName : String      = ""
    var amount     : Decimal     = .zero
    var frequency  : Frequency   = .monthly
    var nextDue    : Date        = .now
    @Relationship(inverse: \ExpenseItem.incomeOwner)
    var owner      : Client?     // optional back-link
}

@Model final class ExpenseItem {
    var id         : UUID            = .init()
    var payee      : String          = ""
    var amount     : Decimal         = .zero
    var frequency  : Frequency       = .monthly
    var nextDue    : Date            = .now
    var category   : ExpenseCategory = .discretionary
    @Relationship var incomeOwner    : Client?   // inverse side
}
