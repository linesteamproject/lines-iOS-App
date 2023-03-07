//
//  LoginButtonType.swift
//  lines_iOS
//
//  Created by mun on 2022/09/01.
//
import UIKit

enum LoginType: String, CaseIterable {
    case kakao
    case naver
    case apple
    case skip
    var type: String {
        return self.rawValue.uppercased()
    }
    
    var img: UIImage? {
        var tmpRawValue = self.rawValue
        let firstVal = tmpRawValue.removeFirst().uppercased()
        return UIImage(named: firstVal + tmpRawValue + "LoginButton")
    }
    
    var txtColor: UIColor {
        switch self {
        case .kakao:
            return Colors.black.value
        case .naver:
            return Colors.white.value
        case .apple:
            return Colors.black.value
        case .skip:
            return Colors.beige.value
        }
    }
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
            return "Apple 계정으로 시작하기"
        case .skip:
            return "건너뛰기"
        }
    }
}
