//
//  CameraViewController.swift
//  lines_iOS
//
//  Created by mun on 2022/07/30.
//

import Foundation
import UIKit
import Mantis
import AVFoundation

class CameraViewController: ViewController {
    internal var type: UIImagePickerController.SourceType!
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05, execute: {
            self.showImagePickerController()
        })
    }
    
    private func showImagePickerController() {
        let pVC: UIImagePickerController
        if type == .camera {
            pVC = ExternUIImagePickerController()
            pVC.sourceType = type
            pVC.allowsEditing = false
            pVC.cameraDevice = .rear
            pVC.cameraCaptureMode = .photo
        } else {
            pVC = UIImagePickerController()
            pVC.sourceType = type
        }
        pVC.delegate = self
        
        self.present(pVC, animated: false, completion: nil)
    }
    
    private func showCroppedController() {
        guard let image = ReadTextController.shared.capturedImage
        else { fatalError() }
        
        let cropViewController = Mantis.cropViewController(image: image)
        cropViewController.delegate = self
        cropViewController.modalPresentationStyle = .fullScreen
        DispatchQueue.main.async {
            self.present(cropViewController, animated: false)
        }
    }
    
    private func recognizeTextOnImage() {
        guard let image = ReadTextController.shared.capturedImage
        else { fatalError() }
        TextRecognizeController.doStartToOCR(image,
                                             ocrDone: {
            ReadTextController.shared.readText = $0
            let vc = MakeCardViewController()
            vc.modalPresentationStyle = .fullScreen
            DispatchQueue.main.async {
                self.present(vc, animated: false)
            }
        })
    }
}

extension CameraViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    internal func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        print(info)
        guard let image = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerOriginalImage")] as? UIImage
        else { fatalError() }
        ReadTextController.shared.capturedImage = image
        picker.dismiss(animated: false) {
            self.showCroppedController()
        }
    }
    internal func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: false, completion: {
            ReadTextController.shared.initialize()
            dismissViewControllerUntil(vcID: MainViewController.id)
        })
    }
}

extension CameraViewController: CropViewControllerDelegate {
    func cropViewControllerDidCrop(_ cropViewController: CropViewController,
                                   cropped: UIImage,
                                   transformation: Transformation,
                                   cropInfo: CropInfo) {
        ReadTextController.shared.capturedImage = cropped
        DispatchQueue.main.async {
            cropViewController.dismiss(animated: false) {
                self.recognizeTextOnImage()
            }
        }
    }
    
    func cropViewControllerDidFailToCrop(_ cropViewController: CropViewController,
                                         original: UIImage) { }
    
    func cropViewControllerDidCancel(_ cropViewController: CropViewController,
                                     original: UIImage) {
        ReadTextController.shared.capturedImage = nil
        
        DispatchQueue.main.async {
            cropViewController.dismiss(animated: false) {
                ReadTextController.shared.initialize()
                dismissViewControllerUntil(vcID: MainViewController.id)
            }
        }
    }
    
    func cropViewControllerDidBeginResize(_ cropViewController: CropViewController) { }
    func cropViewControllerDidEndResize(_ cropViewController: CropViewController, original: UIImage, cropInfo: CropInfo) { }
}
