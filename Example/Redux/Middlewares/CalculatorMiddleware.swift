//
//  CalculatorMiddleware.swift
//  Redux
//
//  Created by Andrei Chevozerov on 11/11/20.
//

import Foundation
import Combine

final class CalculatorMiddleware {
    private let service: CalculatorService = CalculatorService()
    private var bag: Set<AnyCancellable> = []

    func execute(state: AppState, action: ReduxAction, dispatch: @escaping Dispatcher) {
        guard let action = action as? MainAction, case .calculate = action else { return }

        service.run(with: state.counter)
            .map(MainAction.setResult)
            .sink(receiveValue: dispatch)
            .store(in: &bag)
    }
}
