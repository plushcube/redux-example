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
    case setResult(Int)
}

extension AppReducer {
    static func mainReducer(state: inout AppState, action: MainAction, environment: World) -> AnyPublisher<ReduxAction, Never> {
        switch action {
        case .increment:
            state.counter += 1

        case .calculate:
            state.isCalculating = true
            return environment.calculator.run(with: state.counter)
                .map { MainAction.setResult($0) }
                .eraseToAnyPublisher()

        case let .setResult(result):
            state.counter = result
            state.isCalculating = false
        }
        return Empty(completeImmediately: true)
            .eraseToAnyPublisher()
    }
}
