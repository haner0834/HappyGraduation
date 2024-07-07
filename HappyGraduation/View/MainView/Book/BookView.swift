//
//  BookView.swift
//  楊昀恩生日欸
//
//  Created by Andy Lin on 2024/4/20.
//

import SwiftUI

/// A flippable Book view, which is support drag and button to open/close the page.
/// - Parameters:
///   - sensitivity: Determines how sensitivity is. The larger number setted, the lower sensitivity is.
///   - content: Determines what content to show.
///  Initial `viewModel` in this block.
struct BookView: View {
    @Environment(\.dismiss) var dismiss
    
    @StateObject var viewModel: BookViewModel
    @GestureState private var offset: CGSize = .zero
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    init(sensitivity: CGFloat = 160, content type: ContextType = .graduateGreeting) {
        _viewModel = StateObject(wrappedValue: BookViewModel(sensitivity: sensitivity,
                                                             bookContent: type))
    }
    
    var body: some View {
        NavigationView {
            VStack {
                let cardContent = viewModel.cardContext.content
                let count = cardContent.count
                let currentPage = viewModel.currentPage
                
                OpenableBook(configuration: .init(progress: viewModel.getProgress(),
                                                  viewOffset: viewModel.getBookOffset())) { size in
                    let content: CardContentItem? = currentPage >= 2 ? cardContent[currentPage - 2]: nil
                    FrontLeftView(size, content: content, isBackCover: currentPage > 0)
                } front: { size in
                    let content = (currentPage >= 2 && currentPage <= count) ? cardContent[currentPage - 1]: nil
                    FrontView(size, content: content, isForFirstPage: currentPage == 0)
                } insideLeft: { size in
                    let content = (currentPage >= 0 && currentPage < count) ? cardContent[currentPage]: nil
                    LeftView(size, content: content, isForLastPage: (currentPage) == count)
                } insideRight: { size in
                    let content = (currentPage >= 0 && currentPage + 1 <= count) ? cardContent[currentPage + 1]: nil
                    RightView(size, content: content, isForLastPage: (currentPage + 1) == count)
                }
            }
            .foregroundStyle(.black)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(WoodBackground().ignoresSafeArea())
            .gesture(
                DragGesture()
                    .onChanged(viewModel.processDraging)
                    .onEnded(viewModel.processDragEnded)
                    .updating($offset) { currentState, state, transion in
                        state = currentState.translation
                    }
            )
            .overlay {
                //change to next and previous page button
                OverlayButtons(disabled: viewModel.isButtonDisable,
                               continueAction: viewModel.processContinue,
                               backAction: viewModel.processBack)
            }
            .overlay {
                //Swipe hint button
                let isBookFlipped = !viewModel.isBookFlipped
                if viewModel.stayTime >= 5 && isBookFlipped {
                    SwipeButton()
                        .id(Int(Double(viewModel.stayTime) / 3))
                        .offset(y: 300)
                }
            }
            .overlay {
                //Back button
                if viewModel.isShowButton || !viewModel.isBookFlipped {
                    Button {
                        dismiss()
                    } label: {
                        HStack {
                            Image(systemName: "chevron.left")
                                .bold()
                            
                            Text(viewModel.currentPage == 0 ? "我不爽看完": "蛤我要回去ㄌ")
                        }
                        .font(.footnote)
                        .padding([.vertical, .trailing], 11)
                        .padding(.horizontal)
                        .background(Color.black)
                        .foregroundStyle(Color.white)
                        .clipShape(.rect(cornerRadius: 16))
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                    .padding()
                }
            }
            .onReceive(timer) { _ in
                withAnimation {
                    viewModel.updateCountdown()
                }
            }
            .animation(.easeInOut, value: viewModel.isBookFlipped)
            .animation(.easeInOut, value: viewModel.isShowButton)
            .onChange(of: viewModel.currentPage) { oldValue, newValue in
                if newValue >= 2, let isShowButton = viewModel.content[newValue - 2].isShowButton {
                    viewModel.isShowButton = isShowButton
                }else if newValue == viewModel.content.count {
                    viewModel.isShowButton = true
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    BookView()
}
