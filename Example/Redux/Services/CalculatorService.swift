//
//  CalculatorService.swift
//  Redux
//
//  Created by Andrei Chevozerov on 11/11/20.
//

actor CalculatorService {
    func run(with value: Int) async throws -> Int {
        try await Task.sleep(nanoseconds: 3_000_000_000)
        return value * 2
    }
}
