//
//  ShareController.swift
//  lines_iOS
//
//  Created by mun on 2022/08/06.
//

import Foundation
import UIKit
import Photos

class ShareController: NSObject, UIDocumentInteractionControllerDelegate {
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
    
    var documentController: UIDocumentInteractionController!
    
    func postImageToInstagram(_ stickerView: MakeCard_StickerView) {
        guard let image = self.makeImage(stickerView) else { return }
        
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
            if error != nil {
                print(error)
            }

            let fetchOptions = PHFetchOptions()
            fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]

            let fetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions)

            if let lastAsset = fetchResult.firstObject as? PHAsset {
                let url = URL(string: "instagram://library?LocalIdentifier=\(lastAsset.localIdentifier)")!
                if UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url)
                } else {
//                    let alertController = UIAlertController(title: "Error", message: "Instagram is not installed", preferredStyle: .alert)
//                    alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
//                    self.present(alertController, animated: true, completion: nil)
                }
            }
    }
    
    func downloadImage(_ stickerView: MakeCard_StickerView?, done: ((Bool) -> Void)?) {
        guard let image = ShareController.shared.makeImage(stickerView)
        else { done?(false); return }
        
        PHPhotoLibrary.requestAuthorization { status in
            guard status == .authorized else { done?(false); return }
            PHPhotoLibrary.shared().performChanges({
                PHAssetChangeRequest.creationRequestForAsset(from: image)
            }, completionHandler: { _,_ in done?(true) })
        }
    }
    
    func makeImage(_ stickerView: MakeCard_StickerView?) -> UIImage? {
        guard let stickerView = stickerView else {
            return nil
        }

        let renderer = UIGraphicsImageRenderer(size: stickerView.bounds.size)
        let renderImage = renderer.image { _ in
            stickerView.drawHierarchy(in: stickerView.bounds,
                                                     afterScreenUpdates: true)
        }
        return renderImage
    }
}
