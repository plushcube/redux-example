//
//  AppReducer.swift
//  Redux
//
//  Created by Andrei Chevozerov on 11/11/20.
//

enum AppReducer {
    static func reducer(state: AppState, action: ReduxAction) -> AppState {
        switch action {
        case let main as MainAction:
            return mainReducer(state: state, action: main)
        default:
            return state
        }
    }
}
