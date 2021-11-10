//
//  CounterAction.swift
//  Redux
//
//  Created by Andrei Chevozerov on 10.11.2021.
//

import Foundation

enum CounterAction: ReduxAction {
    case startCountdown
    case tickCountdown(Int)
    case finishCountdown(Int)
    case stopCountdown
}

extension AppReducer {
    static func counterReducer(state: inout AppState, action: CounterAction, environment: World) -> SideEffect? {
        switch action {
        case .startCountdown:
            state.isCounting = true
            return .dispatch(action: CounterAction.tickCountdown(state.counter))

        case let .tickCountdown(value):
            guard state.isCounting else { return nil }
            state.counter = value
            return environment.timer().tick(seconds: 1, from: value)
                .map { $0 == 0 ? CounterAction.finishCountdown($0) : CounterAction.tickCountdown($0) }
                .eraseToAnyPublisher()

        case let .finishCountdown(value):
            if state.isCounting {
                state.counter = value
                state.isCounting = false
            }

        case .stopCountdown:
            state.isCounting = false
        }
        return nil
    }
}
