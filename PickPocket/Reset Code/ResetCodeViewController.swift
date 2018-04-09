//
//  ResetCodeViewController.swift
//  PickPocket
//
//  Created by Maya Saxena on 4/7/18.
//  Copyright © 2018 Intrepid Pursuits. All rights reserved.
//

import UIKit

protocol ResetCodeViewControllerDelegate: class {
    func resetCodeViewController(_ viewController: ResetCodeViewController, didSetNewCode newCode: String)
}

final class ResetCodeViewController: UIViewController, KeypadViewDelegate {

    @IBOutlet private weak var previousCodeLabel: UILabel!
    @IBOutlet private weak var currentCodeLabel: UILabel!
    @IBOutlet private weak var keypadContainerView: UIView!

    private lazy var keypadView = KeypadView.ip_fromNib()
    private lazy var backButtonItem: UIBarButtonItem = {
        return UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(handleBackButtonPressed))
    }()

    private var viewModel: ResetCodeViewModel

    weak var delegate: ResetCodeViewControllerDelegate?

    init(viewModel: ResetCodeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupKeypadView()

        previousCodeLabel.text = viewModel.previousCode
        updateUI()
    }

    // MARK: - Setup

    private func setupNavigationBar() {
        title = "My Code"
        navigationItem.leftBarButtonItem = backButtonItem
    }

    private func setupKeypadView() {
        keypadView.delegate = self

        keypadContainerView.addSubview(keypadView)
        keypadContainerView.constrainView(toAllEdges: keypadView)
    }

    private func updateUI() {
        currentCodeLabel.text = viewModel.currentCode
        backButtonItem.isEnabled = viewModel.isBackButtonEnabled
    }

    // MARK: - Actions

    @IBAction func backspaceButtonPressed(_ sender: UIButton) {
        viewModel.handleLastDigitRemoved()
        updateUI()
    }

    @objc private func handleBackButtonPressed() {
        delegate?.resetCodeViewController(self, didSetNewCode: viewModel.currentCode)
        navigationController?.popViewController(animated: true)
    }

    // MARK: - KeypadViewDelegate

    func keypadView(_ view: KeypadView, didPressDigit digit: String) {
        viewModel.handleDigitAdded(digit: digit)
        updateUI()
    }
}
