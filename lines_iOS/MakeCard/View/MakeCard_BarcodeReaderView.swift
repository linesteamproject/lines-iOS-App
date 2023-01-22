//
//  MakeCard_BarcodeReaderView.swift
//  lines_iOS
//
//  Created by mun on 2022/08/28.
//

import UIKit
import AVFoundation

class MakeCard_BarcodeReaderView: UIView {
    private lazy var captureDevice = AVCaptureDevice.default(for: .video)
    private var session: AVCaptureSession?
    private var output = AVCapturePhotoOutput()
    internal var captureCompletion: ((String) -> Void)?
    
    public var isRunning: Bool {
        return session?.isRunning ?? false
    }
    
    public override class var layerClass: Swift.AnyClass {
        return AVCaptureVideoPreviewLayer.self
    }
    
    private var previewLayer: AVCaptureVideoPreviewLayer? {
        return layer as? AVCaptureVideoPreviewLayer
    }
    
    internal override init(frame: CGRect) {
        super.init(frame: frame)
        self.clipsToBounds = true
        
        setUI()
    }
    
    internal required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUI()
    }
    
    deinit { captureCompletion = nil }
    
    private func setUI() {
        guard let captureDevice = captureDevice else { return }
        
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice)
            let metadataOutput = AVCaptureMetadataOutput()
            session = AVCaptureSession()
            session?.sessionPreset = .photo
            session?.addInput(input)
            session?.addOutput(metadataOutput)
            metadataOutput.setMetadataObjectsDelegate(self,
                                                      queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.ean13]    //바코드 형식에 따라 다름
            session?.addOutput(output)
        } catch {
            print(error)
        }
        
        guard let session = session else { return }
        
        previewLayer?.session = session
        previewLayer?.videoGravity = .resizeAspectFill
        
        session.startRunning()
    }
    
}

extension MakeCard_BarcodeReaderView: AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        session?.stopRunning()
        
        guard metadataObjects.count > 0,
              let metaDataObject = metadataObjects[0] as? AVMetadataMachineReadableCodeObject,
              let codeVal = metaDataObject.stringValue,
              ((self.previewLayer?.transformedMetadataObject(for: metaDataObject)) != nil)
        else { return }
        
        captureCompletion?(codeVal)
    }
}
