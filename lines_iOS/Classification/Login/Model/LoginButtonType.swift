//
//  LoginButtonType.swift
//  lines_iOS
//
//  Created by mun on 2022/09/01.
//
import UIKit

enum LoginButtonType: CaseIterable {
    case kakao
    case naver
    case apple
    case skip
    var color: Colors {
        switch self {
        case .kakao:
            return Colors.kakao
        case .naver:
            return Colors.naver
        case .apple:
            return Colors.apple
        case .skip:
            return Colors.clear
        }
    }
    
    var title: String? {
        switch self {
        case .kakao:
            return "카카오로 시작하기"
        case .naver:
            return "네이버로 시작하기"
        case .apple:
            return "애플 계정으로 시작하기"
        case .skip:
            return "건너뛰기"
        }
    }
}
