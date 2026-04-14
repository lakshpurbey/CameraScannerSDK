//
//  CameraScannerConfig.swift
//  CameraScannerSDK
//
//  Created by Laksh Purbey on 14/04/26.
//

import Foundation
import AVKit

public protocol CameraScannerDelegate: AnyObject {
    func didScan(result: ScanResult)
    func didFail(error: ScanError)
}

public struct CameraScannerConfig {
    public var scanAreaSize: CGSize = CGSize(width: 250, height: 250)
    public var showTorch: Bool = true
    public var supportedTypes: [AVMetadataObject.ObjectType] = [.qr]
    
    public init() {}
}
