//
//  CalculatorService.swift
//  Redux
//
//  Created by Andrei Chevozerov on 11/11/20.
//

import Foundation
import Combine

final class CalculatorService {
    func run(with value: Int) -> AnyPublisher<Int, Never> {
        Future { promise in
            DispatchQueue.global().asyncAfter(deadline: .now() + 3.0) {
                promise(.success(value * 2))
            }
        }
        .eraseToAnyPublisher()
    }
}
