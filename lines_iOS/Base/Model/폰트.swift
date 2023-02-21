//
//  폰트.swift
//  lines_iOS
//
//  Created by mun on 2023/02/21.
//

import Foundation

enum 폰트: String, CaseIterable {
    case 나눔명조 = "NanumMyeongjo"
    case 본고딕 = "NotoSansKR"
    case 나눔스퀘어 = "NanumSquareNeo"
    case 고운돋움 = "GowunDodum"
    case 나눔손글씨 = "NanumURiDdarSonGeurSsi"
    
    var val: UIFont {
        switch self {
        case .나눔명조:
            return UIFont(name: "NanumMyeongjo-YetHangul", size: 16)!
        case .본고딕:
            return UIFont(name: "NotoSansNKo-Regular", size: 16)!
        case .나눔스퀘어:
            return UIFont(name: "NanumSquareNeoTTF-bRg", size: 16)!
        case .고운돋움:
            return UIFont(name: "GowunDodum-Regular", size: 16)!
        case .나눔손글씨:
            return UIFont(name: "NanumURiDdarSonGeurSsi", size: 16)!
        }
    }
}
