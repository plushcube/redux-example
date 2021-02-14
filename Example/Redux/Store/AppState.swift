//
//  AppState.swift
//  Redux
//
//  Created by Andrei Chevozerov on 11/10/20.
//

struct AppState: ReduxState {
    var counter = 0
    var isCalculating: Bool = false
    var isCounting: Bool = false
}
