//
//  TimerStore.swift
//  Redux2
//
//  Created by Andrei Chevozerov on 18.11.2021.
//

enum TimerAction: ReduxAction {
    case runCountdown
    case setTimer(Double)
    case stopCountdown
    case timerTick
}

struct TimerState: ReduxState {
    enum State {
        case idle
        case isRunning
        case isStopping
    }

    var timer: Double
    var state: State
}

typealias TimerStore = ReduxStore<TimerState, TimerAction, World>

extension TimerStore {
    static let reducer = Reducer<TimerState, TimerAction, World> { state, action, world in
        switch action {
        case .runCountdown:
            state.state = .isRunning
        case .setTimer(let value):
            state.timer = value
        case .stopCountdown:
            state.state = .isStopping
        case .timerTick:
            print("tick")
        }
        return nil
    }
}
