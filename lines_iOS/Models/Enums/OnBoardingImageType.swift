//
//  OnBoardingImageType.swift
//  lines_iOS
//
//  Created by mun on 2023/03/06.
//

import Foundation

enum OnBardingImageType: Int, CaseIterable {
    case OnBoarding1 = 1
    case OnBoarding2
    case OnBoarding3
    case OnBoarding4
    
    var imgName: String {
        return String(format: "OnBoarding%d",
                      self.rawValue)
    }
}
