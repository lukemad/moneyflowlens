import Foundation
import SankeyCore

struct SankeyDataSet {
    var nodes: [SankeyNode]
    var links: [SankeyLink]
}

extension SankeyDataSet {
    static func build(from client: Client) -> SankeyDataSet {
        let income = client.income
            .map { (
                name: $0.sourceName.trimmingCharacters(in: .whitespaces),
                monthly: $0.monthlyAmount
            ) }
            .filter { !$0.name.isEmpty && $0.monthly > 0 && $0.monthly.isFinite }

        let expenses = client.expenses
            .map { (
                payee: $0.payee.trimmingCharacters(in: .whitespaces),
                category: $0.category.displayName,
                monthly: $0.monthlyAmount
            ) }
            .filter { !$0.payee.isEmpty && $0.monthly > 0 && $0.monthly.isFinite }

        guard !income.isEmpty || !expenses.isEmpty else {
            return SankeyDataSet(nodes: [], links: [])
        }

        let budget = "Budget"
        var links: [SankeyLink] = []

        for entry in income {
            links.append(SankeyLink(source: entry.name, target: budget, value: entry.monthly))
        }

        let byCategory = Dictionary(grouping: expenses, by: \.category)
        for (category, items) in byCategory {
            let total = items.reduce(0.0) { $0 + $1.monthly }
            links.append(SankeyLink(source: budget, target: category, value: total))

            // Collapse repeat payees within the same category.
            let byPayee = Dictionary(grouping: items, by: \.payee)
            for (payee, rows) in byPayee {
                let value = rows.reduce(0.0) { $0 + $1.monthly }
                let target = (payee == category) ? "\(payee) (expense)" : payee
                links.append(SankeyLink(source: category, target: target, value: value))
            }
        }

        let totalIncome = income.reduce(0.0) { $0 + $1.monthly }
        let totalExpenses = expenses.reduce(0.0) { $0 + $1.monthly }
        let delta = totalIncome - totalExpenses
        if delta > 0.005 {
            // Two hops so the surplus lays out at the same column depth as
            // Budget → Category → Payee. Without the second hop, Google Sankey
            // pushes the leaf to the rightmost column and the link band visually
            // spans two columns.
            links.append(SankeyLink(source: budget,        target: "Unallocated", value: delta))
            links.append(SankeyLink(source: "Unallocated", target: "Reserve",     value: delta))
        } else if delta < -0.005 {
            links.append(SankeyLink(source: "Shortfall", target: budget, value: -delta))
        }

        let nodes = Array(Set(links.flatMap { [$0.source, $0.target] })).sorted()
        return SankeyDataSet(nodes: nodes, links: links)
    }
}

private extension Frequency {
    var monthlyMultiplier: Decimal {
        switch self {
        case .weekly:      return Decimal(52) / Decimal(12)
        case .fortnightly: return Decimal(26) / Decimal(12)
        case .monthly:     return Decimal(1)
        case .yearly:      return Decimal(1) / Decimal(12)
        }
    }
}

private extension IncomeItem {
    var monthlyAmount: Double {
        NSDecimalNumber(decimal: amount * frequency.monthlyMultiplier).doubleValue
    }
}

private extension ExpenseItem {
    var monthlyAmount: Double {
        NSDecimalNumber(decimal: amount * frequency.monthlyMultiplier).doubleValue
    }
}

private extension ExpenseCategory {
    var displayName: String {
        switch self {
        case .housing:           return "Housing"
        case .investing:         return "Investing"
        case .savings:           return "Savings"
        case .householdOverhead: return "Household Overhead"
        case .discretionary:     return "Discretionary"
        }
    }
}
