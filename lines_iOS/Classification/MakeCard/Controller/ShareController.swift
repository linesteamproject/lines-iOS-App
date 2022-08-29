//
//  ShareController.swift
//  lines_iOS
//
//  Created by mun on 2022/08/06.
//

import Foundation
import UIKit
import Photos

class ShareController: NSObject {
    static let shared = ShareController()
    
    func shareOnInstagram(_ stickerView: MakeCard_StickerView) {
        let renderer = UIGraphicsImageRenderer(size: stickerView.bounds.size)
        let renderImage = renderer.image { _ in
            stickerView.drawHierarchy(in: stickerView.bounds,
                                                     afterScreenUpdates: true)
        }
        
        guard let storyShareURL = URL(string: "instagram-stories://share"),
              UIApplication.shared.canOpenURL(storyShareURL) else {
            return
        }
        
        guard let imageData = renderImage.pngData()
        else { return }
        
        let backHexStr = ReadTextController.shared.colorType.color.getHexStr()
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
    
    func downloadImage(_ stickerView: MakeCard_StickerView?, done: ((Bool) -> Void)?) {
        guard let stickerView = stickerView else {
            done?(false); return
        }

        let renderer = UIGraphicsImageRenderer(size: stickerView.bounds.size)
        let renderImage = renderer.image { _ in
            stickerView.drawHierarchy(in: stickerView.bounds,
                                                     afterScreenUpdates: true)
        }
        PHPhotoLibrary.requestAuthorization { status in
            guard status == .authorized else { done?(false); return }
            PHPhotoLibrary.shared().performChanges({
                PHAssetChangeRequest.creationRequestForAsset(from: renderImage)
            }, completionHandler: { _,_ in done?(true) })
        }
    }
}
