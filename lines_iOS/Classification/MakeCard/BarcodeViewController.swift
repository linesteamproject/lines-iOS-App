//
//  BarcodeViewController.swift
//  lines_iOS
//
//  Created by mun on 2022/07/30.
//

import AVKit
import UIKit

class BarcodeViewController: ViewController, AVCaptureMetadataOutputObjectsDelegate {
    var captureSession: AVCaptureSession?
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        if (status == .authorized) {
            setBarcodeReader()
        } else if (status == .denied) {
            let alert = UIAlertController(title: "알림", message: "바코드 촬영을 위해 카메라 권한이 필요합니다.\n설정 > 어플리케이션에서 카메라 권한을 허용으로 변경해주세요.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else if (status == .notDetermined) {
            AVCaptureDevice.requestAccess(for: .video) { (isSuccess) in
                if (isSuccess) {
                    DispatchQueue.main.async {
                        self.setBarcodeReader()
                    }
                } else {
                    DispatchQueue.main.async {
                        let alert = UIAlertController(title: "알림", message: "바코드 촬영을 위해 카메라 권한이 필요합니다.\n설정 > 어플리케이션에서 카메라 권한을 허용으로 변경해주세요.", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }
                }
            }
        }
    }
    func setBarcodeReader() {
        let captureDevice = AVCaptureDevice.default(for: AVMediaType.video)
        if let captureDevice = captureDevice {
            do {
                captureSession = AVCaptureSession()
                
                let input: AVCaptureDeviceInput
                input = try AVCaptureDeviceInput(device: captureDevice)
                
                captureSession?.addInput(input)
                
                let metadataOutput = AVCaptureMetadataOutput()
                
                captureSession?.addOutput(metadataOutput)
                metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
                metadataOutput.metadataObjectTypes = [.ean13]    //바코드 형식에 따라 다름
                
                //captureSession?.startRunning()
                
                videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession!)
                videoPreviewLayer?.videoGravity = .resizeAspectFill
                videoPreviewLayer?.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height)
                view.layer.addSublayer(videoPreviewLayer!)
                
                captureSession?.startRunning()
            } catch {
                print("error")
            }
        }
        
    }
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        captureSession?.stopRunning()
        
        if metadataObjects.count == 0 {
            return
        }
        
        let metaDataObject = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        guard let codeVal = metaDataObject.stringValue else {
            return
        }
        
        guard let _ = self.videoPreviewLayer?.transformedMetadataObject(for: metaDataObject) else {
            return
        }
     
        guard let vc = self.presentingViewController as? SearchBookViewController
        else { return }
        
        DispatchQueue.main.async {
            self.dismiss(animated: true) {
                vc.searchByBarcode(codeVal)
            }
        }
        print()
    }
}
