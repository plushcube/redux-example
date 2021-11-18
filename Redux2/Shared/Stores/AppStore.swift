//
//  AppStore.swift
//  Redux2
//
//  Created by Andrei Chevozerov on 18.11.2021.
//

enum AppAction: ReduxAction {
    case activated
    case deactivated
    case updated
}

struct AppState: ReduxState {
    var counter: CounterState = .init(value: 0)
    var timer: TimerState = .init(timer: 0, state: .idle)
}

typealias AppStore = ReduxStore<AppState, AppAction, World>

extension AppStore {
    static let reducer = Reducer<AppState, AppAction, World> { state, action, env in
        switch action {
        case .activated:
            print("activated")
        case .deactivated:
            print("activated")
        case .updated:
            print("updated")
        }
        return nil
    }
}
