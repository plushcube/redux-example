//
//  MainAction.swift
//  Redux
//
//  Created by Andrei Chevozerov on 11/11/20.
//

import Combine

enum MainAction: ReduxAction {
    case increment
    case calculate
    case toggleCountdown(Bool)
    case setResult(Int)
}

extension AppReducer {
    static func mainReducer(state: inout AppState, action: MainAction, environment: World) -> SideEffect? {
        switch action {
        case .increment:
            state.counter += 1

        case .calculate:
            state.isCalculating = true
            return environment.calculator.run(with: state.counter)
                .map { MainAction.setResult($0) }
                .eraseToAnyPublisher()

        case let .toggleCountdown(run):
            return .dispatch(action: run ? CounterAction.startCountdown : CounterAction.stopCountdown)

        case let .setResult(result):
            state.counter = result
            state.isCalculating = false
        }
        return nil
    }
}
