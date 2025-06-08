#if os(macOS)
import SwiftUI

/// Placeholder — the real diagram is supplied by the host app.
public struct SankeyDiagram: View {
    public init() {}
    public var body: some View {
        Text("SankeyDiagram is iOS-only in the vanilla library.")
            .font(.callout.italic())
            .foregroundStyle(.secondary)
    }
}
#endif

