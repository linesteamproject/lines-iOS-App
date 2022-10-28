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

//class CropGuideView: UIView {
//    required init?(coder: NSCoder) { fatalError() }
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        let titleLabel = UILabel()
//        let subLabel = UILabel()
//        self.addSubviews(titleLabel, subLabel)
//        NSLayoutConstraint.activate([
//            titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 15),
//            titleLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20),
//            titleLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20),
//            titleLabel.heightAnchor.constraint(equalToConstant: 22),
//
//            subLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
//            subLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20),
//            subLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20),
//            subLabel.heightAnchor.constraint(lessThanOrEqualToConstant: 63),
//            subLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -15)
//        ])
//
//        [titleLabel, subLabel].forEach {
//            $0.numberOfLines = 0
//        }
//        titleLabel.textAlignment = .center
//        titleLabel.setTitle("기록할 문장만 오려주세요 ✂️",
//                            font: Fonts.get(size: 16, type: .bold),
//                            txtColor: .white)
//        var subTxt = "기록할 문장만 남도록 사진 외곽을 드래그해 편집해주세요. "
//        subTxt += "한번에 평균 1~4줄(최대 110자)의 문장을 기록할 수 있으며, "
//        subTxt += "그 이상 넘어가는 글자는 잘리게 됩니다."
//        subLabel.setTitle(subTxt,
//                          font: Fonts.get(size: 14, type: .regular),
//                          txtColor: .white)
//    }
//}

class CameraViewController: ViewController {
    internal var type: UIImagePickerController.SourceType!
    private weak var loadingView: UIView?
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        switch ReadTextController.shared.readTextStep {
        case .start:
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                self.showImagePickerController()
            })
        case .capture:
            self.showCroppedController()
        case .crop:
            let vc = MakeCardViewController()
            vc.modalPresentationStyle = .fullScreen
            DispatchQueue.main.async {
                self.loadingView?.removeFromSuperview()
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    internal func showImagePickerController() {
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
        
        self.present(pVC, animated: false)
    }
    
    private func showCroppedController() {
        guard let image = ReadTextController.shared.capturedImage
        else { fatalError() }
        
        let cropViewController = Mantis.cropViewController(image: image)
        cropViewController.delegate = self
        cropViewController.modalPresentationStyle = .fullScreen
        
        var text = "기록할 문장만 오려주세요 ✂️\n\n"
        text += "기록할 문장만 남도록 사진 외곽을 드래그해 편집해주세요.\n"
        text += "한번에 평균 1~4줄(최대 110자)의 문장을 기록할 수 있으며,\n"
        text += "그 이상 넘어가는 글자는 잘리게 됩니다."
        
        DispatchQueue.main.async {
            self.present(cropViewController, animated: false) {
                DispatchQueue.main.async {
                    Toast.shared.messageOnCropVC(text)
                }
            }
        }
    }
    
    private func setLoadingView(_ cropViewController: CropViewController) {
        let imgView = UIImageView(image: UIImage(named: "텍스트읽기"))
        cropViewController.view.addSubviews(imgView)
        NSLayoutConstraint.activate([
            imgView.centerXAnchor.constraint(equalTo: cropViewController.view.centerXAnchor),
            imgView.centerYAnchor.constraint(equalTo: cropViewController.view.centerYAnchor),
            imgView.widthAnchor.constraint(equalToConstant: 120),
            imgView.heightAnchor.constraint(equalToConstant: 120)
        ])
        self.loadingView = imgView
    }
    
    private func recognizeTextOnImage(_ cropViewController: CropViewController,
                                      done: (() -> Void)?) {
        guard let image = ReadTextController.shared.capturedImage
        else { fatalError() }
        
        setLoadingView(cropViewController)
        TextRecognizeController.doStartToOCR(image,
                                             ocrDone: {
            if let readText = $0 {
                if readText.count > 110 {
                    var str = ""
                    for (idx, c) in readText.enumerated() {
                        guard idx < 110 else { break }
                        str += String(c)
                    }
                    ReadTextController.shared.readText = str
                }
            } else {
                ReadTextController.shared.readText = $0
            }
            done?()
        })
    }
}

extension CameraViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    internal func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        print(info)
        guard let image = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerOriginalImage")] as? UIImage
        else { fatalError() }
        ReadTextController.shared.readTextStep = .capture
        ReadTextController.shared.capturedImage = image
        picker.dismiss(animated: false) {
            self.viewWillAppear(true)
        }
    }
    
    internal func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: false, completion: { [weak self] in
            ReadTextController.shared.initialize()
            self?.navigationController?.popViewController(animated: true)
        })
    }
}

extension CameraViewController: CropViewControllerDelegate {
    func cropViewControllerDidCrop(_ cropViewController: CropViewController,
                                   cropped: UIImage,
                                   transformation: Transformation,
                                   cropInfo: CropInfo) {
        ReadTextController.shared.capturedImage = cropped
        ReadTextController.shared.readTextStep = .crop
        
        recognizeTextOnImage(cropViewController) {
            DispatchQueue.main.async {
                cropViewController.dismiss(animated: false)
            }
        }
    }
    
    func cropViewControllerDidFailToCrop(_ cropViewController: CropViewController,
                                         original: UIImage) { }
    
    func cropViewControllerDidCancel(_ cropViewController: CropViewController,
                                     original: UIImage) {
        ReadTextController.shared.initialize()
        DispatchQueue.main.async {
            cropViewController.dismiss(animated: false)
        }
    }
    
    func cropViewControllerDidBeginResize(_ cropViewController: CropViewController) { }
    func cropViewControllerDidEndResize(_ cropViewController: CropViewController, original: UIImage, cropInfo: CropInfo) { }
}
