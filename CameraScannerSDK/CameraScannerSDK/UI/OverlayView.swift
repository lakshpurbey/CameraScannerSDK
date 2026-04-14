//
//  OverlayView.swift
//  CameraScannerSDK
//
//  Created by Laksh Purbey on 14/04/26.
//

import SwiftUI

final class OverlayView: UIView {

    private let borderLayer = CAShapeLayer()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) { fatalError() }

    private func setup() {
        borderLayer.strokeColor = UIColor.green.cgColor
        borderLayer.lineWidth = 2
        borderLayer.fillColor = UIColor.clear.cgColor
        
        layer.addSublayer(borderLayer)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        let rect = CGRect(x: bounds.midX - 125,
                          y: bounds.midY - 125,
                          width: 250,
                          height: 250)

        borderLayer.path = UIBezierPath(rect: rect).cgPath
    }
}
