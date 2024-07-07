//
//  CardContentViewModel.swift
//  HappyGraduation
//
//  Created by Andy Lin on 2024/7/5.
//

import Foundation
import SwiftUI
import AVFoundation
import Combine

class CardContentViewModel: ObservableObject {
    @Published var isShow: Bool
    
    @Published var tapTimes: Int = 0
    @Published var isBack: Bool = false
    @Published var isShowBackButton: Bool = false
    @Published var isPlaying: Bool = true
    @Published var time: CMTime = .zero
    @Published var videoData = VideoData()
    
    private var cancellable: AnyCancellable?
    
    let userDefault = UserDefaults.standard
    
    var card = CardContext()
    
    init(isShow: Binding<Bool>, type: ContextType) {
        self.isShow = isShow.wrappedValue
        
        card.contextType = type
        
        //For bind value to this view model.
        cancellable = $isShow
            .receive(on: DispatchQueue.main)
            .sink { newValue in
                isShow.wrappedValue = newValue
            }
    }
    
    func togglePlaybackStatus() {
        isPlaying.toggle()
    }
    
    func leaveCard() {
        withAnimation {
            isShow = false
        }
    }
    
    func processContinue() {
        withAnimation {
            isBack = false
            tapTimes += 1
            
            let count = card.content.count
            isShow = tapTimes <= count - 1
            if tapTimes <= count - 1 {
                if let isShowButtom = card.content[tapTimes].isShowButton {
                    isShowBackButton = isShowButtom
                }
            }
            
            time = .zero
        }
    }
    
    func processBack() {
        withAnimation {
            isBack = tapTimes == 0 ? false: true
            tapTimes -= tapTimes == 0 ? -1: 1
            isShow = tapTimes != 0
            
            if let isShowButton = card.content[tapTimes].isShowButton {
                isShowBackButton = isShowButton
            }
            
            time = .zero
        }
    }
    
    func loadVideoData(name: String, type: String = "mp4") async throws {
        let types = ["mp4", "mov", "MOV"]
        guard types.firstIndex(of: type) != nil else { throw VideoError.fileExtensionNotSupport(type: type) }
        
        //Gets resource type from given name
        var foundResource: VideoResource? = nil
        for resource in VideoResource.allCases {
            if resource.name == name {
                foundResource = resource
                break
            }
        }
        guard let foundResource else {
            throw VideoError.matchFailed
        }
        
        //Gets video file path
        let path = Bundle.main.path(forResource: name, ofType: type)
        guard let path else { throw VideoError.noFile(name: name, type: type) }
        
        //Gets url with file path
        let url = URL(fileURLWithPath: path)
        
        //Gets time duration
        let player = AVPlayer(url: url)
        guard let currentTime = player.currentItem else { throw VideoError.getCurrentTimeFailed }
        let asset = AVURLAsset(url: url)
        let duration = try? await asset.load(.duration)
        guard let duration else { throw VideoError.getDurationFailed }
        
        //Gets date of it
        let components: DateComponents
        switch foundResource {
        case .concert:
            components = .init(year: 2023, month: 12, day: 8)
        case .dancingHsin:
            components = .init(year: 2023, month: 11, day: 28)
        case .fourMenSleeping:
            components = .init(year: 2023, month: 12, day: 13)
        case .peopleTurning:
            components = .init(year: 2023, month: 11, day: 29)
        case .incenseStick:
            components = .init(year: 2023, month: 12, day: 7)
        case .lastVideo:
            components = .init(year: 2024, month: 6, day: 7)
        }
        
        let calendar = Calendar.current
        let date = calendar.date(from: components)
        guard let date else {
            print("Fialed to turn `DateComponents` to `Date`.")
            return
        }
        
        videoData = VideoData(resource: foundResource, type: type, duration: duration.seconds, url: url, date: date)
    }
    
    func formatDate(_ date: Date) -> String {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: date)
        
        guard let year = components.year,
              let month = components.month,
              let day = components.day else { return "" }
        
        return "\(year - 2000).\(month).\(day)"
    }
    
    func formatTime(time: Double) -> String {
        let minute = Int(time) / 60
        let second = Int(time) % 60
        return String(format: "%02d:%02d", minute, second)
    }
    
    func preLoadVideoData(newValue: Int) {
        let content = card.content
        let count = content.count
        
        if newValue + 1 < count, let videoName = content[newValue + 1].videoName {
            DispatchQueue.global(qos: .background).async { [self] in
                Task {
                    do {
                        try await loadVideoData(name: videoName)
                    }catch let error as VideoError {
                        print(error.message)
                    }catch {
                        fatalError("Unknow error: \(error.localizedDescription)")
                    }
                }
            }
        }
    }
}
