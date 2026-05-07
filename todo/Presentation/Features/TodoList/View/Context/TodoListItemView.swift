//
//  TodoListItemView.swift
//  todo
//
//  Created by Nikolai Eremenko on 28.04.2026.
//

import UIKit

final class TodoListItemView: UIView {

    // MARK: - Private properties

    private lazy var stack: UIStackView = {
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
        label.numberOfLines = 3
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

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraints()
    }

    required init?(coder: NSCoder) { fatalError() }

    // MARK: - Public methods

    func configure(title: String, description: String?, date: String) {
        titleLabel.text = title
        descriptionLabel.text = description
        dateLabel.text = date
    }

    // MARK: - Private methods

    private func setupView() {
        addSubviews([stack])
        stack.addArrangedSubview(titleLabel)
        stack.addArrangedSubview(descriptionLabel)
        stack.addArrangedSubview(dateLabel)
    }

    // MARK: - Constraints

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: topAnchor),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor),
            stack.leadingAnchor.constraint(equalTo: leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
}
