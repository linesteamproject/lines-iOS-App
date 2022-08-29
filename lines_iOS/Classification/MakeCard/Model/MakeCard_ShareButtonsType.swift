//
//  MakeCard_ShareButtonsType.swift
//  lines_iOS
//
//  Created by mun on 2022/08/29.
//

enum MakeCard_ShareButtonsType: CaseIterable {
    case insta
    case save
    case shareExt
    var imgName: String {
        switch self {
        case .insta:
            return "InstagramButton"
        case .save:
            return "SaveButton"
        case .shareExt:
            return "ShareButton"
        }
    }
}
