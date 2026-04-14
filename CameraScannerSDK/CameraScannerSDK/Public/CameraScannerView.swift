//
//  Untitled.swift
//  CameraScannerSDK
//
//  Created by Laksh Purbey on 14/04/26.
//

import SwiftUI

public struct CameraScannerView: UIViewControllerRepresentable {

    let config: CameraScannerConfig

    public init(config: CameraScannerConfig) {
        self.config = config
    }

    public func makeUIViewController(context: Context) -> UIViewController {
        return CameraViewController(config: config)
    }

    public func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}
