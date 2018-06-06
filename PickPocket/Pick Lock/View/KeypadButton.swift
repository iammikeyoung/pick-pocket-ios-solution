//
//  KeypadButton.swift
//  PickPocket
//
//  Created by Maya Saxena on 6/6/18.
//  Copyright © 2018 Intrepid Pursuits. All rights reserved.
//

import UIKit

final class KeypadButton: UIButton {
    @IBInspectable var digit: String = "" {
        didSet {
            setTitle(digit, for: .normal)
        }
    }
}
