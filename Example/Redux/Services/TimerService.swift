//
//  TimerService.swift
//  Redux
//
//  Created by Andrei Chevozerov on 12.02.2021.
//

import Foundation
import Combine

final class TimerService {
    private let start = CFAbsoluteTimeGetCurrent()

    func tick(seconds: Int, from: Int) -> AnyPublisher<Int, Never> {
        return Future { promise in
            Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true) { timer in
                let time = CFAbsoluteTimeGetCurrent()
                if time - self.start >= Double(seconds) {
                    promise(.success(from - seconds))
                    timer.invalidate()
                }
            }
        }
        .eraseToAnyPublisher()
    }
}
