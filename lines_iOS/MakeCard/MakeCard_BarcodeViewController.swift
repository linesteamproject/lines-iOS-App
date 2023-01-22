//
//  MakeCard_BarcodeViewController.swift
//  lines_iOS
//
//  Created by mun on 2022/07/30.
//

import AVKit
import UIKit

class MakeCard_BarcodeViewController: ViewController {
    var captureSession: AVCaptureSession?
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = Colors.black.value.withAlphaComponent(0.3)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        guard (status != .authorized) else {
            setBarcodeReader()
            return
        }
        guard (status != .denied) else{
            let alert = UIAlertController(title: "알림",
                                          message: "바코드 촬영을 위해 카메라 권한이 필요합니다.\n설정 > 어플리케이션에서 카메라 권한을 허용으로 변경해주세요.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        AVCaptureDevice.requestAccess(for: .video) { (isSuccess) in
            if (isSuccess) {
                DispatchQueue.main.async {
                    self.setBarcodeReader()
                }
            } else {
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "알림",
                                                  message: "바코드 촬영을 위해 카메라 권한이 필요합니다.\n설정 > 어플리케이션에서 카메라 권한을 허용으로 변경해주세요.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
    
    func setBarcodeReader() {
        let back = UIView()
        self.view.addSubviews(back)
        NSLayoutConstraint.activate([
            back.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            back.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            back.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20),
            back.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20),
            back.heightAnchor.constraint(equalToConstant: 156)
        ])
        back.layer.cornerRadius = 8
        back.backgroundColor = Colors.white.value
        back.alpha = 1.0

        let titleView = UIView()
        back.addSubviews(titleView)
        NSLayoutConstraint.activate([
            titleView.topAnchor.constraint(equalTo: back.topAnchor),
            titleView.leftAnchor.constraint(equalTo: back.leftAnchor),
            titleView.rightAnchor.constraint(equalTo: back.rightAnchor),
            titleView.heightAnchor.constraint(equalToConstant: 56),
        ])
        titleView.clipsToBounds = true
        let titleLabel = UILabel()
        titleView.addSubviews(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: titleView.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: titleView.centerYAnchor),
        ])
        titleLabel.setTitle("바코드 촬영",
                            font: Fonts.get(size: 16, type: .bold),
                            txtColor: .black)
        let btn = UIButton()
        titleView.addSubviews(btn)
        NSLayoutConstraint.activate([
            btn.rightAnchor.constraint(equalTo: titleView.rightAnchor, constant: -16),
            btn.centerYAnchor.constraint(equalTo: titleView.centerYAnchor),
            btn.widthAnchor.constraint(equalToConstant: 16),
            btn.heightAnchor.constraint(equalToConstant: 16)
        ])
        btn.setImage(UIImage(named: "IconX")?.withTintColor(Colors.black.value),
                     for: .normal)
        btn.addAction(UIAction { [weak self] _ in
            self?.dismiss(animated: false)
        }, for: .touchUpInside)

        let readerView = MakeCard_BarcodeReaderView()
        back.addSubviews(readerView)
        NSLayoutConstraint.activate([
            readerView.topAnchor.constraint(equalTo: titleView.bottomAnchor),
            readerView.leftAnchor.constraint(equalTo: back.leftAnchor),
            readerView.rightAnchor.constraint(equalTo: back.rightAnchor),
            readerView.bottomAnchor.constraint(equalTo: back.bottomAnchor)
        ])
        readerView.captureCompletion = { [weak self] codeVal in
            self?.dismiss(animated: false) {
                guard let vc = topViewController() as? MakeCard_SearchBookViewController
                else { return }
                vc.getBookInfo(codeVal)
            }
        }
    }
}
