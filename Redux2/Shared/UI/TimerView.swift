//
//  TimerView.swift
//  Redux2
//
//  Created by Andrei Chevozerov on 18.11.2021.
//

import SwiftUI

struct TimerView: View {
    @EnvironmentObject private var store: TimerStore

    var body: some View {
        if store.state.state == .idle {
            Text("Timer is not set")
        } else {
            Text("\(Int(store.state.timer))")
        }
        Button(store.state.state == .idle ? "Run countdown" : "Stop countdown") {
            Task {
                try? await store.send(.runCountdown)
            }
        }
        .buttonStyle(.bordered)
        .disabled(store.state.state == .isStopping)
    }
}

struct TimerView_Previews: PreviewProvider {
    static var previews: some View {
        TimerView()
    }
}
