//
//  TestData.swift
//  lines_iOS
//
//  Created by mun on 2022/08/13.
//

import Foundation
import UIKit

class TestData {
    class func getTestMainDatas() -> [UIImage] {
        (1 ... 20).compactMap {
            let val = $0 % 6 + 1
            return UIImage(named: String(format: "Card%d", val))
        }
    }
}
