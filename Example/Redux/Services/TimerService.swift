//
//  TimerService.swift
//  Redux
//
//  Created by Andrei Chevozerov on 12.02.2021.
//

import Foundation

final class TimerService {
    private var timer: Timer?

    func countdown(step: Double, from: Double) async -> AsyncStream<Double> {
        timer?.invalidate()
        let start = CFAbsoluteTimeGetCurrent()
        let ticks = AsyncStream(Double.self) { conti in
            timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
                let time = CFAbsoluteTimeGetCurrent()
                if time - start >= step {
                    let next = max(from - step, 0.0)
                    conti.yield(next)
                    if abs(next) < 0.001 {
                        conti.finish()
                        timer.invalidate()
                    }
                }
            }
        }
        return ticks
    }
}
