//
//  ReduxApp.swift
//  Redux
//
//  Created by Andrei Chevozerov on 11/11/20.
//

import SwiftUI

@main
struct ReduxApp: App {
    private let store = ReduxStore(
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
