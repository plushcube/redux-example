//
//  Redux.swift
//  Redux
//
//  Created by Andrei Chevozerov on 11/10/20.
//

import Combine
import Foundation

typealias Reducer<S: ReduxState> = (S, ReduxAction) -> S
typealias Dispatcher = (ReduxAction) -> Void
typealias Middleware<S: ReduxState> = (S, ReduxAction, @escaping Dispatcher) -> Void

protocol ReduxAction {}
protocol ReduxState {}

final class Store<S: ReduxState>: ObservableObject {
    @Published private (set) var state: S

    private let reducer: Reducer<S>
    private let middlewares: [Middleware<S>]

    init(state: S, middlewares: [Middleware<S>] = [], reducer: @escaping Reducer<S>) {
        self.state = state
        self.reducer = reducer
        self.middlewares = middlewares
    }

    func dispatch(action: ReduxAction) {
        DispatchQueue.main.async {
            self.state = self.reducer(self.state, action)
        }
        middlewares.forEach { mw in
            mw(state, action, dispatch)
        }
    }
}
