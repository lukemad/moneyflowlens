import Foundation
import SwiftUI
import SankeyCore

final class CashFlowViewModel: ObservableObject {
    @Published var client: Client

    init(client: Client) {
        self.client = client
    }

    var diagramData: SankeyData {
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
                links.append(SankeyLink(amount, from: income.sourceName, to: expense.payee))
            }
        }

        return SankeyData(nodes: allNodes, links: links)
    }
}
