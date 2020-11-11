//
//  Redux.swift
//  Redux
//
//  Created by Andrei Chevozerov on 11/10/20.
//

import Combine
import Foundation

typealias Reducer<S: ReduxState, Environment> = (inout S, ReduxAction, Environment) -> AnyPublisher<ReduxAction, Never>

protocol ReduxAction {}
protocol ReduxState {}

final class Store<S: ReduxState, Env>: ObservableObject {
    @Published private (set) var state: S

    private let reducer: Reducer<S, Env>
    private let environment: Env
    private var bagOfEffects: Set<AnyCancellable> = []

    init(initialState: S, reducer: @escaping Reducer<S, Env>, environment: Env) {
        self.state = initialState
        self.reducer = reducer
        self.environment = environment
    }

    func dispatch(action: ReduxAction) {
        reducer(&state, action, environment)
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: dispatch)
            .store(in: &bagOfEffects)
    }
}
