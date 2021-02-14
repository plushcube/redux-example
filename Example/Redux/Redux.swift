//
//  Redux.swift
//  Redux
//
//  Created by Andrei Chevozerov on 11/10/20.
//

import Combine
import Foundation

typealias SideEffect = AnyPublisher<ReduxAction, Never>
typealias Reducer<S: ReduxState, World> = (inout S, ReduxAction, World) -> SideEffect

protocol ReduxAction {}
protocol ReduxState: Equatable {}

final class ReduxStore<S: ReduxState, World>: ObservableObject {
    @Published private (set) var state: S

    private let reducer: Reducer<S, World>
    private let environment: World
    private var bagOfEffects: Set<AnyCancellable> = []

    init(initial state: S, reducer: @escaping Reducer<S, World>, world: World) {
        self.state = state
        self.reducer = reducer
        self.environment = world
    }

    func dispatch(action: ReduxAction) {
        reducer(&state, action, environment)
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: dispatch)
            .store(in: &bagOfEffects)
    }
}

extension SideEffect {
    static let void: SideEffect = Empty().eraseToAnyPublisher()

    static func dispatch(action: ReduxAction) -> SideEffect {
        Just(action).eraseToAnyPublisher()
    }
}
