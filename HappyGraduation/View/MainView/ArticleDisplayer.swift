//
//  ArticleDisplayer.swift
//  HappyGraduation
//
//  Created by Andy Lin on 2024/7/1.
//

import SwiftUI

struct ArticleDisplayer: View {
    
    init() {
        UIUserInterfaceStyle.light
    }
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                Text("一封遲到的信")
                    .font(.title2)
                    .bold()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.vertical)
                
                ForEach(GraduationArticle.articleOptimization, id: \.count) { content in
                    Text(content)
                        .opacity(0.85)
                        .lineSpacing(3)
                        .tracking(1.6)
                }
            }
            .padding(26)
        }
        .foregroundStyle(.dark)
        .background(Color.background)
    }
}

#Preview {
    NavigationStack {
        HomePage()
    }
}

#Preview {
    ArticleDisplayer()
}
