//
//  BookViewModel.swift
//  楊昀恩生日欸
//
//  Created by Andy Lin on 2024/4/21.
//

import Foundation
import SwiftUI

final class BookViewModel: ObservableObject {
    ///Determines rotation angle of flippable page of book.
    @Published var progress: CGFloat = 0
    ///Recordinf gesture offset.
    @Published var offset: CGSize = .zero
    ///Set value of horizontal gesture offset when user untap(undrag) the screen.
    @Published var bookOffset: CGFloat = 0
    ///Determines the page to be shown.
    @Published var currentPage = 0
    ///A Boolean determines whether to disable the page change button overlay on view.
    @Published var isButtonDisable = false
    ///Record how long user stay in this view. Cleared when book was opened.
    @Published var stayTime: Int = 0
    ///A Boolean determines whether to show the back button
    @Published var isShowButton: Bool = false
    
    ///Determines what book content to show.(this is used to
    let cardContext: CardContext
    let content: [CardContentItem]
    ///Determines width of book
    let bookWidth: CGFloat = 300
    ///A constant decide how drag gesture sensitivity is.
    ///
    ///The larger value setted, the lower sensitivity is.
    let sensitivity: CGFloat
    ///A Boolean that indicates whether the book has been flipped.
    var isBookFlipped: Bool {
//        !(progress == 0 && currentPage == 0 && bookOffset == 0)
        progress != 0 || currentPage > 0 || bookOffset != 0
    }
    
    init(sensitivity: CGFloat = 100, bookContent: ContextType = .graduateGreeting) {
        self.sensitivity = sensitivity
        self.cardContext = CardContext(contextType: bookContent)
        self.content = cardContext.content
    }
    
    func updateCountdown() {
        stayTime += 1
    }
    
    func processBack() {
        guard currentPage > 0 || progress > 0 else { return }
        let isBookFlipped = progress == 0
        if isBookFlipped {
            let duration = 0.7
            refreshPage(for: .previous)
            withAnimation(.snappy(duration: duration)) {
                bookOffset = 0
            }
        }else {
            flipPage(to: 0)
        }
        stayTime = 0
    }
    
    func processContinue() {
        let isBookFlipped = progress == 1
        let count = content.count
        if isBookFlipped && currentPage < content.count {
            isButtonDisable = true
            let duration = 0.7
            withAnimation(.snappy(duration: duration)) {
                bookOffset = -bookWidth
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + duration) { [self] in
                refreshPage()
                isButtonDisable = false
            }
        }else {
            flipPage()
        }
        stayTime = 0
    }
    
    func processDraging(_ value: DragGesture.Value) {
        offset = value.translation
    }
    
    func processDragEnded(_ value: DragGesture.Value) {
        let isFullFlipped = progress == 1
        let newValue = value.translation.width
        
        if progress <= 1 && bookOffset == 0 {
            let newProgress = progress - (value.translation.width / sensitivity)
            progress = max(min(newProgress, 1), 0)
        }
        
        let count = cardContext.content.count
        guard currentPage < count else { return }
        
        let newValueThresholdMet = progress <= 1 || newValue > -sensitivity
        if isFullFlipped && newValueThresholdMet {
            let newValue = value.translation.width
            let newOffset = min(max(bookOffset + newValue, -bookWidth), 0)
            if newOffset == 0 {
                withAnimation(.snappy) {
                    bookOffset = newOffset
                }
            }else {
                bookOffset = min(max(bookOffset + newValue, -bookWidth), 0)
            }
        }
        
        let isScrollToRight = bookOffset == -bookWidth
        if isScrollToRight {
            refreshPage()
        }
        
        offset = .zero
    }
    
    func flipPage(duration: Double? = 0.7, to flipValue: CGFloat = 1) {
        if let duration {
            withAnimation(.easeInOut(duration: duration)) {
                progress = flipValue
                bookOffset = 0
            }
        }else {
            withAnimation {
                progress = flipValue
                bookOffset = 0
            }
        }
    }
    
    func getProgress() -> CGFloat {
        return progress - (bookOffset == 0 ? offset.width / sensitivity: 0)
    }
    
    func getBookOffset() -> CGFloat {
        let isPageFliped = progress == 1
        let dragOffset: CGFloat
        
        if progress < 1 {
            let lessThanMinus250 = offset.width < -sensitivity
            let greaterThan0 = offset.width > 0
            dragOffset = lessThanMinus250 ? offset.width + (greaterThan0 && isPageFliped ? 0: sensitivity): 0
        }else {
            let greaterThan0 = offset.width > 0
            dragOffset = greaterThan0 && bookOffset == 0 ? 0: offset.width
        }
        
        return bookOffset + dragOffset
    }
    
    func refreshPage(for freshType: FreshType = .next) {
        currentPage += freshType == .next ? 2: -2
        progress = freshType == .next ? 0: 1
        bookOffset = freshType == .next ? 0: -bookWidth
    }
    
    enum FreshType {
        case previous, next
    }
}
