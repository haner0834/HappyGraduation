//
//  WelcomePage.swift
//  HappyGraduation
//
//  Created by Andy Lin on 2024/7/1.
//

import Foundation
import SwiftUI

struct WelcomePage: View {
    @Binding var isShow: Bool
    
    @State private var isButtonAvailable = false
    @State private var text = ""
    let greeting = "No matter how tough study gets, just keep going and never give up.\nStick with it and let time prove the result."
    
    var body: some View {
        VStack {
            Spacer()
            
            Text("Happy Graduation :D")
                .font(.title2)
                .bold()
                .fontDesign(.serif)
            
            Image(.capipala)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 200, height: 200)
            
            Text(text)
                .font(.title3)
                .fontDesign(.serif)
                .multilineTextAlignment(.center)
                .padding()
            
            Spacer()
            
            Button {
                withAnimation {
                    isShow = false
                }
            } label: {
                Text("繼續")
                    .padding(20)
                    .frame(maxWidth: .infinity)
                    .background(Color.dark)
                    .foregroundColor(.white)
                    .clipShape(.rect(cornerRadius: 25))
                    .padding(20)
                    .bold()
            }
            .disabled(!isButtonAvailable)
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    processTextAppear()
                }
            }
        }
    }
    
    func processTextAppear() {
        let dispatchGroup = DispatchGroup()
        for (i, char) in greeting.enumerated() {
            dispatchGroup.enter()
            DispatchQueue.main.asyncAfter(deadline: .now() + getTimeDelay(i)) {
                text += String(char)
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.notify(queue: DispatchQueue.main) {
            isButtonAvailable = true
        }
    }
    
    func processTextDisappear() {
        for i in 0..<text.count {
            DispatchQueue.main.asyncAfter(deadline: .now() + (Double(i) * 0.01)) {
                text.removeLast()
            }
        }
    }
    
    func getTimeDelay(_ i: Int) -> Double {
        return Double(i) * 0.02 * max(Double(i) * 0.015, 1)
    }
}

#Preview {
    WelcomePage(isShow: .constant(true))
        .ignoresSafeArea()
}
