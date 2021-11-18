//
//  ContentView.swift
//  Shared
//
//  Created by Andrei Chevozerov on 15.11.2021.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var store: AppStore

    private var counterStore: CounterStore {
        store.derived(deriveState: \.counter, reducer: CounterStore.reducer)
    }

    private var timerStore: TimerStore {
        store.derived(deriveState: \.timer, reducer: TimerStore.reducer)
    }

    var body: some View {
        VStack {
            Text("\(store.state.counter.value)")
            Divider()
            CounterView()
                .environmentObject(counterStore)
            Divider()
            TimerView()
                .environmentObject(timerStore)
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
