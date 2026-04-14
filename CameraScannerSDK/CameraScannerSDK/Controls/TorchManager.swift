//
//  TorchManager.swift
//  CameraScannerSDK
//
//  Created by Laksh Purbey on 14/04/26.
//

import Foundation
import AVKit

final class TorchManager {

    static func toggle() {
        guard let device = AVCaptureDevice.default(for: .video),
              device.hasTorch else { return }

        try? device.lockForConfiguration()
        device.torchMode = device.torchMode == .on ? .off : .on
        device.unlockForConfiguration()
    }
}
