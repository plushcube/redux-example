//
//  ContentView.swift
//  Redux
//
//  Created by Andrei Chevozerov on 11/11/20.
//

import SwiftUI

struct ContentView: View {

    @EnvironmentObject private var store: AppStore

    var body: some View {
        VStack {
            if store.state.isCalculating {
                Text("Calculating...")
            } else {
                Text("Counter is \(store.state.counter)")
            }
            Button("Increment") {
                store.send(MainAction.increment)
            }
            Button("Calculate") {
                store.send(MainAction.calculate)
            }
            Button(store.state.isCounting ? "Stop countdown" : "Run countdown") {
                store.send(MainAction.toggleCountdown(!store.state.isCounting))
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(
                AppStore(
                    initial: AppState(),
                    reducer: AppReducer.reducer,
                    world: World()
                )
            )
    }
}
