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

enum CounterAction: ReduxAction {
    case startCountdown
    case tickCountdown(Int)
    case finishCountdown(Int)
    case stopCountdown
}

extension AppReducer {
    static func mainReducer(state: inout AppState, action: MainAction, environment: World) -> SideEffect {
        switch action {
        case .increment:
            state.counter += 1
            return .void

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
            return .void
        }
    }

    static func counterReducer(state: inout AppState, action: CounterAction, environment: World) -> SideEffect {
        switch action {
        case .startCountdown:
            state.isCounting = true
            return .dispatch(action: CounterAction.tickCountdown(state.counter))

        case let .tickCountdown(value):
            guard state.isCounting else { return .void }
            state.counter = value
            return environment.timer().tick(seconds: 1, from: value)
                .map { $0 == 0 ? CounterAction.finishCountdown($0) : CounterAction.tickCountdown($0) }
                .eraseToAnyPublisher()

        case let .finishCountdown(value):
            if state.isCounting {
                state.counter = value
                state.isCounting = false
            }
            return .void

        case .stopCountdown:
            state.isCounting = false
            return .void
        }
    }
}
