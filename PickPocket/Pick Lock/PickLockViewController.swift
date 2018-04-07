//
//  PickLockViewController.swift
//  PickPocket
//
//  Created by Maya Saxena on 3/22/18.
//  Copyright © 2018 Intrepid Pursuits. All rights reserved.
//

import UIKit
import Intrepid

final class PickLockViewController: UIViewController, UITableViewDataSource, ResetCodeViewControllerDelegate, KeypadViewDelegate {

    @IBOutlet private weak var previousGuessesTableView: UITableView!
    @IBOutlet private weak var lockStatusLabel: UILabel!
    @IBOutlet private weak var codeLengthLabel: UILabel!
    @IBOutlet private weak var guessLabel: UILabel!
    @IBOutlet private weak var keypadContainerView: UIView!

    private lazy var keypadView = KeypadView.ip_fromNib()

    private var viewModel = PickLockViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.isNavigationBarHidden = true

        setupTableView()
        setupKeypadView()
        updateUI()
    }

    private func setupTableView() {
        previousGuessesTableView.ip_registerCell(PickLockTableViewCell.self, identifier: PickLockTableViewCell.identifier)

        // Make the table view populate from bottom to top
        previousGuessesTableView.transform = CGAffineTransform(scaleX: 1, y: -1)
    }

    private func setupKeypadView() {
        keypadView.delegate = self

        keypadContainerView.addSubview(keypadView)
        keypadContainerView.constrainView(toAllEdges: keypadView)
    }

    private func updateUI() {
        codeLengthLabel.text = viewModel.codeLength
        lockStatusLabel.text = viewModel.lockStatusText
        guessLabel.text = viewModel.currentGuess
        previousGuessesTableView.reloadData()
    }

    // MARK: - Actions

    @IBAction func handleClearButtonPressed(_ sender: UIButton) {
        viewModel.handlePreviousGuessesCleared()
        updateUI()
    }
    
    @IBAction func handleResetButtonPressed(_ sender: UIButton) {
        let resetCodeViewController = ResetCodeViewController(viewModel: viewModel.resetCodeViewModel)
        resetCodeViewController.delegate = self
        navigationController?.pushViewController(resetCodeViewController, animated: true)
    }

    // MARK: - UITableViewDataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.previousGuessCount
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: PickLockTableViewCell = tableView.ip_dequeueCell(indexPath, identifier: PickLockTableViewCell.identifier)

        let (hint, guess) = viewModel.hintAndGuess(atIndex: indexPath.row)
        cell.configure(hint: hint, guess: guess)

        return cell
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
