import Foundation

extension ExpenseItem {
    /// Categorise an expense based on simple keyword rules.
    /// Call this right after creating the object (e.g. in ExpenseFormView).
    func autoCategorise() {
        let p = payee.lowercased()

        if p.contains("mortgage")
            || p.contains("rent")
            || p.contains("utility")
            || p.contains("insurance") {

            category = .householdOverhead     // adjust enum cases if yours differ
        }
        else if p.contains("401k")
            || p.contains("ira")
            || p.contains("brokerage") {

            category = .investing
        }
        else if p.contains("saving")
            || p.contains("emergency") {

            category = .savings
        }
        else {
            category = .discretionary
        }
    }
}
