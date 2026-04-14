//
//  ScanError.swift
//  CameraScannerSDK
//
//  Created by Laksh Purbey on 14/04/26.
//


public enum ScanError: Error {
    case cameraUnavailable
    case permissionDenied
    case scanningFailed
}
