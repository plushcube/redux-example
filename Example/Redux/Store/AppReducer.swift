//
//  AppReducer.swift
//  Redux
//
//  Created by Andrei Chevozerov on 11/11/20.
//

import Combine

enum AppReducer {
    static func reducer(state: inout AppState, action: ReduxAction, environment: World) -> AnyPublisher<ReduxAction, Never>? {
        switch action {
        case let main as MainAction:
            return mainReducer(state: &state, action: main, environment: environment)
        default:
            return nil
        }
    }
}
