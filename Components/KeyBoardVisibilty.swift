//
//  KeyBoardVisibilty.swift
//  34MLTask
//
//  Created by Moustafa Mohamed Gadallah on 12/12/1446 AH.
//

import SwiftUI
import Combine

final class KeyboardResponder: ObservableObject {
    @Published var isKeyboardVisible: Bool = false
    private var cancellable: AnyCancellable?

    init() {
        cancellable = Publishers.Merge(
            NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)
                .map { _ in true },
            NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)
                .map { _ in false }
        )
        .receive(on: RunLoop.main)
        .assign(to: \.isKeyboardVisible, on: self)
    }

    deinit {
        cancellable?.cancel()
    }
}
