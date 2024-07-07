//
//  OpenableBook.swift
//  楊昀恩生日欸
//
//  Created by Andy Lin on 2024/4/16.
//

import Foundation
import SwiftUI

struct OpenableBook<FrontLeft: View, Front: View, InsideLeft: View, InsideRight: View>: View, Animatable {
    var configuration: Configuration = .init()
    
    @ViewBuilder var frontLeft: (CGSize) -> FrontLeft
    @ViewBuilder var front: (CGSize) -> Front
    @ViewBuilder var insideLeft: (CGSize) -> InsideLeft
    @ViewBuilder var insideRight: (CGSize) -> InsideRight
    
    var animatableData: CGFloat {
        get { configuration.progress }
        set { configuration.progress = newValue }
    }
    
    var body: some View {
        GeometryReader {
            let size = $0.size
            ///Limit the progress 0 to 1
            let progress = max(min(configuration.progress, 1), 0)
            ///A constant that multiplying `progress` and -180(because progress is limited 0 to 1, and `rotation` is for 3D rotation angle)
            let rotation = progress * -180
            let cornerRadius = configuration.cornerRadius
            let shadowColor = configuration.shadowColor
            
            ZStack {
                frontLeft(size)
                    .frame(width: size.width, height: size.height)
                    .clipShape(
                        .rect(
                            topLeadingRadius: cornerRadius,
                            bottomLeadingRadius: cornerRadius,
                            bottomTrailingRadius: 0,
                            topTrailingRadius: 0)
                    )
                    .transition(.identity)
                    .shadow(color: shadowColor.opacity(0.1), radius: 5, x: 5, y: 0)
                    .scaleEffect(x: -1)
                    .rotation3DEffect(
                        .init(degrees: 180),
                        axis: (x: 0.0, y: 1.0, z: 0.0),
                        anchor: .leading,
                        perspective: 0.4
                    )
                
                insideRight(size)
                    .frame(width: size.width, height: size.height)
                    .clipShape(.rect(bottomTrailingRadius: cornerRadius, topTrailingRadius: cornerRadius))
                    .shadow(color: shadowColor.opacity(0.1 * progress), radius: 5, x: 5, y: 5)
                    .overlay(alignment: .leading) {
                        Rectangle()
                            .fill(configuration.dividerBackground.shadow(.inner(color: shadowColor.opacity(0.15), radius: 5)))
                            .frame(width: 6)
                            .offset(x: -3)
                            .clipped()
                    }
                
                front(size)
                    .frame(width: size.width, height: size.height)
                    .overlay {
                        ///Show the `InsideLeft` view when the page has been flip
                        if -rotation > 90 {
                            insideLeft(size)
                                .frame(width: size.width, height: size.height)
                                .scaleEffect(x: -1)
                                .transition(.identity)
                        }
                    }
                    .clipShape(.rect(bottomTrailingRadius: cornerRadius, topTrailingRadius: cornerRadius))
                    .shadow(color: shadowColor.opacity(0.1), radius: 5, x: 5, y: 0)
                    .rotation3DEffect(
                        .init(degrees: rotation),
                        axis: (x: 0.0, y: 1.0, z: 0.0),
                        anchor: .leading,
                        perspective: 0.4
                    )
            }
            .offset(x: configuration.width * progress + configuration.viewOffset)
        }
        .frame(width: configuration.width, height: configuration.height)
    }
    
    struct Configuration {
        var width: CGFloat = 300
        var height: CGFloat = 450
        var progress: CGFloat = 0
        var cornerRadius: CGFloat = 16
        var shadowColor: Color = .black
        var dividerBackground: Color = .white
        var viewOffset: CGFloat = 0
    }
}

#Preview {
    BookView()
}
