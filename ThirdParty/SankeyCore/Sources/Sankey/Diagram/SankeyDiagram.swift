#if canImport(UIKit)
import SwiftUI
import WebKit

/// A SwiftUI-compatible Sankey Diagram (powered by Google Charts)
/// - Important: Requires an Internet connection
public struct SankeyDiagram: UIViewRepresentable {
    public let data: [SankeyLink]
    public let options: SankeyOptions

    @State private var isChartInitialized = false

    public class Coordinator: NSObject, WKScriptMessageHandler {
        var parent: SankeyDiagram

        init(parent: SankeyDiagram) {
            self.parent = parent
        }

        public func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
            if message.name == "chartInitialized" {
                DispatchQueue.main.async {
                    self.parent.isChartInitialized = true
                    if let webview = self.parent.webView {
                        self.parent.updateChartData(for: webview)
                    }
                }
            }
        }
    }

    public func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    @State private var webView: WKWebView?

    public func makeUIView(context: Context) -> WKWebView {
        let contentController = WKUserContentController()
        contentController.add(context.coordinator, name: "chartInitialized")
        
        let config = WKWebViewConfiguration()
        config.userContentController = contentController
        
        let webview = WKWebView(frame: .zero, configuration: config)
        webview.isOpaque = false
        webview.scrollView.isScrollEnabled = false
        webview.loadHTMLString(html(), baseURL: nil)
        DispatchQueue.main.async {
            self.webView = webview
        }
        return webview
    }
    
    public func updateUIView(_ webview: WKWebView, context: Context) {
        if isChartInitialized {
            updateChartData(for: webview)
        }
    }
    
    private func updateChartData(for webview: WKWebView) {
        let dataString = data.map { $0.description }.joined(separator: ", ")
        
        do {
            let optionsData = try JSONEncoder().encode(options)
            let optionsString = String(data: optionsData, encoding: .utf8) ?? "{}"
            
            let updateScript = """
            drawChart([\(dataString)], \(optionsString));
            """
            webview.evaluateJavaScript(updateScript, completionHandler: { (result, error) in
                if let error = error {
                    print("JavaScript error: \(error)")
                }
            })
        } catch {
            print("Failed to encode options: \(error)")
        }
    }
    
    private func html() -> String {
        """
        <html>
          <head>
            <script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
            <script type="text/javascript">
              google.charts.load('current', {'packages':['sankey']});
              google.charts.setOnLoadCallback(initializeChart);
              function initializeChart() {
                window.drawChart = function(data, options) {
                  var dataTable = new google.visualization.DataTable();
                  dataTable.addColumn('string', 'source');
                  dataTable.addColumn('string', 'target');
                  dataTable.addColumn('number', options.tooltip.valueLabel);
                  dataTable.addRows(data);
                  var chart = new google.visualization.Sankey(document.getElementById('chart'));
                  chart.draw(dataTable, options);
                };
                window.webkit.messageHandlers.chartInitialized.postMessage(null);
              }
            </script>
          </head>
          <body>
            <div id="chart" style="width: 100%; height: 100%"></div>
          </body>
        </html>
        """
    }
}

struct SankeyDiagram_Previews: PreviewProvider {
    static var previews: some View {
        ReadMeView()
    }
    
    struct ReadMeView: View {
        // Create some data
        @State var data: [SankeyLink] = [
            // Option A: ExpressibleByArrayLiteral init
            ["A", "X", "5"],
            ["A", "Y", "7"],
            ["A", "Z", "6"],
            ["B", "X", "2"],
            ["B", "Y", "9"],
            ["B", "Z", "4"]
        ]
        
        var body: some View {
            GeometryReader { geo in
                VStack(spacing: 20) {
                    Text("Sankeys in SwiftUI!")
                        .font(.title3.bold())
                        .padding(.top, 20)
                    // Native SwiftUI component
                    SankeyDiagram(
                        data,
                        nodeLabelFontSize: 50,
                        nodeInteractivity: true,
                        linkColorMode: .gradient,
                        tooltipTextFontSize: 50
                    )
                    // Will take up full View, unless you constrain it...
                    .frame(height: geo.size.height * 0.5)
                    Button {
                        data.append(
                            // Option B: Normal init
                            SankeyLink(source: "C", target: "X", value: 3)
                        )
                    } label: {
                        Text("Add a new link")
                    }
                    Text("Lorem Ipsum...")
                }
            }
        }
    }
}

extension SankeyDiagram {
    /// Creates a Sankey Diagram
    /// - Parameters:
    ///   - data: Array of SankeyLink objects
    ///   - nodeColors: Custom color (hexcodes) palette to cycle through for sankey nodes
    ///   - nodeColorMode: Coloring mode for the sankey nodes
    ///   - nodeWidth: Thickness of the node
    ///   - nodePadding: Vertical distance between nodes
    ///   - nodeLabelColor: Node label color (hexcode/html)
    ///   - nodeLabelFontSize: Node label font size (pixels)
    ///   - nodeLabelFontName: Node label font name
    ///   - nodeLabelBold: Bold node label
    ///   - nodeLabelItalic: Italicize node label
    ///   - nodeLabelPadding: Horizontal distance between the label and the node
    ///   - nodeInteractivity: Allow users to select node
    ///   - linkColors: Custom color (hexcode) palette to cycle through for sankey links
    ///   - linkColorMode: Coloring mode for the links between nodes (this option will override any linkColor+ argument)
    ///   - linkColorFill: Color of the link
    ///   - linkColorFillOpacity: Transparency of the link
    ///   - linkColorStroke: Color of the link border
    ///   - linkColorStrokeWidth: Thickness of the link border
    ///   - tooltipValueLabel: Name of the link value to be displayed in the tooltip
    ///   - tooltipTextColor: Tooltip text color (html/hexcode)
    ///   - tooltipTextFontSize: Tooltip text font size (pixels)
    ///   - tooltipTextFontName: Tooltip text font name
    ///   - tooltipTextBold: Bold tooltip label text
    ///   - tooltipTextItalic: Italicize tooltip label text
    ///   - layoutIterations: D3 layout engine layout search attempts to find the most optimal node positions (increasing this number may lead to more pleasing layouts of complex sankeys, at some cost)
    /// - Note: See the [Google Charts documentation](https://developers.google.com/chart/interactive/docs/gallery/sankey) for more info
    public init(
        _ data: [SankeyLink],
        nodeColors: [String]? = nil,
        nodeColorMode: SankeyOptions.Sankey.Node.ColorMode = .unique,
        nodeWidth: Double? = nil,
        nodePadding: Double? = nil,
        nodeLabelColor: String = "black",
        nodeLabelFontSize: Double = 24,
        nodeLabelFontName: String? = nil,
        nodeLabelBold: Bool = false,
        nodeLabelItalic: Bool = false,
        nodeLabelPadding: Double? = nil,
        nodeInteractivity: Bool = false,
        linkColors: [String]? = nil,
        linkColorMode: SankeyOptions.Sankey.Link.ColorMode? = nil,
        linkColorFill: String? = nil,
        linkColorFillOpacity: Double? = nil,
        linkColorStroke: String? = nil,
        linkColorStrokeWidth: Double = 0,
        tooltipValueLabel: String = "",
        tooltipTextColor: String = "black",
        tooltipTextFontSize: Double = 24,
        tooltipTextFontName: String? = nil,
        tooltipTextBold: Bool = false,
        tooltipTextItalic: Bool = false,
        layoutIterations: Int = 32
    ) {
        self.data = data
        self.options = .init(
            nodeColors: nodeColors,
            nodeColorMode: nodeColorMode,
            nodeWidth: nodeWidth,
            nodePadding: nodePadding,
            nodeLabelColor: nodeLabelColor,
            nodeLabelFontSize: nodeLabelFontSize,
            nodeLabelFontName: nodeLabelFontName,
            nodeLabelBold: nodeLabelBold,
            nodeLabelItalic: nodeLabelItalic,
            nodeLabelPadding: nodeLabelPadding,
            nodeInteractivity: nodeInteractivity,
            linkColors: linkColors,
            linkColorMode: linkColorMode,
            linkColorFill: linkColorFill,
            linkColorFillOpacity: linkColorFillOpacity,
            linkColorStroke: linkColorStroke,
            linkColorStrokeWidth: linkColorStrokeWidth,
            tooltipValueLabel: tooltipValueLabel,
            tooltipTextColor: tooltipTextColor,
            tooltipTextFontSize: tooltipTextFontSize,
            tooltipTextFontName: tooltipTextFontName,
            tooltipTextBold: tooltipTextBold,
            tooltipTextItalic: tooltipTextItalic,
            layoutIterations: layoutIterations
        )
    }
}
#endif

