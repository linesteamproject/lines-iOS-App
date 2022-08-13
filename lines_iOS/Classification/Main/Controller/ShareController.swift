//
//  ShareController.swift
//  lines_iOS
//
//  Created by mun on 2022/08/06.
//

import Foundation
import UIKit

class ShareController: NSObject {
    static let shared = ShareController()
    
    func shareOnInstagram(_ stickerTxtView: StickerTextView) {
        let renderer = UIGraphicsImageRenderer(size: stickerTxtView.stickerView.bounds.size)
        let renderImage = renderer.image { _ in
            stickerTxtView.stickerView.drawHierarchy(in: stickerTxtView.stickerView.bounds,
                                                     afterScreenUpdates: true)
        }
        
        guard let storyShareURL = URL(string: "instagram-stories://share"),
              UIApplication.shared.canOpenURL(storyShareURL) else {
            return
        }
        
        guard let imageData = renderImage.pngData(),
              let backHexStr = stickerTxtView.backView.backgroundColor?.getHexStr()
        else { return }
        
        let pasteboardItems : [String:Any] = [
           "com.instagram.sharedSticker.stickerImage": imageData,
           "com.instagram.sharedSticker.backgroundTopColor" : backHexStr,
           "com.instagram.sharedSticker.backgroundBottomColor" : backHexStr,
        ]
        
        let pasteboardOptions = [
            UIPasteboard.OptionsKey.expirationDate : Date().addingTimeInterval(300)
        ]
                        
        UIPasteboard.general.setItems([pasteboardItems], options: pasteboardOptions)
        UIApplication.shared.open(storyShareURL, options: [:], completionHandler: nil)

    }
}
