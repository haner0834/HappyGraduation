//
//  OpenableBookView.swift
//  楊昀恩生日欸
//
//  Created by Andy Lin on 2024/4/17.
//

import Foundation
import SwiftUI

extension BookView {
    //MARK: Book Pages
    @ViewBuilder
    func LastPage(_ size: CGSize, text: [String] = ["好ㄉ恭喜你看完ㄌ", "感動ㄇ :D"], image: ImageResource = .icon) -> some View {
        VStack {
            if text.count >= 1 {
                Text(text[0])
                    .padding(.vertical)
                    .frame(maxWidth: .infinity)
                    .font(.title2)
                    .background(Color.background)
            }
            
            Spacer()
            
            Image(image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth: image == .icon ? 160: size.width * 0.8,
                       maxHeight: image == .icon ? 160: size.width * 0.8)
                .clipShape(.rect(cornerRadius: image == .icon ? 16: 7))
                .padding(.bottom, 10)
                .padding(image == .icon ? 0: 16)
            
            Spacer()
            
            if text.count >= 2 {
                Text(text[1])
                    .padding(.vertical)
                    .frame(maxWidth: .infinity)
                    .font(.title3)
                    .background(Color.background)
            }
        }
        .bold()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.accentColor)
    }
    
    @ViewBuilder
    func FrontLeftView(_ size: CGSize, content: CardContentItem? = nil, isBackCover: Bool = false) -> some View {
        if let content {
            VStack {
                Text(content.text)
                
                if let image = content.image {
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width:  100)
                }
            }
            .padding()
            .bold()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.background)
            .transition(.identity)
        }else if isBackCover {
            BackCoverPage()
        }else {
            EmptyView()
        }
    }
    
    @ViewBuilder
    func FrontView(_ size: CGSize, content: CardContentItem? = nil, isForFirstPage: Bool = true) -> some View {
        if let content {
            VStack(spacing: 5) {
                Text(content.text)
                
                if let image = content.image {
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: size.width * 0.75)
                        .clipShape(.rect(cornerRadius: 11))
                }
            }
            .padding()
            .bold()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.background)
        } else if isForFirstPage {
            CoverPage(size)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        } else {
            LastPage(size, text: [], image: .donaldDuck)
        }
    }
    
    @ViewBuilder
    func LeftView(_ size: CGSize, content: CardContentItem? = CardContentItem(text: "Hello!", image: Image(.donaldDuck)), isForLastPage: Bool = false) -> some View {
        if let content {
            VStack(spacing: 5) {
                Text(content.text)
                
                if let image = content.image {
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: size.width * 0.75)
                        .clipShape(.rect(cornerRadius: 11))
                }
            }
            .padding()
            .bold()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.background)
        }else if isForLastPage {
            BackCoverPage()
        }
    }
    
    @ViewBuilder
    func RightView(_ size: CGSize, content: CardContentItem? = CardContentItem(text: "Hello", image: Image(.donaldDuck)), isForLastPage: Bool = false) -> some View {
        if let content {
            VStack(spacing: 5) {
                Text(content.text)
                
                if let image = content.image {
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: size.width * 0.75)
                        .clipShape(.rect(cornerRadius: 11))
                }
            }
            .padding()
            .bold()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.background)
        }else if isForLastPage {
            LastPage(size, text: [], image: .donaldDuck)
        }else {
            EmptyView()
        }
    }
    
    //MARK: Overlay Buttons
    @ViewBuilder
    func BackBottom(_ action: @escaping () -> Void) -> some View {
        Button {
            action()
        } label: {
            Image(systemName: "chevron.left")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 12)
                .foregroundStyle(.white)
                .padding(13)
                .padding(.trailing, 4)
                .background(Color.black)
                .clipShape(Circle())
                .padding(10)
        }
    }
    
    @ViewBuilder
    func ContinueButton(_ action: @escaping () -> Void) -> some View {
        Button {
            action()
        } label: {
            Image(systemName: "chevron.right")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 12)
                .foregroundStyle(.white)
                .padding(13)
                .padding(.leading, 4)
                .background(Color.black)
                .clipShape(Circle())
                .padding(10)
        }
    }
    
    //MARK:
    @ViewBuilder
    func OverlayButtons(disabled: Bool, continueAction: @escaping () -> Void, backAction: @escaping () -> Void) -> some View {
        HStack {
            BackBottom() {
                backAction()
            }
            
            Spacer()
            
            ContinueButton {
                continueAction()
            }
        }
        .bold()
        .disabled(disabled)
        .offset(y: 20)
    }
}

//MARK: CoverPage
struct CoverPage: View {
    let size: CGSize
    let imageName: String
    
    init(_ size: CGSize, imageName: String = "Icon") {
        self.imageName = imageName
        self.size = size
    }
    var body: some View {
        HStack(spacing: 0) {
            VStack {
                ForEach(0..<2, id: \.self) { i in
                    Rectangle()
                        .frame(height: 20)
                        .padding(.vertical, 50)
                        .foregroundStyle(.yellow.opacity(0.6))
                }
            }
            .frame(width: 25)
            .frame(maxHeight: .infinity)
            .background(Color.black.opacity(0.2))
            
            VStack {
                Text("畢業紀念冊")
                    .font(.title)
                    .bold()
                    .padding(7)
                
                Image(imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .clipShape(.rect(cornerRadius: 7))
                    .padding(.bottom, 10)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                
                Text("恭喜你從這間監獄畢業:D")
                    .font(.caption2)
            }
            .padding()
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.brown)
        .overlay {
            Image(systemName: "bookmark.fill")
                .resizable()
                .frame(width: 30, height: 70)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                .padding(.leading, 35)
                .offset(y: -7)
                .foregroundStyle(Color.yellow.opacity(0.7))
        }
    }
}

//MARK: SwipeButton
struct SwipeButton: View {
    @State private var offset: CGFloat = 150
    @State private var opacity: CGFloat = 0
    var body: some View {
        HStack(spacing: 0) {
            ForEach(0..<2, id: \.self) { _ in
                Image(systemName: "chevron.left")
                    .bold()
                    .imageScale(.large)
                    .opacity(0.4)
                    .frame(width: 10)
            }
            Text("Swipe")
                .frame(maxWidth: .infinity)
                .offset(x: -10)
                .bold()
                .font(.title3)
                .opacity(0.6)
        }
        .padding(.horizontal)
        .frame(width: 200, height: 50)
        .background(.black.opacity(0.11))
        .overlay {
            let gradientColor: [Color] = [.white.opacity(0), .black.opacity(0.1), .white.opacity(0)]
            
            LinearGradient(colors: gradientColor, startPoint: .leading, endPoint: .trailing)
                .frame(width: 150)
                .offset(x: offset)
        }
        .clipShape(.rect(cornerRadius: 25))
        .offset(y: 20)
        .onAppear {
            withAnimation(.easeInOut(duration: 1.5).delay(1.2)) {
                offset = -150
            }
        }
    }
}

//MARK: WoodBackground
struct WoodBackground: View {
    var body: some View {
        Image(.woodBackground)
            .resizable()
            .aspectRatio(contentMode: .fill)
    }
}

struct BackCoverPage: View {
    let imageName = "Icon"
    
    var body: some View {
        HStack(spacing: 0) {
            VStack {
                Text("恭喜畢業")
                    .font(.title)
                    .bold()
                    .padding(7)
                
                Image(imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .clipShape(.rect(cornerRadius: 7))
                    .padding(.bottom, 10)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                
                Text("好啦 都結束ㄌ")
                    .font(.caption2)
            }
            .padding()
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            VStack {
                ForEach(0..<2, id: \.self) { i in
                    Rectangle()
                        .frame(height: 20)
                        .padding(.vertical, 50)
                        .foregroundStyle(.yellow.opacity(0.6))
                }
            }
            .frame(width: 25)
            .frame(maxHeight: .infinity)
            .background(Color.black.opacity(0.2))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.brown)
    }
}

#Preview {
    BookView()
}

#Preview {
    OpenableBook { size in
        BackCoverPage()
    } front: { size in
        
    } insideLeft: { size in
        
    } insideRight: { size in
        
    }
    .offset(x: 300)
}
