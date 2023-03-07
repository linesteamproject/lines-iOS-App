//
//  UserAgreementType.swift
//  lines_iOS
//
//  Created by mun on 2023/03/06.
//

import Foundation

enum UserAgreementType: Int, CaseIterable {
    case privacyInfo = 0
    case service = 1
    
    var title: String {
        switch self {
        case .service:
            return "서비스 이용약관 동의"
        case .privacyInfo:
            return "개인정보 수집 및 이용 동의"
        }
    }
    var subTitle: String {
        switch self {
        case .service, .privacyInfo:
            return "(필수)"
        }
    }
    var rightContent: String? {
        switch self {
        case .service, .privacyInfo:
            return "내용보기"
        }
    }
    var urlStr: String {
        switch self {
        case .privacyInfo:
            return "https://fuzzy-moat-e98.notion.site/ffee06c6f31c49dd91e7c85981e60cc3"
        case .service:
            return "https://fuzzy-moat-e98.notion.site/370091f86242460fbfc103b574e6407c"
        }
    }
}
