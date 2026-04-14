//
//  ScanAnimationView.swift
//  CameraScannerSDK
//
//  Created by Laksh Purbey on 14/04/26.
//

import SwiftUI

final class ScanAnimationView: UIView {

    private let line = UIView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        animate()
    }

    required init?(coder: NSCoder) { fatalError() }

    private func setup() {
        line.backgroundColor = .green
        addSubview(line)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        line.frame = CGRect(x: 0, y: 0, width: bounds.width, height: 2)
    }

    private func animate() {
        UIView.animate(withDuration: 2.0,
                       delay: 0,
                       options: [.repeat, .autoreverse],
                       animations: {
            self.line.frame.origin.y = self.bounds.height
        })
    }
}
