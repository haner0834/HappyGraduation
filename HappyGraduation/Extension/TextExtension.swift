//
//  TextExtension.swift
//  HappyGraduation
//
//  Created by Andy Lin on 2024/7/6.
//

import Foundation
import SwiftUI

extension Text {
    @ViewBuilder
    func cardTextStylye(isBack: Bool) -> some View {
        self
            .font(.title)
            .bold()
            .transition(
                .asymmetric(
                    insertion: .move(edge: isBack ? .top: .bottom).combined(with: .opacity),
                    removal: .move(edge: isBack ? .bottom: .top).combined(with: .opacity))
            )
            .multilineTextAlignment(.center)
            .lineSpacing(2)
    }
}
