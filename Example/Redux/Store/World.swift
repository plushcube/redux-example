//
//  World.swift
//  Redux
//
//  Created by Andrei Chevozerov on 11/11/20.
//

struct World {
    let calculator = CalculatorService()
    func timer() -> TimerService { TimerService() }
}
