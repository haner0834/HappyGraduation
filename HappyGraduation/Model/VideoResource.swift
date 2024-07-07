//
//  VideoResource.swift
//  HappyGraduation
//
//  Created by Andy Lin on 2024/7/6.
//

import Foundation

enum VideoResource: CaseIterable {
    case concert, dancingHsin, fourMenSleeping, peopleTurning, incenseStick, lastVideo
    
    var name: String {
        switch self {
        case .concert:
            return "Concert"
        case .dancingHsin:
            return "DancingHsin"
        case .fourMenSleeping:
            return "FourMenSleeping"
        case .peopleTurning:
            return "PeopleTurning"
        case .incenseStick:
            return "IncenseStick"
        case .lastVideo:
            return "LastVideo"
        }
    }
    
    var subtitle: String {
        switch self {
        case .concert:
            return "我是頭號粉絲"
        case .dancingHsin:
            return "師哥跳舞"
        case .fourMenSleeping:
            return "校車很好睡"
        case .peopleTurning:
            return "轉轉轉～"
        case .incenseStick:
            return "虔誠✅"
        case .lastVideo:
            return ":D"
        }
    }
}
