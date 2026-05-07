//
//  TodoListCell.swift
//  todo
//
//  Created by Nikolai Eremenko on 20.04.2026.
//

import UIKit

final class TodoListCell: UITableViewCell {

    static let reuseId = "TodoListCell"

    var onCheckboxTapped: (() -> Void)?

    // MARK: - Private properties

    private var currentTitle = String()

    private lazy var textStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 10
        return stack
    }()

    private lazy var checkboxButton: UIButton = {
        let button = UIButton(type: .custom)
        let config = UIImage.SymbolConfiguration(pointSize: 28, weight: .thin)
        let circle = UIImage(systemName: "circle")?.withConfiguration(config)
        let check = UIImage(systemName: "checkmark.circle")?.withConfiguration(config)
        button.setImage(circle, for: .normal)
        button.setImage(check, for: .selected)
        button.tintColor = .secondaryLabel
        return button
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.numberOfLines = 1
        return label
    }()

    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.numberOfLines = 2
        return label
    }()

    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .secondaryLabel
        label.numberOfLines = 2
        return label
    }()

    // MARK: - Init

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setupView()
        setupConstraints()
        setupActions()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) not supported")
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        onCheckboxTapped = nil
        titleLabel.attributedText = nil
        titleLabel.text = nil
        descriptionLabel.text = nil
        dateLabel.text = nil
        checkboxButton.isSelected = false
    }

    // MARK: - Public methods

    func configure(with model: TodoCellViewModel) {
        currentTitle = model.title
        descriptionLabel.text = model.description
        dateLabel.text = model.dateText
        checkboxButton.isSelected = model.isCompleted
        checkboxButton.tintColor = model.isCompleted ? .systemYellow : .secondaryLabel
        updateAppearance(isCompleted: model.isCompleted)
    }

    // MARK: - Private methods

    private func updateAppearance(isCompleted: Bool) {

        let titleColor: UIColor =
        isCompleted ? .secondaryLabel : .label

        let descriptionColor: UIColor =
        isCompleted ? .secondaryLabel : .label

        descriptionLabel.textColor = descriptionColor
        dateLabel.textColor =
        isCompleted ? .tertiaryLabel : .secondaryLabel

        let attributes: [NSAttributedString.Key: Any] = {

            if isCompleted {
                return [
                    .strikethroughStyle: NSUnderlineStyle.single.rawValue,
                    .foregroundColor: titleColor
                ]
            } else {
                return [
                    .foregroundColor: titleColor
                ]
            }

        }()

        titleLabel.attributedText =
        NSAttributedString(
            string: currentTitle,
            attributes: attributes
        )
    }

    private func setupView() {
        selectionStyle = .none
        contentView.backgroundColor = .clear
        contentView.addSubviews([checkboxButton, textStack])
        textStack.addArrangedSubview(titleLabel)
        textStack.addArrangedSubview(descriptionLabel)
        textStack.addArrangedSubview(dateLabel)
    }

    // MARK: - Actions

    private func setupActions() {
        checkboxButton.addTarget(
            self,
            action: #selector(didTapCheckbox),
            for: .touchUpInside
        )
    }

    @objc
    private func didTapCheckbox() {
        onCheckboxTapped?()
    }

    // MARK: - Constraints

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            contentView.heightAnchor.constraint(lessThanOrEqualToConstant: 106),

            checkboxButton.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor,
                constant: 10
            ),

            checkboxButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            checkboxButton.widthAnchor.constraint(equalToConstant: 44),
            checkboxButton.heightAnchor.constraint(equalToConstant: 44),

            textStack.leadingAnchor.constraint(
                equalTo: checkboxButton.trailingAnchor,
                constant: 4
            ),

            textStack.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: -20
            ),

            textStack.topAnchor.constraint(
                equalTo: contentView.topAnchor,
                constant: 10
            ),

            textStack.bottomAnchor.constraint(
                equalTo: contentView.bottomAnchor,
                constant: -10
            )
        ])
    }
}
