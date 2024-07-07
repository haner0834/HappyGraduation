//
//  GiftCell.swift
//  HappyGraduation
//
//  Created by Andy Lin on 2024/7/4.
//

import Foundation
import SwiftUI

struct GiftCell: View {
    private var isDisabled: Bool = false
    @Binding var gift: Gift
    
    init(gift: Binding<Gift>) {
        self.isDisabled = false
        _gift = gift
    }
    
    var body: some View {
        HStack {
            HeaderImage()
            
            VStack(alignment: .leading) {
                HStack {
                    Title(gift.title)
                    
                    LikeButton(isLike: gift.isLike) {
                        like()
                    }
                    .opacity(isDisabled ? 0.5: 1)
                    .sensoryFeedback(.selection, trigger: gift.isLike) { _, newValue in
                        return newValue
                    }
                }
                
                Text(gift.description)
                    .font(.caption)
                    .padding(5)
                
                HStack {
                    Spacer()
                    
                    Text("更新時間： \(gift.updateVersion.localizedName)")
                        .font(.caption2)
                        .opacity(0.6)
                }
            }
            .padding(.vertical, 11)
            .padding(.horizontal, 3)
            .onAppear {
                updateLike()
            }
        }
        .padding()
        .background(Color.background)
        .disabled(isDisabled)
    }
    
    func disabled(isDisabled: Bool) -> GiftCell {
        var cell = self
        cell.isDisabled = isDisabled
        return cell
    }
    
    func like() {
        withAnimation(.easeInOut(duration: 0.1)) {
            gift.isLike.toggle()
            let key = "isLike\(String(describing: gift.type))"
            UserDefaults.standard.set(gift.isLike, forKey: key)
        }
    }
    
    func updateLike() {
        let key = "isLike\(String(describing: gift.type))"
        gift.isLike = UserDefaults.standard.bool(forKey: key)
    }
    
    //MARK: View functions
    @ViewBuilder
    func HeaderImage() -> some View {
        Image(gift.imageName)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(maxWidth: 100, maxHeight: 100)
            .opacity(isDisabled ? 0.5: 1)
            .overlay {
                if isDisabled {
                    Image(systemName: "lock.circle.fill")
                        .font(.largeTitle)
                        .foregroundStyle(Color.black)
                }
            }
            .clipShape(.rect(cornerRadius: 16))
    }
    
    @ViewBuilder
    func Title(_ text: String) -> some View {
        Text(text)
            .frame(maxWidth: .infinity, alignment: .leading)
            .bold()
    }
}

struct LikeButton: View {
    let isLike: Bool
    var perform: () -> Void
    var body: some View {
        Image(systemName: isLike ? "heart.fill": "heart")
            .font(.title3)
            .foregroundStyle(isLike ? Color.pink.opacity(0.75): Color.dark.opacity(0.5))
            .onTapGesture {
                perform()
            }
            .fontWeight(.semibold)
    }
}

#Preview {
    GiftCell(gift: .constant(.init(type: .defaultContent, imageName: "SchoolFail", updateVersion: .first)))
}
