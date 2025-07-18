//
//  DiscogsExplorerApp.swift
//  DiscogsExplorer
//
//  Created by Daniel Garcia on 16/07/25.
//

import SwiftUI

@main
struct DiscogsExplorerApp: App {
    var body: some Scene {
        WindowGroup {
            let factory = ViewModelFactory()
            SearchView(viewModel: factory.makeSearchViewModel())
        }
    }
}
