//
//  CameraViewController.swift
//  lines_iOS
//
//  Created by mun on 2022/07/30.
//

import Foundation
import UIKit
import Mantis

class CameraViewController: ViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.showAlert()
        }
    }
    
    private func showAlert() {
        let alertVC = UIAlertController(title: "", message: "텍스트 인식을 위한 이미지를 업로드 할 방법을 선택해주세요.", preferredStyle: .actionSheet)
        let camBtn = UIAlertAction(title: "카메라", style: .default) { [weak self] _ in
            self?.showImagePickerController(type: .camera)
        }
        let library = UIAlertAction(title: "앨범", style: .default) { [weak self] _ in
            self?.showImagePickerController(type: .photoLibrary)
        }
        let cancel = UIAlertAction(title: "취소", style: .default) { _ in
            alertVC.dismiss(animated: true)
        }
        alertVC.addAction(camBtn)
        alertVC.addAction(library)
        alertVC.addAction(cancel)
        
        DispatchQueue.main.async {
            self.present(alertVC, animated: true)
        }
    }
    
    private func showImagePickerController(type: UIImagePickerController.SourceType) {
        let pVC = UIImagePickerController()
        pVC.sourceType = type
        if type == .camera {
            pVC.allowsEditing = false
            pVC.cameraDevice = .rear
            pVC.cameraCaptureMode = .photo
        }
        pVC.delegate = self
        
        DispatchQueue.main.async {
            self.present(pVC, animated: false, completion: nil)
        }
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
            
            DispatchQueue.main.async {
                self.dismiss(animated: true) {
                    ReadTextController.shared.setInitStep()
                }
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
        picker.dismiss(animated: false, completion: nil)
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
    
    func cropViewControllerDidFailToCrop(_ cropViewController: CropViewController, original: UIImage) {
        
    }
    
    func cropViewControllerDidCancel(_ cropViewController: CropViewController, original: UIImage) {
        ReadTextController.shared.capturedImage = nil
        ReadTextController.shared.setPrevStep()
        DispatchQueue.main.async {
            cropViewController.dismiss(animated: false)
        }
    }
    
    func cropViewControllerDidBeginResize(_ cropViewController: CropViewController) {
        
    }
    
    func cropViewControllerDidEndResize(_ cropViewController: CropViewController, original: UIImage, cropInfo: CropInfo) {
        
    }
}
