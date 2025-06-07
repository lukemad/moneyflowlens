# MoneyFlowLens

MoneyFlowLens is a macOS SwiftUI application that helps advisors manage client cash-flows. Income and expenses are stored with SwiftData and visualised as a Sankey diagram. Recurring expense payees are auto-categorised on save.

This repository contains a Swift Package that can be opened with Xcode. The package declares a macOS 14 target and depends on [Sankey](https://github.com/maxhumber/Sankey) for diagram rendering.

## Building

1. Open `Package.swift` or `MoneyFlowLens.xcodeproj` in Xcode 15 on macOS 14.
2. Run the `MoneyFlowLens` scheme to launch the app.
3. Run the test suite with ⌘U.

A GitHub Actions workflow is included that runs unit tests and archives the app on macOS runners.
