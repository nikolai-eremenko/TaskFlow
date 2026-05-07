//
//  TodoDetailsViewController.swift
//  todo
//
//  Created by Nikolai Eremenko on 20.04.2026.
//

import UIKit

final class TodoDetailsViewController: UIViewController {

    var output: TodoDetailsViewOutput?

    // MARK: - Private properties

    private lazy var titleTextField: UITextField = {
        let textField = UITextField()
        textField.font = .systemFont(ofSize: 34, weight: .bold)
        textField.placeholder = "Название"
        textField.borderStyle = .none
        textField.returnKeyType = .next
        textField.delegate = self
        textField.addAction(UIAction { [weak self] _ in
            self?.notifyChanges()
        }, for: .editingChanged)
        return textField
    }()

    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textColor = .secondaryLabel
        label.numberOfLines = 1
        return label
    }()

    private lazy var descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.font = .systemFont(ofSize: 16)
        textView.backgroundColor = .clear
        textView.delegate = self
        textView.returnKeyType = .done
        return textView
    }()

    private lazy var descriptionPlaceholderLabel: UILabel = {
        let label = UILabel()
        label.text = "Описание"
        label.textColor = .placeholderText
        label.font = .systemFont(ofSize: 16)
        label.numberOfLines = 1
        return label
    }()

    private lazy var vStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            titleTextField,
            dateLabel,
            descriptionTextView
        ])
        stackView.axis = .vertical
        stackView.spacing = 8
        return stackView
    }()

    private lazy var saveButton: UIBarButtonItem = {
        let action = UIAction { [weak self] _ in
            guard let self else { return }

            self.output?.didTapSave(
                title: titleTextField.text ?? "",
                description: descriptionTextView.text
            )
        }

        return UIBarButtonItem(systemItem: .save, primaryAction: action)
    }()

    private lazy var dismissKeyboardTap = UITapGestureRecognizer(
        target: self,
        action: #selector(dismissKeyboard)
    )

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        setupLayout()

        output?.viewDidLoad()
    }

    // MARK: - Private methods

    private func setupView() {
        navigationItem.rightBarButtonItem = saveButton
        view.backgroundColor = .systemBackground
        view.addGestureRecognizer(dismissKeyboardTap)
        view.addSubviews([vStackView])
        descriptionTextView.addSubviews([descriptionPlaceholderLabel])
    }

    private func updatePlaceholder() {
        descriptionPlaceholderLabel.isHidden = !descriptionTextView.text.isEmpty
    }

    private func notifyChanges() {
        output?.didChange(
            title: titleTextField.text ?? "",
            description: descriptionTextView.text
        )
    }

    // MARK: - Actions

    @objc
    private func dismissKeyboard() {
        view.endEditing(true)
    }

    // MARK: - Constraints

    private func setupLayout() {
        NSLayoutConstraint.activate([
            vStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            vStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            vStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            descriptionTextView.heightAnchor.constraint(greaterThanOrEqualToConstant: 300),

            descriptionPlaceholderLabel.topAnchor.constraint(
                equalTo: descriptionTextView.topAnchor,
                constant: 8
            ),

            descriptionPlaceholderLabel.leadingAnchor.constraint(
                equalTo: descriptionTextView.leadingAnchor,
                constant: 5
            )
        ])
    }
}

// MARK: - TodoDetailsViewInput

extension TodoDetailsViewController: TodoDetailsViewInput {

    func setSaveEnabled(_ isEnabled: Bool) {
        saveButton.isEnabled = isEnabled
    }

    func display(todo: Todo) {
        Task { @MainActor in
            titleTextField.text = todo.title
            descriptionTextView.text = todo.taskDescription
            dateLabel.text = AppDateFormatters.localizedDateOnly.string(from: todo.createdAt)
            updatePlaceholder()
        }
    }

    func displayCreateState() {
        titleTextField.text = ""
        descriptionTextView.text = ""
        dateLabel.text = "Now"
        updatePlaceholder()
    }

    func showError(message: String) {
        let alert = UIAlertController(
            title: "Ошибка",
            message: message,
            preferredStyle: .alert
        )

        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - UITextFieldDelegate

extension TodoDetailsViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {

        if textField == titleTextField {
            descriptionTextView.becomeFirstResponder()
        }

        return true
    }
}

// MARK: - UITextViewDelegate

extension TodoDetailsViewController: UITextViewDelegate {

    func textViewDidChange(_ textView: UITextView) {
        updatePlaceholder()
        notifyChanges()
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
        updatePlaceholder()
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        updatePlaceholder()
    }

    func textView(
        _ textView: UITextView,
        shouldChangeTextIn range: NSRange,
        replacementText text: String
    ) -> Bool {

        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }

        return true
    }
}
