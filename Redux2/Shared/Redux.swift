//
//  Redux.swift
//  Redux2
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

    private var bag: Set<AnyCancellable> = []       // TODO: Get rid of it.

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

    func derived<DS: ReduxState, EA: ReduxAction>(
        deriveState: @escaping (S) -> DS,
        reducer: Reducer<DS, EA, E>
    ) -> ReduxStore<DS, EA, E> {
        let ds = ReduxStore<DS, EA, E>(
            initial: deriveState(state),
            reducer: reducer,
            environment: world)

        // TODO: Update parent store state on derived change

        // TODO: Find a way how to do it more gracefully
        $state
            .map(deriveState)
            .removeDuplicates()
            .sink { value in
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
