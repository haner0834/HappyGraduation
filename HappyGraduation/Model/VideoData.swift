//
//  VideoData.swift
//  HappyGraduation
//
//  Created by Andy Lin on 2024/6/30.
//

import Foundation
import AVKit
import SwiftUI

struct VideoData {
    let resource: VideoResource
    let type: String
    let duration: Double
    let url: URL?
    let date: Date
    
    init(resource: VideoResource, type: String, duration: Double, url: URL?, date: Date) {
        self.resource = resource
        self.type = type
        self.duration = duration
        self.url = url
        self.date = date
    }
    
    init() {
        self.resource = .concert
        self.type = "mp4"
        self.duration = 0
        self.url = nil
        self.date = .now
    }
    
    init(name: String, type: String, duration: Double, url: URL?, date: Date) {
        
        var foundResource: VideoResource = .dancingHsin
        for resource in VideoResource.allCases {
            if resource.name == name {
                foundResource = resource
                break
            }
        }
        
        self.resource = foundResource
        self.type = type
        self.duration = duration
        self.url = url
        self.date = date
    }
}
