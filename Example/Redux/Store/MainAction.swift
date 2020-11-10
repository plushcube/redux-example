//
//  MainAction.swift
//  Redux
//
//  Created by Andrei Chevozerov on 11/11/20.
//

enum MainAction: ReduxAction {
    case increment
    case calculate
    case setResult(Int)
}

extension AppReducer {
    static func mainReducer(state: AppState, action: MainAction) -> AppState {
        var state = state

        switch action {
        case .increment:
            state.counter += 1

        case .calculate:
            state.isCalculating = true

        case let .setResult(result):
            state.counter = result
            state.isCalculating = false
        }

        return state
    }
}
