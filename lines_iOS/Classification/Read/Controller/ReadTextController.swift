//
//  CameraController.swift
//  lines_iOS
//
//  Created by mun on 2022/07/30.
//

import Foundation
import UIKit

class ReadTextController: NSObject {
    static let shared = ReadTextController()
    internal var capturedImage: UIImage?
    internal var readText: String?
    internal var sizeType: MakeCard_StickerViewType = .one2one
    internal var colorType: MakeCard_StickerBackType = .grey
    internal var bookInfo: BookDocu?
    func initialize() {
        capturedImage = nil
        readText = nil
    }
}
