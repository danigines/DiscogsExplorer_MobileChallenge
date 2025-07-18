# 🎸 DiscogsExplorer

An iOS 17+ SwiftUI app to search and explore music artists, albums, and band members using the Discogs API.

## 🚀 Features

- Search artists by name
- View artist details and band members
- Browse artist's albums sorted by release date
- Filter albums by year, label, and genre
- Bonus: album detail view and tracklist (if implemented)

## 📱 Platform Requirements

- Minimum OS Version: iOS 17+
- Language: Swift
- UI Framework:SwiftUI
- Dependency Management: Swift Package Manager (SPM)

## 🛠 Setup Instructions

1. Clone this repository.
2. Open `DiscogsExplorer.xcodeproj` or `xcworkspace`.
3. Add your Discogs API token in `Environment.swift`.
4. Run the app using an iOS 17 simulator or device.

## 📐 Architecture

This app follows a **modular MVVM** structure

## ✅ Static Analysis

Using [SwiftLint](https://github.com/realm/SwiftLint) to enforce style and linting rules.

**1. Install SwiftLint**

If you have _Homebrew_, open your _Terminal_ and run:
```bash
brew install swiftlint
```
✅ Once installed, verify it with:
```bash
swiftlint version
```
You should see something like:
```bash
0.59.1
```
**2. Navigate to Your Project Directory**
```bash
cd /path/to/DiscogsExplorer
```
Or, if you're in the root of your repo:
```bash
cd DiscogsExplorer
```
**3.Run SwiftLint in the Console**

In the root of your project, run:
```bash
swiftlint
```
You’ll see output like:
```bash
Sources/ViewModels/SearchViewModel.swift:42:1: warning: Force Unwrapping Violation: Force unwrapping should be avoided. (force_unwrapping)
Tests/SearchViewModelTests.swift:15: warning: Line Length Violation: Line should be 120 characters or less (currently 134). (line_length)
```
These are warnings or errors based on your `.swiftlint.yml` file.
