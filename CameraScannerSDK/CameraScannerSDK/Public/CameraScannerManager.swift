//
//  CameraScannerManager.swift
//  CameraScannerSDK
//
//  Created by Laksh Purbey on 14/04/26.
//

import Foundation

public final class CameraScannerManager {

    public static let shared = CameraScannerManager()

    private init() {}

    private var onScan: ((ScanResult) -> Void)?

    // MARK: - Public API

    public func startScanning(onResult: @escaping (ScanResult) -> Void) {
        self.onScan = onResult
    }

    // MARK: - Internal Call (from CameraViewController)

    func handleScan(result: String) {
        let scan = ScanResult(value: result)
        onScan?(scan)
    }
}
