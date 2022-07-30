//
//  Extensions+UI.swift
//  lines_iOS
//
//  Created by mun on 2022/07/30.
//

import Foundation
import UIKit

extension UIViewController {
    static var id: String {
        return self.description().components(separatedBy: ".").last ?? ""
    }
}
extension UIView {
    static var id: String {
        return self.description().components(separatedBy: ".").last ?? ""
    }
}

extension UILabel {
    func setTitle(_ str: String? = "", font: UIFont? = nil,
                  txtColor: UIColor? = nil, backColor: UIColor? = nil) {
        if let str = str {
            self.text = str
        }
        if let font = font {
            self.font = font
        }
        if let txtColor = txtColor {
            self.textColor = txtColor
        }
        if let backColor = backColor {
            self.backgroundColor = backColor
        }
    }
}
extension UIView {
    func addSubViews(_ views: UIView... ) {
        views.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview($0)
        }
    }
}

extension UIColor {
    static func random() -> UIColor {
        return UIColor(
            red:   .random(),
            green: .random(),
            blue:  .random(),
            alpha: 1.0
        )
    }
   convenience init(red: Int, green: Int, blue: Int) {
       assert(red >= 0 && red <= 255, "Invalid red component")
       assert(green >= 0 && green <= 255, "Invalid green component")
       assert(blue >= 0 && blue <= 255, "Invalid blue component")

       self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
   }

   convenience init(rgb: Int) {
       self.init(
           red: (rgb >> 16) & 0xFF,
           green: (rgb >> 8) & 0xFF,
           blue: rgb & 0xFF
       )
   }
}
