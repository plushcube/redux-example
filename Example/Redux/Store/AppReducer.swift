//
//  AppReducer.swift
//  Redux
//
//  Created by Andrei Chevozerov on 11/11/20.
//

enum AppReducer {
    static func reducer(state: inout AppState, action: ReduxAction, environment: World) -> SideEffect? {
        switch action {
        case let main as MainAction:
            return mainReducer(state: &state, action: main, environment: environment)
        case let counter as CounterAction:
            return counterReducer(state: &state, action: counter, environment: environment)
        default:
            return nil
        }
    }
}
