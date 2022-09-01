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
    internal var sizeType: MakeCard_StickerRatioType = .one2one
    internal var colorType: MakeCard_StickerBackColorType = .grey
    internal var bookInfo: BookDocu?
    internal var sticker: UIImage? {
        didSet { RealmController.shared.write(self.getRealmModel()) }
    }
    func initialize() {
        capturedImage = nil
        readText = nil
    }
    func getRealmModel() -> CardModel_Realm {
        return  CardModel_Realm(bookName: self.bookInfo?.title,
                                authorName: self.bookInfo?.authorsStr,
                                lineValue: self.readText,
                                backColorRawValue: self.colorType.rawValue,
                                ratioTypeRawValue: self.sizeType.rawValue,
                                imageData: self.sticker?.pngData())
    }
}
