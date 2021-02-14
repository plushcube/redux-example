//
//  ContentView.swift
//  Redux
//
//  Created by Andrei Chevozerov on 11/11/20.
//

import SwiftUI

struct ContentView: View {

    @EnvironmentObject private var store: ReduxStore<AppState, World>

    var body: some View {
        VStack {
            if store.state.isCalculating {
                Text("Calculating...")
            } else {
                Text("Counter is \(store.state.counter)")
            }
            Button("Increment") {
                store.dispatch(action: MainAction.increment)
            }
            Button("Calculate") {
                store.dispatch(action: MainAction.calculate)
            }
            Button(store.state.isCounting ? "Stop countdown" : "Run countdown") {
                store.dispatch(action: MainAction.toggleCountdown(!store.state.isCounting))
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(
                ReduxStore(
                    initial: AppState(),
                    reducer: AppReducer.reducer,
                    world: World()
                )
            )
    }
}
