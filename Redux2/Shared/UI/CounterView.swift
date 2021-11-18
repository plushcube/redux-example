//
//  CounterView.swift
//  Redux2
//
//  Created by Andrei Chevozerov on 18.11.2021.
//

import SwiftUI

struct CounterView: View {
    @EnvironmentObject private var store: CounterStore

    var body: some View {
        VStack {
            Text("\(store.state.value)")
                .font(.title2)
            HStack {
                Button {
                    Task { try? await store.send(.increase) }
                } label: { Image(systemName: "plus.circle") }

                Button {
                    Task { try? await store.send(.reset) }
                } label: { Image(systemName: "xmark.circle") }

                Button {
                    Task { try? await store.send(.decrease) }
                } label: { Image(systemName: "minus.circle") }
            }
        }
    }
}

struct CounterView_Previews: PreviewProvider {
    static var previews: some View {
        CounterView()
    }
}
