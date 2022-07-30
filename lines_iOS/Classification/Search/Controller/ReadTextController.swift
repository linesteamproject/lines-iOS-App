//
//  CameraController.swift
//  lines_iOS
//
//  Created by mun on 2022/07/30.
//

import Foundation
import UIKit

enum CameraStep: Int {
    case start = 0
    case take
    case edit
    case recognize
    case error = -1
}

class ReadTextController: NSObject {
    static let shared = ReadTextController()
    private var step: CameraStep = .start
    internal var capturedImage: UIImage?
    internal var readText: String?
    override init() {
        super.init()
    }
    internal func setInitStep() {
        self.step = .start
    }
    internal func setPrevStep() {
        self.step = CameraStep(rawValue: step.rawValue - 2) ?? .error
    }
    internal func getNextStep() -> CameraStep {
        self.step = CameraStep(rawValue: step.rawValue + 1) ?? .error
        return step
    }
}
