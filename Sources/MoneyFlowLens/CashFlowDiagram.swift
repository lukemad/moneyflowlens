import SwiftUI
import Sankey

private let nodes = [
    SankeyNode("Salary"),
    SankeyNode("Checking"),
    SankeyNode("Housing")
]

private let links = [
    SankeyLink(7_500, from: "Salary",   to: "Checking"),
    SankeyLink(2_000, from: "Checking", to: "Housing")
]

struct CashFlowDiagram: View {
    private let data = SankeyData(nodes: nodes, links: links)

    var body: some View {
        SankeyDiagram(data)
            .linkColorMode(.gradient)   // 1.x modifier
            .nodeOpacity(0.9)
            .frame(height: 340)
            .padding(12)
    }
}

#Preview { CashFlowDiagram() }
