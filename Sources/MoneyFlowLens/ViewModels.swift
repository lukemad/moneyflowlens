import Foundation
import SwiftUI
import SankeyCore   // brings in SankeyDataSet, SankeyLink, etc.

final class CashFlowViewModel: ObservableObject {
    @Published var client: Client

    init(client: Client) {
        self.client = client
    }

    var diagramData: SankeyDataSet {
        let incomeNodes = client.income.map { item in
            SankeyNode(item.sourceName)
        }

        let expenseNodes = client.expenses.map { item in
            SankeyNode(item.payee)
        }

        let allNodes = incomeNodes + expenseNodes

        var links: [SankeyLink] = []
        for income in client.income {
            for expense in client.expenses {
                // simple equal split example
                let incomeAmount = Double(truncating: income.amount as NSNumber)
                let expenseAmount = Double(truncating: expense.amount as NSNumber)
                let amount = Swift.min(incomeAmount, expenseAmount)
                links.append(
                    SankeyLink(
                        source: income.sourceName,
                        target: expense.payee,
                        value: amount
                    )
                )
            }
        }

        return SankeyDataSet(nodes: allNodes, links: links)
    }
}
