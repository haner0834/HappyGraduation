//
//  BirthdayCard.swift
//  楊昀恩生日欸
//
//  Created by Andy Lin on 2024/2/4.
//

import SwiftUI

struct BirthdayCard: View {
    @State private var flapHeight: CGFloat = 113
    @State private var stayTime = 0
    @State private var tapTimes: Int = 0
    @Binding var isTapped: Bool
    let isNonsenceEnabled: Bool
    
    let graduationDate = DateComponents(year: 2024, month: 5, day: 30, hour: 0, minute: 0, second: 0)
    
    init(isTapped: Binding<Bool>, isNonsenceEnabled: Bool = true) {
        _isTapped = isTapped
        self.isNonsenceEnabled = isNonsenceEnabled
    }
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    let card = CardContext()
    
    var body: some View {
        VStack {
            if tapTimes > 0 && tapTimes - 1 < card.cardNonsense.count {
                Text(card.cardNonsense[tapTimes - 1].text)
                    .clockTextAnimation()
            }
            
            BirthdayCardView(flapHeight: flapHeight)
            .onTapGesture(perform: openEvenlope)
            .opacity(isTapped ? 0: 1)
            
            if Int(stayTime / 3) % 2 == 1 && isNonsenceEnabled {
                HStack {
                    Image(systemName: "hand.tap.fill")
                    
                    Text("Tap the evenlope to see more")
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.background)
        .foregroundStyle(Color.black)
        .onTapGesture {
            withAnimation {
                tapTimes += 1
                if tapTimes > card.cardNonsense.count {
                    openEvenlope()
                }
            }
        }
        .onReceive(timer) { _ in
            ///bruh why when I tap the screen to add value of `tapTimes`, it stop counting ???
            withAnimation {
                stayTime += 1
            }
        }
    }
    
    func openEvenlope() {
        withAnimation(.easeInOut(duration: 0.7)) {
            flapHeight = -113
        }
        withAnimation(.easeIn.delay(0.3)) {
            isTapped = true
        }
    }
}

#Preview {
    BirthdayCard(isTapped: .constant(false))
}

#Preview {
    ContentView()
        .environmentObject(GlobalViewModel())
}

struct EvenlopeFlap: View, Animatable {
    var height: CGFloat = 113
    
    init(height: CGFloat = 172) {
        self.height = height
    }
    
    var animatableData: CGFloat {
        get { height }
        set { height = newValue }
    }
    
    var body: some View {
        ZStack {
            Path { path in
                path.move(to: CGPoint(x: 24, y: 24))
                path.addLine(to: CGPoint(x: 172, y: height))
                path.addLine(to: CGPoint(x: 330, y: 24))
                
                path.addLine(to: CGPoint(x: 325, y: 20))
                path.addLine(to: CGPoint(x: 312, y: 17))
                
                path.addLine(to: CGPoint(x: 37, y: 17))
                path.addLine(to: CGPoint(x: 29, y: 20))
            }
            .fill(Color(red: 0.852, green: 0.725, blue: 0.551))
            
            Path { path in
                path.move(to: CGPoint(x: 24, y: 24))
                path.addLine(to: CGPoint(x: 172, y: height))
                path.addLine(to: CGPoint(x: 330, y: 24))
            }
            .stroke(lineWidth: 1)
        }
    }
}

struct BirthdayCardView: View {
    let flapHeight: CGFloat
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25.0)
                .padding()
                .foregroundStyle(Color(red: 0.852, green: 0.725, blue: 0.551))
            
            RoundedRectangle(cornerRadius: 25.0)
                .stroke(lineWidth: 1)
                .padding()
            
            ZStack {
                Path { path in
                    path.move(to: CGPoint(x: 24, y: 24))
                    path.addLine(to: CGPoint(x: 74, y: 54))
                    path.addLine(to: CGPoint(x: 275, y: 54))
                    path.addLine(to: CGPoint(x: 330, y: 24))
                }
                .fill(Color.white)
                
                EvenlopeFlap(height: flapHeight)
            }
            
            Image(.donaldDuck)
                .resizable()
                .frame(width: 100, height: 100)
                .clipShape(Circle())
                .padding(30)
                .rotationEffect(.degrees(-32))
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
        }
        .frame(width: 354, height: 260)
    }
}
