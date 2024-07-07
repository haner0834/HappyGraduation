//
//  CardContent.swift
//  HappyGraduation
//
//  Created by Andy Lin on 2024/2/4.
//

import SwiftUI
import VideoPlayer
import AVFoundation
import AVKit

struct CardContent: View {
    @StateObject private var viewModel: CardContentViewModel
    
    init(isShow: Binding<Bool>, forContent contentType: ContextType = .finalGraduationGreeting) {
        self._viewModel = StateObject(wrappedValue: CardContentViewModel(isShow: isShow, type: contentType))
    }
    
    var body: some View {
        VStack {
            let count = viewModel.card.content.count
            ForEach(0..<count, id: \.self) { i in
                let content = viewModel.card.content[i]
                let tapTimes = viewModel.tapTimes
                
                if tapTimes >= i && tapTimes < i + 1 {
                    Text(.init(content.text))
                        .cardTextStylye(isBack: viewModel.isBack)
                    
                    if let image = content.image {
                        image
                            .customStyle(perform: viewModel.processContinue)
                    }
                    
                    if let videoName = content.videoName {
                        CustomVideoPlayer(viewModel: viewModel)
                            .frame(maxHeight: videoName == "LastVideo" ? 314.5: 540)
                            .padding()
                    }
                }
            }
            .onChange(of: viewModel.tapTimes) { _, newValue in
                viewModel.preLoadVideoData(newValue: newValue)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background {
            VStack {
                TappableBackground()
                
                if viewModel.isShowBackButton {
                    BackButton(perform: viewModel.leaveCard)
                }
            }
        }
        .background(Color.background)
        .foregroundStyle(Color.black)
        .statusBarHidden()
    }
    
    //MARK: View functions
    @ViewBuilder
    func CustomVideoPlayer(viewModel: CardContentViewModel) -> some View {
        VStack(spacing: 0) {
            HStack {
                Text(viewModel.formatDate(viewModel.videoData.date))
                
                Spacer()
                
                Text(viewModel.videoData.resource.subtitle)
            }
            .padding(11)
            .padding(.horizontal)
            .bold()
            
            VideoContent(videoData: viewModel.videoData)
                .background(Color.dark)
            
            HStack {
                Button("", systemImage: viewModel.isPlaying ? "pause.fill": "play.fill") {
                    viewModel.togglePlaybackStatus()
                }
                .font(.title)
                .frame(width: 30, height: 25)
                
                ProgressView(value: viewModel.time.seconds, total: viewModel.videoData.duration)
                    .padding(.trailing)
                
                Text(viewModel.formatTime(time: viewModel.time.seconds)) +
                Text(" / ") +
                Text(viewModel.formatTime(time: viewModel.videoData.duration))
                    .foregroundStyle(Color.dark.opacity(0.6))
            }
            .font(.callout)
            .padding(16)
        }
        .background(Color.white)
        .clipShape(.rect(cornerRadius: 16))
        .shadow(color: Color.black.opacity(0.2), radius: 11)
    }
    
    @ViewBuilder
    func VideoContent(videoData: VideoData) -> some View {
        if let url = videoData.url {
            VideoPlayer(url: url, play: $viewModel.isPlaying, time: $viewModel.time)
                .contentMode(.scaleAspectFit)
                .autoReplay(true)
                .onTapGesture {
                    viewModel.processContinue()
                }
        }else {
            VStack {
                Text("Please check the spell or whether file exits.")
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .foregroundColor(.white)
            .background(Color.dark)
        }
    }
    
    @ViewBuilder
    func TappableBackground() -> some View {
        HStack(spacing: 0) {
            let card = viewModel.card
            Color.black.opacity(card.contextType == .defaultContent ? (viewModel.tapTimes == 1 ? 0.3: 0.001): 0.001)
                .contentShape(Rectangle())
                .onTapGesture(perform: viewModel.processBack)
            
            Color.black.opacity(card.contextType == .defaultContent ? (viewModel.tapTimes == 2 ? 0.3: 0.001): 0.001)
                .contentShape(Rectangle())
                .onTapGesture(perform: viewModel.processContinue)
        }
        .ignoresSafeArea(edges: .all)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

fileprivate struct BackButton: View {
    var perform: () -> Void
    var body: some View {
        Button(action: perform) {
            Text("Back")
                .foregroundStyle(Color.white)
                .bold()
                .padding(20)
                .frame(maxWidth: .infinity)
                .background {
                    RoundedRectangle(cornerRadius: 25)
                }
                .padding()
                .offset(y: 30)
        }
    }
}

#Preview {
    CardContent(isShow: .constant(false), forContent: .finalGraduationGreeting)
}
