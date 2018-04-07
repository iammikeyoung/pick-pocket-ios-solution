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

final class ResetCodeViewController: UIViewController {

    @IBOutlet private weak var previousCodeLabel: UILabel!
    @IBOutlet private weak var currentCodeLabel: UILabel!

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
        title = "My Code"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(handleBackButtonPressed))

        previousCodeLabel.text = viewModel.previousCode
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = true
    }

    // MARK: - Actions

    @IBAction func backspaceButtonPressed(_ sender: UIButton) {
        viewModel.handleLastDigitRemoved()
        currentCodeLabel.text = viewModel.currentCode
    }

    @objc private func handleBackButtonPressed() {
        delegate?.resetCodeViewController(self, didSetNewCode: viewModel.currentCode)
        navigationController?.popViewController(animated: true)
    }
}
