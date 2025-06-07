import SwiftUI
import Sankey

struct CashFlowDiagram: View {
    @ObservedObject var vm: CashFlowViewModel

    var body: some View {
        SankeyDiagram(vm.diagramData)
            .linkColorMode(.gradient)
            .linkTension(0.55)
            .nodeSpacing(24)
            .frame(minHeight: 320)
            .padding()
    }
}
