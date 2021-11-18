//
//  Redux2App.swift
//  Shared
//
//  Created by Andrei Chevozerov on 15.11.2021.
//

import SwiftUI

@main
struct Redux2App: App {

    @Environment(\.scenePhase) private var scenePhase

    private let store = AppStore(
        initial: AppState(),
        reducer: AppStore.reducer,
        environment: World()
    )

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(store)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .onChange(of: scenePhase) { phase in
                    switch phase {
                    case .background, .inactive:
                        Task {
                            try? await store.send(.deactivated)
                        }
                    case .active:
                        Task {
                            try? await store.send(.activated)
                        }
                    @unknown default:
                        print("unknown scene phase")
                    }
                }
        }
    }
}
