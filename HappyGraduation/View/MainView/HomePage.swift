//
//  HomePage.swift
//  HappyGraduation
//
//  Created by Andy Lin on 2024/7/4.
//

import Foundation
import SwiftUI

struct HomePage: View {
    @State private var disable = true
    
    @State private var gifts: [Gift] = [
        Gift(type: .finalGraduationGreeting, imageName: "Capipala", updateVersion: .third),
        Gift(type: .finalGraduationGreeting_article, imageName: "Capipala", updateVersion: .third),
        Gift(type: .defaultContent, imageName: "BirthdayCard", updateVersion: .first),
        Gift(type: .contentAfterVisit10Times, imageName: "BirthdayCard", updateVersion: .first),
        Gift(type: .memories, imageName: "SharkMelon", updateVersion: .second),
        Gift(type: .graduateGreeting, imageName: "GraduationBook", updateVersion: .second),
        Gift(type: .newNonsence, imageName: "HangyodoSanrio", updateVersion: .second)
    ]
    
    @State private var path: [Gift] = []
    
    @State private var isShow = false
    
    let userDefault = UserDefaults.standard
    
    var body: some View {
        NavigationStack(path: $path) {
            ScrollView {
                LazyVStack {
                    ForEach($gifts) { $gift in
                        let gift = $gift.wrappedValue
                        NavigationLink(value: gift) {
                            GiftCell(gift: $gift)
                                .disabled(isDisabled: gift.type == .finalGraduationGreeting ? false: disable)
                        }
                        .contextMenu {
                            ContextMenu($gift)
                        }
                    }
                }
                .onChange(of: isShow) { _, newValue in
                    // value change to false means they leave the content
                    if !newValue {
                        path = []
                    }
                }
            }
            .onAppear {
                // for automaticlly open content of "gift"
                isShow = true
                updateUseState()
            }
            .navigationDestination(for: Gift.self) { gift in
                DestinationView(gift)
            }
            .background(Color.background)
        }
    }
    
    func updateDisable(type: ContextType) {
        if type == .finalGraduationGreeting {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                withAnimation {
                    disable = false
                    userDefault.set(true, forKey: "hasMainArticleBeenSeen")
                }
            }
        }
    }
    
    func updateUseState() {
        let key = "hasMainArticleBeenSeen"
        disable = !userDefault.bool(forKey: key)
    }
    
    @ViewBuilder
    func DestinationView(_ gift: Gift) -> some View {
        if !disable || gift.type == .finalGraduationGreeting {
            if gift.type == .graduateGreeting {
                BookView()
                    .persistentSystemOverlays(.hidden)
            }else if gift.type == .finalGraduationGreeting_article {
                ArticleDisplayer()
                    .persistentSystemOverlays(.hidden)
            }else {
                CardContent(isShow: $isShow, forContent: gift.type)
                    .navigationBarBackButtonHidden()
                    .onDisappear {
                        updateDisable(type: gift.type)
                    }
                    .persistentSystemOverlays(.hidden)
            }
        }else {
            CardContent(isShow: $isShow, forContent: .watchMainFirst)
                .navigationBarBackButtonHidden()
                .onDisappear {
                    updateDisable(type: gift.type)
                }
                .persistentSystemOverlays(.hidden)
        }
    }
    
    @ViewBuilder
    func ContextMenu(_ gift: Binding<Gift>) -> some View {
        Text(gift.wrappedValue.title)
        
        Button("Like", systemImage: "heart") {
            gift.wrappedValue.isLike = true
        }
        
        Button("Open", systemImage: "envelope.open.fill") {
            path = [gift.wrappedValue]
        }
    }
}

#Preview {
    NavigationStack {
        HomePage()
    }
}
