# 💸 MoneyFlowLens

**MoneyFlowLens** is a macOS (SwiftUI + SwiftData) desktop app that helps financial‐advisors—or anyone who manages multi-account households—visualise cash-flow with a clean, multi-column Sankey diagram.

| Build status | Minimum macOS | Xcode | Swift |
|-------------|---------------|-------|-------|
| ![CI](https://img.shields.io/github/actions/workflow/status/ lukemad/moneyflowlens/macos.yml?label=CI) | 14 (Sonoma) | 15.4 | 5.10 |

---

## ✨ Key features

* **Client manager** – keep multiple households side-by-side.
* **Income & Expense items** – quick add, edit, delete.
* **Auto-categorisation** – rule-based tags for overhead, savings, investing, discretionary.
* **Live Sankey chart** – powered by the open-source `Sankey` Swift package.
* **SwiftData storage** – everything saved locally in an encrypted SQLite store (FileVault-compatible).

---

## 🖥 Screenshots

> *Coming soon – feel free to submit a PR with screenshots!*

---

## 🚀 Quick start

### 🍏 Option 1 – Download the nightly DMG

1. Go to **Actions ▸ CI** → pick the latest green run.
2. Download **MoneyFlowLens.dmg** from *Artifacts*.
3. Drag **MoneyFlowLens.app** into `/Applications`, open, and start adding clients.

### 🛠 Option 2 – Build from source

```bash
git clone https://github.com/lukemad/moneyflowlens.git
cd moneyflowlens
open MoneyFlowLens.xcodeproj   # ⌘R to run
