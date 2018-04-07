//
//  KeypadView.swift
//  PickPocket
//
//  Created by Maya Saxena on 4/7/18.
//  Copyright © 2018 Intrepid Pursuits. All rights reserved.
//

import UIKit

protocol KeypadViewDelegate: class {
    func keypadView(_ view: KeypadView, didPressDigit digit: String)
}

final class KeypadView: UIView {
    weak var delegate: KeypadViewDelegate?

    @IBAction func keypadButtonPressed(_ sender: KeypadButton) {
        delegate?.keypadView(self, didPressDigit: sender.digit)
    }
}

final class KeypadButton: UIButton {
    @IBInspectable var digit: String = ""
}
