import SwiftUI
import Sankey

private let demoNodes = [
    SankeyNode("Salary"),
    SankeyNode("Checking"),
    SankeyNode("Housing")
]

private let demoLinks = [
    SankeyLink(7_500, from: "Salary",   to: "Checking"),
    SankeyLink(2_000, from: "Checking", to: "Housing")
]

struct CashFlowDiagram: View {
    private let data = SankeyData(nodes: demoNodes, links: demoLinks)

    var body: some View {
        SankeyDiagram(data)
            .linkColorMode(.gradient)
            .nodeOpacity(0.9)
            .frame(height: 340)
            .padding(12)
    }
}

#Preview { CashFlowDiagram() }
