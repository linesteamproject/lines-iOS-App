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
                  txtColor: Colors? = nil, backColor: Colors? = nil) {
        if let str = str {
            self.text = str
        }
        if let font = font {
            self.font = font
        }
        if let txtColor = txtColor {
            self.textColor = txtColor.value
        }
        if let backColor = backColor {
            self.backgroundColor = backColor.value
        }
    }
    
    func setTitleHasLineSpace(_ title: String? = nil,
                              lineSpaceVal: CGFloat = 5,
                              font: UIFont? = nil,
                              color: Colors? = nil,
                              backColor: Colors? = nil,
                              textAlignment: NSTextAlignment? = nil) {
        if let font = font {
            self.font = font
        }
        if let color = color {
            self.textColor = color.value
        }
        if let backColor = backColor {
            self.backgroundColor = backColor.value
        }
        
        let attributedString = NSMutableAttributedString(string: title ?? "")
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpaceVal
        if textAlignment == nil {
            paragraphStyle.alignment = NSTextAlignment.left
        } else {
            paragraphStyle.alignment = textAlignment ?? .left
        }
        
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle,
                                      value:paragraphStyle,
                                      range:NSMakeRange(0, attributedString.length))
        self.attributedText = attributedString
    }
}

extension UIButton {
    func setTitle(_ str: String? = "", font: UIFont? = nil,
                  txtColor: Colors? = nil, backColor: Colors? = nil) {
        if let str = str {
            self.setTitle(str, for: .normal)
        }
        if let font = font {
            self.titleLabel?.font = font
        }
        if let txtColor = txtColor {
            self.setTitleColor(txtColor.value, for: .normal)
        }
        if let backColor = backColor {
            self.backgroundColor = backColor.value
        }
    }
}
extension UIView {
    func addSubviews(_ views: UIView... ) {
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
    
    func getContrast() -> UIColor {
        let red = self.cgColor.components?[0] ?? 0
        let green = self.cgColor.components?[1] ?? 0
        let blue = self.cgColor.components?[2] ?? 0
        
        let redReversal = 1-red
        let greenReversal = 1-green
        let blueReversal = 1-blue
        
        let conversion = 0.2126 * pow(red/255, 2.2)
        + 0.7152 * pow(green/255, 2.2)
        + 0.0722 * pow(blue/255, 2.2)
        
        let conversionReversal = 0.2126 * pow(redReversal/255, 2.2)
        + 0.7152 * pow(greenReversal/255, 2.2)
        + 0.0722 * pow(blueReversal/255, 2.2)
        
        if(conversion > conversionReversal){
            return UIColor(rgb: Int((conversion+0.05)/(conversionReversal+0.05)*255))
        } else{
            return UIColor(rgb: Int((conversionReversal+0.05)/(conversion+0.05)*255))
        }
    }
    
    func getHexStr() -> String {
        let components = self.cgColor.components
        let r: CGFloat = components?[safe: 0] ?? 1
        let g: CGFloat = components?[safe: 1] ?? 1
        let b: CGFloat = components?[safe: 2] ?? 1
        
        let hexString = String.init(format: "#%02lX%02lX%02lX",
                                    lroundf(Float(r * 255)),
                                    lroundf(Float(g * 255)),
                                    lroundf(Float(b * 255)))
        print(hexString)
        return hexString
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

extension UIImageView {
    func load(urlStr: String?) {
        guard let urlStr = urlStr, let url = URL(string: urlStr)
        else { return }
        
        DispatchQueue.global().async {
            guard let data = try? Data(contentsOf: url),
            let image = UIImage(data: data)
            else { return }
            
            DispatchQueue.main.async {
                self.image = image
            }
        }
    }
}
