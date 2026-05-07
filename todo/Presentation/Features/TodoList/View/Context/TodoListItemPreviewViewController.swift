//
//  TodoListItemPreviewViewController.swift
//  todo
//
//  Created by Nikolai Eremenko on 28.04.2026.
//

import UIKit

final class TodoListItemPreviewViewController: UIViewController {

    // MARK: - Private properties

    private let model: TodoCellViewModel
    private let contentView = TodoListItemView()

    private lazy var container: UIView = {
        let view = UIView()
        return view
    }()

    // MARK: - Init

    init(model: TodoCellViewModel) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError() }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground

        setupView()
        setupConstraints()
        applyModel()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        let size = contentView.systemLayoutSizeFitting(
            CGSize(width: view.bounds.width - 24, height: UIView.layoutFittingCompressedSize.height)
        )

        preferredContentSize = CGSize(
            width: view.bounds.width,
            height: size.height + 24
        )
    }

    // MARK: - Private methods

    private func setupView() {
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        view.layer.cornerCurve = .continuous

        view.addSubviews([container])
        container.addSubviews([contentView])
    }

    private func applyModel() {
        contentView.configure(
            title: model.title,
            description: model.description,
            date: model.dateText
        )
    }

    // MARK: - Constraints

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            container.topAnchor.constraint(equalTo: view.topAnchor),
            container.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            container.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            container.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            contentView.topAnchor.constraint(equalTo: container.topAnchor, constant: 12),
            contentView.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 12),
            contentView.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -12)
        ])
    }
}
