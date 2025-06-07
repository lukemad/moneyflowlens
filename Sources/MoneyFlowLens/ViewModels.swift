import Foundation
import SwiftUI
import Sankey

final class CashFlowViewModel: ObservableObject {
    @Published var client: Client

    init(client: Client) {
        self.client = client
    }

    var diagramData: SankeyData {
        let incomeNodes = client.income.map { item in
            SankeyData.Node(id: item.id.uuidString, title: item.sourceName, amount: Double(truncating: item.amount as NSNumber))
        }
        let expenseNodes = client.expenses.map { item in
            SankeyData.Node(id: item.id.uuidString, title: item.payee, amount: Double(truncating: item.amount as NSNumber))
        }
        let allNodes = incomeNodes + expenseNodes

        var links: [SankeyData.Link] = []
        for i in incomeNodes {
            for e in expenseNodes {
                // simple equal split example
                links.append(SankeyData.Link(source: i.id, target: e.id, value: min(i.amount, e.amount)))
            }
        }
        return SankeyData(nodes: allNodes, links: links)
    }
}
