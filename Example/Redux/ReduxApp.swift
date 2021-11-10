//
//  ReduxApp.swift
//  Redux
//
//  Created by Andrei Chevozerov on 11/11/20.
//

import SwiftUI

typealias AppStore = ReduxStore<AppState, World>

@main
struct ReduxApp: App {
    private let store = AppStore(
        initial: AppState(),
        reducer: AppReducer.reducer,
        world: World()
    )

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(store)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}
