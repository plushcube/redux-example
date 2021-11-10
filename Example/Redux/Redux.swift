//
//  Redux.swift
//  Redux
//
//  Created by Andrei Chevozerov on 11/10/20.
//

import Combine
import Foundation

typealias SideEffect = AnyPublisher<ReduxAction, Never>
typealias Reducer<S: ReduxState, Env> = (inout S, ReduxAction, Env) -> SideEffect?

protocol ReduxAction {}
protocol ReduxState: Equatable {}

final class ReduxStore<S: ReduxState, World>: ObservableObject {
    @Published private (set) var state: S

    private let reduce: (inout S, ReduxAction) -> SideEffect?
    private let queue: DispatchQueue
    private var bagOfEffects: [UUID: AnyCancellable] = [:]

    init<Env>(initial state: S, reducer: @escaping Reducer<S, Env>, world: Env, queue: DispatchQueue = .init(label: "com.plushcube.store")) {
        self.state = state
        self.queue = queue
        self.reduce = { state, action in
            reducer(&state, action, world)
        }
    }

    func send(_ action: ReduxAction) {
        guard let effect = reduce(&state, action) else { return }

        var didComplete = false
        let uuid = UUID()

        let cancellable = effect
            .subscribe(on: queue)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] _ in
                    didComplete = true
                    self?.bagOfEffects[uuid] = nil
                },
                receiveValue: { [weak self] in self?.send($0) }
            )

        if !didComplete {
            bagOfEffects[uuid] = cancellable
        }
    }

    func send(actions: ReduxAction..., after interval: TimeInterval = 0.0) {
        queue.asyncAfter(deadline: .now() + interval) { [weak self] in
            guard let self = self else { return }
            actions.forEach(self.send)
        }
    }
}

extension SideEffect {
    static func dispatch(action: ReduxAction) -> SideEffect {
        Just(action).eraseToAnyPublisher()
    }
}
