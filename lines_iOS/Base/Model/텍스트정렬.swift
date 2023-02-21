//
//  텍스트정렬.swift
//  lines_iOS
//
//  Created by mun on 2023/02/21.
//

import Foundation

enum 텍스트정렬: String, CaseIterable {
    case 왼쪽 = "TextAlignmentLeft"
    case 중앙 = "TextAlignmentCenter"
    case 오른쪽 = "TextAlignmentRight"
    var inactiveImgName: String {
        switch self {
        case .왼쪽:
            return "카드_텍스트정렬_왼쪽_비활성화"
        case .중앙:
            return "카드_텍스트정렬_중앙_비활성화"
        case .오른쪽:
            return "카드_텍스트정렬_오른쪽_비활성화"
        }
    }
    var activeImgName: String {
        switch self {
        case .왼쪽:
            return "카드_텍스트정렬_왼쪽_활성화"
        case .중앙:
            return "카드_텍스트정렬_중앙_활성화"
        case .오른쪽:
            return "카드_텍스트정렬_오른쪽_활성화"
        }
    }
    var textAlign: NSTextAlignment {
        switch self {
        case .왼쪽:
            return .left
        case .중앙:
            return .center
        case .오른쪽:
            return .right
        }
    }
}
