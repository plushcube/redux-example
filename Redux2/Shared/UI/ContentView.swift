//
//  ContentView.swift
//  Shared
//
//  Created by Andrei Chevozerov on 15.11.2021.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var store: AppStore

    var body: some View {
        VStack {
            Text("\(store.state.counter.value)")
            Divider()
            CounterView()
                .environmentObject(store.derived(\.counter, reducer: CounterStore.reducer))
            Divider()
            TimerView()
                .environmentObject(store.derived(\.timer, reducer: TimerStore.reducer))
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
