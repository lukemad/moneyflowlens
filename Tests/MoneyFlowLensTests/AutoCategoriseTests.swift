import XCTest
@testable import MoneyFlowLens

final class AutoCategoriseTests: XCTestCase {
    func testAutoCategorise() throws {
        let samples: [(String, ExpenseCategory)] = [
            ("Mortgage Payment", .householdOverhead),
            ("Monthly Rent", .householdOverhead),
            ("Utility Bill", .householdOverhead),
            ("Car Insurance", .householdOverhead),
            ("401k Contribution", .investing),
            ("IRA Deposit", .investing),
            ("Brokerage Transfer", .investing),
            ("Saving Deposit", .savings),
            ("Emergency Fund", .savings),
            ("Restaurant", .discretionary)
        ]

        for (payee, expected) in samples {
            var item = ExpenseItem(payee: payee, amount: 100, frequency: .monthly, nextDue: .now)
            item.autoCategorise()
            XCTAssertEqual(item.category, expected, "\(payee) should be \(expected)")
        }
    }
}
