#if os(macOS)
import SwiftUI
import WebKit
import SankeyCore

struct CashFlowDiagram: View {
    @Bindable var client: Client

    var body: some View {
        let dataSet = SankeyDataSet.build(from: client)
        Group {
            if dataSet.links.isEmpty {
                ContentUnavailableView(
                    "No cash flow yet",
                    systemImage: "chart.line.uptrend.xyaxis",
                    description: Text("Add income and expenses to see them flow.")
                )
            } else {
                SankeyWebView(links: dataSet.links)
            }
        }
        .padding()
    }
}

private struct SankeyWebView: NSViewRepresentable {
    let links: [SankeyLink]

    func makeCoordinator() -> Coordinator { Coordinator() }

    func makeNSView(context: Context) -> WKWebView {
        let config = WKWebViewConfiguration()
        config.userContentController.add(context.coordinator, name: "chartReady")

        let webView = WKWebView(frame: .zero, configuration: config)
        webView.loadHTMLString(Self.html, baseURL: URL(string: "https://www.gstatic.com"))
        context.coordinator.webView = webView
        context.coordinator.pendingLinks = links
        return webView
    }

    func updateNSView(_ webView: WKWebView, context: Context) {
        context.coordinator.pendingLinks = links
        if context.coordinator.isReady {
            context.coordinator.draw()
        }
    }

    final class Coordinator: NSObject, WKScriptMessageHandler {
        weak var webView: WKWebView?
        var isReady = false
        var pendingLinks: [SankeyLink] = []

        func userContentController(
            _ userContentController: WKUserContentController,
            didReceive message: WKScriptMessage
        ) {
            guard message.name == "chartReady" else { return }
            isReady = true
            draw()
        }

        func draw() {
            guard let webView else { return }
            let rows: [[Any]] = pendingLinks.map { [$0.source, $0.target, $0.value] }
            guard
                let data = try? JSONSerialization.data(withJSONObject: rows),
                let json = String(data: data, encoding: .utf8)
            else { return }
            webView.evaluateJavaScript("drawChart(\(json));", completionHandler: nil)
        }
    }

    private static let html = """
    <!doctype html>
    <html>
      <head>
        <style>
          html, body, #chart { width: 100%; height: 100%; margin: 0; padding: 0; }
          body { font-family: -apple-system, system-ui, sans-serif; }
        </style>
        <script src="https://www.gstatic.com/charts/loader.js"></script>
        <script>
          google.charts.load('current', { packages: ['sankey'] });
          google.charts.setOnLoadCallback(function () {
            window.drawChart = function (rows) {
              var data = new google.visualization.DataTable();
              data.addColumn('string', 'From');
              data.addColumn('string', 'To');
              data.addColumn('number', 'Monthly');
              data.addRows(rows);
              new google.visualization.Sankey(document.getElementById('chart')).draw(data, {
                sankey: {
                  link: { colorMode: 'gradient' },
                  node: { interactivity: true, label: { fontSize: 13 } }
                }
              });
            };
            window.webkit.messageHandlers.chartReady.postMessage(null);
          });
        </script>
      </head>
      <body><div id="chart"></div></body>
    </html>
    """
}
#endif
