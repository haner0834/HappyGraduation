//
//  VideoError.swift
//  HappyGraduation
//
//  Created by Andy Lin on 2024/7/6.
//

import Foundation

enum VideoError: Error {
    case noFile(name: String, type: String), getCurrentTimeFailed, getDurationFailed, fileExtensionNotSupport(type: String), matchFailed
    
    var message: String {
        switch self {
        case .noFile(let name, let type):
            return "No such file found with \"\(name).\(type)\". Check if file exits of the spell."
        case .getCurrentTimeFailed:
            return "Failed to get current time of the video."
        case .getDurationFailed:
            return "Failed to get duration of the video."
        case .fileExtensionNotSupport(let type):
            return "Given file extension(\(type)) is not supported."
        case .matchFailed:
            return "Failed to match given file to `VideoResource`"
        }
    }
}
