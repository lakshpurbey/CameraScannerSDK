//
//  CameraViewController.swift
//  CameraScannerSDK
//
//  Created by Laksh Purbey on 14/04/26.
//

import UIKit
import AVFoundation

final class CameraViewController: UIViewController {

    // MARK: - Properties

    private let session = AVCaptureSession()
    private var previewLayer: AVCaptureVideoPreviewLayer!
    private let metadataOutput = AVCaptureMetadataOutput()

    private let overlayView = OverlayView()
    private let animationView = ScanAnimationView()
    private let torchButton = UIButton(type: .system)

    private var isScanning = true

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black

        checkPermissionAndSetup()
        setupUI()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        previewLayer?.frame = view.bounds
        overlayView.frame = view.bounds
        animationView.frame = CGRect(
            x: view.bounds.midX - 125,
            y: view.bounds.midY - 125,
            width: 250,
            height: 250
        )
    }

    // MARK: - Permission

    private func checkPermissionAndSetup() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            setupCamera()

        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                DispatchQueue.main.async {
                    granted ? self.setupCamera() : self.showPermissionDenied()
                }
            }

        default:
            showPermissionDenied()
        }
    }

    private func showPermissionDenied() {
        let label = UILabel()
        label.text = "Camera permission required"
        label.textColor = .white
        label.textAlignment = .center
        label.frame = view.bounds
        view.addSubview(label)
    }

    // MARK: - Camera Setup

    private func setupCamera() {
        guard let device = AVCaptureDevice.default(for: .video),
              let input = try? AVCaptureDeviceInput(device: device),
              session.canAddInput(input)
        else { return }

        session.addInput(input)

        if session.canAddOutput(metadataOutput) {
            session.addOutput(metadataOutput)
            metadataOutput.setMetadataObjectsDelegate(self, queue: .main)
            metadataOutput.metadataObjectTypes = [.qr, .ean13, .code128]
        }

        previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.insertSublayer(previewLayer, at: 0)

        session.startRunning()
    }

    // MARK: - UI Setup

    private func setupUI() {
        // Overlay
        overlayView.frame = view.bounds
        view.addSubview(overlayView)

        // Animation
        view.addSubview(animationView)

        // Torch Button
        torchButton.setTitle("🔦", for: .normal)
        torchButton.tintColor = .white
        torchButton.addTarget(self, action: #selector(toggleTorch), for: .touchUpInside)

        torchButton.frame = CGRect(
            x: view.bounds.midX - 25,
            y: view.bounds.height - 100,
            width: 50,
            height: 50
        )

        view.addSubview(torchButton)
    }

    // MARK: - Torch

    @objc private func toggleTorch() {
        guard let device = AVCaptureDevice.default(for: .video),
              device.hasTorch else { return }

        do {
            try device.lockForConfiguration()
            device.torchMode = device.torchMode == .on ? .off : .on
            device.unlockForConfiguration()
        } catch {
            print("Torch error:", error)
        }
    }

    // MARK: - Scan Control

    private func handleScan(value: String) {
        guard isScanning else { return }
        isScanning = false

        // Haptic feedback
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()

        // Send result to SDK manager
        CameraScannerManager.shared.handleScan(result: value)

        // Pause scanning briefly
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.isScanning = true
        }
    }
}

// MARK: - AVCaptureMetadataOutputObjectsDelegate

extension CameraViewController: AVCaptureMetadataOutputObjectsDelegate {

    func metadataOutput(_ output: AVCaptureMetadataOutput,
                        didOutput metadataObjects: [AVMetadataObject],
                        from connection: AVCaptureConnection) {

        guard let object = metadataObjects.first as? AVMetadataMachineReadableCodeObject,
              let value = object.stringValue else { return }

        handleScan(value: value)
    }
}
