//
//  Redux.swift
//  Redux
//
//  Created by Andrei Chevozerov on 18.11.2021.
//

import Foundation
import Combine

protocol ReduxAction {}
protocol ReduxState: Equatable {}

final class ReduxStore<S: ReduxState, A: ReduxAction, E>: ObservableObject {
    @Published private (set) var state: S

    private let reduce: (inout S, A) async throws -> A?
    private let world: E

    init(initial state: S, reducer: Reducer<S, A, E>, environment: E) {
        self.state = state
        self.world = environment
        self.reduce = { state, action in
            try await reducer(&state, action, environment)
        }
    }

    @MainActor func update(state updated: S) {
        state = updated
    }

    @MainActor func update<DS: ReduxState>(substate keyPath: WritableKeyPath<S, DS>, with value: DS) {
        state[keyPath: keyPath] = value
    }

    func send(_ actions: A..., after delay: TimeInterval = 0.0) async throws {
        if delay > 0.0 {
            try await Task.sleep(nanoseconds: UInt64(delay * 1_000_000))
        }
        for action in actions {
            var updated = state
            let result = try await reduce(&updated, action)
            await update(state: updated)
            if let next = result {
                try await send(next)
            }
        }
    }

    func send(global action: ReduxAction) async throws {
        if let own = action as? A {
            try await send(own)
            return
        }
        try await sendToParent(action)
    }

    private var bag: Set<AnyCancellable> = []
    private var sendToParent: (ReduxAction) async throws -> Void = { _ in }

    func derived<DS: ReduxState, DA: ReduxAction>(
        _ keyPath: WritableKeyPath<S, DS>,
        reducer: Reducer<DS, DA, E>
    ) -> ReduxStore<DS, DA, E> {
        let ds = ReduxStore<DS, DA, E>(
            initial: state[keyPath: keyPath],
            reducer: reducer,
            environment: world)
        ds.$state
            .removeDuplicates()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] value in
                guard let self = self, self.state[keyPath: keyPath] != value else { return }
                Task {
                    await self.update(substate: keyPath, with: value)
                }
            }
            .store(in: &bag)
        ds.sendToParent = send(global:)
        $state
            .map(keyPath)
            .removeDuplicates()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] value in
                guard self?.state[keyPath: keyPath] != value else { return }
                Task {
                    await ds.update(state: value)
                }
            }
            .store(in: &bag)
        return ds
    }
}

struct Reducer<S: ReduxState, A: ReduxAction, E> {
    let reduce: (inout S, A, E) async throws -> A?

    func callAsFunction(_ state: inout S, _ action: A, _ environment: E) async throws -> A? {
        try await reduce(&state, action, environment)
    }
}
