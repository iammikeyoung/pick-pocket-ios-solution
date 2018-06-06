//
//  PickLockViewController.swift
//  PickPocket
//
//  Created by Maya Saxena on 3/22/18.
//  Copyright © 2018 Intrepid Pursuits. All rights reserved.
//

import UIKit

final class PickLockViewController: UIViewController, PickLockViewModelDelegate {

    @IBOutlet private weak var previousGuessHintLabel: UILabel!
    @IBOutlet private weak var previousGuessLabel: UILabel!
    @IBOutlet private weak var readoutView: UIView!
    @IBOutlet private weak var lockStatusLabel: UILabel!
    @IBOutlet private weak var codeLengthLabel: UILabel!
    @IBOutlet private weak var currentGuessLabel: UILabel!
    @IBOutlet private weak var keypadView: UIStackView!

    private var viewModel = PickLockViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        viewModel.handleViewDidLoad()
    }

    @IBAction func handleKeypadButtonPressed(_ sender: KeypadButton) {
        viewModel.handleDigitAdded(sender.digit)
    }

    // MARK: - PickLockViewModelDelegate

    func pickLockViewModelDidUpdate(previousGuessHintText: String, previousGuessText: String) {
        previousGuessHintLabel.text = previousGuessHintText
        previousGuessLabel.text = previousGuessText
    }

    func pickLockViewModelDidUpdate(readoutColor: UIColor) {
        readoutView.backgroundColor = readoutColor
    }

    func pickLockViewModelDidUpdate(lockStatusText: String) {
        lockStatusLabel.text = lockStatusText
    }

    func pickLockViewModelDidUpdate(codeLengthText: String) {
        codeLengthLabel.text = codeLengthText
    }

    func pickLockViewModelDidUpdate(currentGuessText: String) {
        currentGuessLabel.text = currentGuessText
    }

    func pickLockViewModelDidUpdate(isKeypadEnabled: Bool) {
        keypadView.isUserInteractionEnabled = isKeypadEnabled
    }
}
