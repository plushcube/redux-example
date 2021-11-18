//
//  Counter.swift
//  Redux2
//
//  Created by Andrei Chevozerov on 18.11.2021.
//

enum CounterAction: ReduxAction {
    case increase
    case decrease
    case reset
}

struct CounterState: ReduxState {
    var value: Int
}

typealias CounterStore = ReduxStore<CounterState, CounterAction, World>

extension CounterStore {
    static let reducer = Reducer<CounterState, CounterAction, World> { state, action, world in
        switch action {
        case .increase:
            state.value += 1
        case .decrease:
            state.value -= 1
        case .reset:
            state.value = 0
        }
        print("\(state.value)")
        return nil
    }
}
