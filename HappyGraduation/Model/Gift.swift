//
//  Gift.swift
//  HappyGraduation
//
//  Created by Andy Lin on 2024/7/4.
//

import Foundation

struct Gift: Identifiable, Codable, Hashable {
    let id = UUID()
    
    let type: ContextType
    let imageName: String
    let updateVersion: UpdateVersion
    var isLike: Bool
    
    init(type: ContextType, imageName: String, updateVersion: UpdateVersion, isLike: Bool = false) {
        self.type = type
        self.imageName = imageName
        self.updateVersion = updateVersion
        self.isLike = isLike
    }
    
    enum UpdateVersion: Int, Codable {
        case first, second, third
        
        var localizedName: String {
            switch self {
            case .first:
                return "第一次"
            case .second:
                return "第二次"
            case .third:
                return "第三次"
            }
        }
    }
    
    var title: String {
        switch type {
        case .defaultContent:
            return "生日祝賀"
        case .contentAfterVisit10Times:
            return "看10次以上會有的彩蛋"
        case .graduateGreeting:
            return "畢業紀念冊"
        case .memories:
            return "Memories"
        case .finalGraduationGreeting:
            return "遲到的畢業廢話"
        case .newNonsence:
            return "會考前ㄉ發瘋"
        case .finalGraduationGreeting_article:
            return "一樣ㄉ東西  但是文章版"
        default:
            return "Error: Expected given pattern no matched."
        }
    }
    
    var description: String {
        switch type {
        case .defaultContent:
            return "絕對不是回禮"
        case .contentAfterVisit10Times:
            return "我多用心啊"
        case .graduateGreeting:
            return "ㄏ 新的東西欸"
        case .memories:
            return "虫合"
        case .finalGraduationGreeting:
            return "跟你的比起來我的好多了:D"
        case .newNonsence:
            return "然後你都沒看💩"
        case .finalGraduationGreeting_article:
            return "這字數 絕了"
        default:
            return "Error: Expected given pattern no matched."
        }
    }
}
