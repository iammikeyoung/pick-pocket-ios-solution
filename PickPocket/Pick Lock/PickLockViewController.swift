//
//  PickLockViewController.swift
//  PickPocket
//
//  Created by Maya Saxena on 3/22/18.
//  Copyright © 2018 Intrepid Pursuits. All rights reserved.
//

import UIKit

final class PickLockViewController: UIViewController {

    @IBOutlet private weak var previousGuessHintLabel: UILabel!
    @IBOutlet private weak var previousGuessLabel: UILabel!
    @IBOutlet private weak var lockStatusLabel: UILabel!
    @IBOutlet private weak var codeLengthLabel: UILabel!
    @IBOutlet private weak var guessLabel: UILabel!

    private var viewModel = PickLockViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        codeLengthLabel.text = viewModel.codeLength
        updateUI()
    }

    @IBAction func handleKeypadButtonPressed(_ sender: KeypadButton) {
        viewModel.handleDigitAdded(digit: sender.digit)
        updateUI()
    }

    private func updateUI() {
        previousGuessHintLabel.text = viewModel.previousGuessHintText
        previousGuessLabel.text = viewModel.previousGuessText
        lockStatusLabel.text = viewModel.lockStatusText
        guessLabel.text = viewModel.currentGuess
    }
}
