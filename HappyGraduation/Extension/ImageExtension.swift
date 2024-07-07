//
//  ImageExtension.swift
//  HappyGraduation
//
//  Created by Andy Lin on 2024/7/6.
//

import Foundation
import SwiftUI

extension Image {
    @ViewBuilder
    func customStyle(perform: @escaping () -> Void) -> some View {
        self
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(maxWidth: 400)
            .clipShape(RoundedRectangle(cornerRadius: 16.0))
            .padding(.horizontal)
            .onTapGesture(perform: perform)
    }
}

