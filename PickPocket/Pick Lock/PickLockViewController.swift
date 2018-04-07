//
//  PickLockViewController.swift
//  PickPocket
//
//  Created by Maya Saxena on 3/22/18.
//  Copyright © 2018 Intrepid Pursuits. All rights reserved.
//

import UIKit

final class PickLockViewController: UIViewController, ResetCodeViewControllerDelegate {

    @IBOutlet private weak var previousGuessHintLabel: UILabel!
    @IBOutlet private weak var previousGuessLabel: UILabel!
    @IBOutlet private weak var lockStatusLabel: UILabel!
    @IBOutlet private weak var codeLengthLabel: UILabel!
    @IBOutlet private weak var guessLabel: UILabel!

    private var viewModel = PickLockViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        updateUI()
    }

    private func updateUI() {
        codeLengthLabel.text = viewModel.codeLength
        previousGuessHintLabel.text = viewModel.previousGuessHintText
        previousGuessLabel.text = viewModel.previousGuessText
        lockStatusLabel.text = viewModel.lockStatusText
        guessLabel.text = viewModel.currentGuess
    }

    // MARK: - Actions

    @IBAction func handleResetButtonPressed(_ sender: UIButton) {
        let resetCodeViewController = ResetCodeViewController(viewModel: viewModel.resetCodeViewModel)
        resetCodeViewController.delegate = self
        navigationController?.pushViewController(resetCodeViewController, animated: true)
    }

    @IBAction func handleKeypadButtonPressed(_ sender: KeypadButton) {
        viewModel.handleDigitAdded(digit: sender.digit)
        updateUI()
    }

    // MARK: - ResetCodeViewControllerDelegate

    func resetCodeViewController(_ viewController: ResetCodeViewController, didSetNewCode newCode: String) {
        viewModel.updateCode(newCode: newCode)
        updateUI()
    }
}
