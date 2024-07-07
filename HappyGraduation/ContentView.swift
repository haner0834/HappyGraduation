//
//  ContentView.swift
//  HappyGraduation
//
//  Created by Andy Lin on 2024/6/29.
//

import SwiftUI

struct ContentView: View {
    @State private var isShowHomePage: Bool = true
    
    var body: some View {
        NavigationStack {
            VStack {
                if isShowHomePage {
                    WelcomePage(isShow: $isShowHomePage)
                        .transition(
                            .asymmetric(
                                insertion: .identity,
                                removal: .move(edge: .bottom)
                            )
                        )
                        .ignoresSafeArea()
                }else {
                    HomePage()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.background)
            .foregroundStyle(Color.dark)
            .persistentSystemOverlays(.hidden)
        }
    }
}

#Preview {
    ContentView()
}
