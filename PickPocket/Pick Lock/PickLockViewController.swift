//
//  PickLockViewController.swift
//  PickPocket
//
//  Created by Maya Saxena on 3/22/18.
//  Copyright © 2018 Intrepid Pursuits. All rights reserved.
//

import UIKit
import Intrepid

final class PickLockViewController: UIViewController, ResetCodeViewControllerDelegate, KeypadViewDelegate {

    @IBOutlet private weak var previousGuessHintLabel: UILabel!
    @IBOutlet private weak var previousGuessLabel: UILabel!
    @IBOutlet private weak var lockStatusLabel: UILabel!
    @IBOutlet private weak var codeLengthLabel: UILabel!
    @IBOutlet private weak var guessLabel: UILabel!
    @IBOutlet private weak var keypadContainerView: UIView!

    private lazy var keypadView = KeypadView.ip_fromNib()

    private var viewModel = PickLockViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.isNavigationBarHidden = true

        setupKeypadView()
        updateUI()
    }

    private func setupKeypadView() {
        keypadView.delegate = self

        keypadContainerView.addSubview(keypadView)
        keypadContainerView.constrainView(toAllEdges: keypadView)
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

    // MARK: - ResetCodeViewControllerDelegate

    func resetCodeViewController(_ viewController: ResetCodeViewController, didSetNewCode newCode: String) {
        viewModel.updateCode(newCode: newCode)
        updateUI()
    }

    // MARK: - KeypadViewDelegate

    func keypadView(_ view: KeypadView, didPressDigit digit: String) {
        viewModel.handleDigitAdded(digit: digit)
        updateUI()
    }
}
