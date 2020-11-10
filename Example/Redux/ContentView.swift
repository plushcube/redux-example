//
//  ContentView.swift
//  Redux
//
//  Created by Andrei Chevozerov on 11/11/20.
//

import SwiftUI

struct ContentView: View {

    @EnvironmentObject private var store: Store<AppState>

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
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(
                Store(state: AppState(), reducer: AppReducer.reducer)
            )
    }
}
