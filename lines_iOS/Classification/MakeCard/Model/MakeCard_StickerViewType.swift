//
//  MakeCard_StickerViewType.swift
//  lines_iOS
//
//  Created by mun on 2022/08/28.
//

enum MakeCard_StickerViewType {
    case one2one
    case three2Four
    var title: String {
        switch self {
        case .one2one:
            return "정방형"
        case .three2Four:
            return "세로형"
        }
    }
    var imgName: String {
        switch self {
        case .one2one:
            return "One2One"
        case .three2Four:
            return "Three2Four"
        }
    }
}
