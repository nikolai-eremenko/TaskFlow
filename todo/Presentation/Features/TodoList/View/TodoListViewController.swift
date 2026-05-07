//
//  TaskListViewController.swift
//  todo
//
//  Created by Nikolai Eremenko on 15.04.2026.
//

import UIKit

final class TodoListViewController: UIViewController {

    var output: TodoListViewOutput?

    // MARK: - Private properties

    private let logger: AppLogger

    private var isVisible = false
    private var pendingChange: TodoListViewChange?
    private var pendingDelete: (id: UUID, traceId: UUID)?

    private lazy var dataSource: TodoListDataSource = {
        TodoListDataSource(
            tableView: tableView,
            onCheckboxTapped: { [weak self] id in
                self?.output?.didTapCheckbox(id: id)
            }
        )
    }()

    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.keyboardDismissMode = .onDrag
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 90
        tableView.register(TodoListCell.self, forCellReuseIdentifier: TodoListCell.reuseId)
        return tableView
    }()

    private lazy var searchController: UISearchController = {
        let controller = UISearchController(searchResultsController: nil)
        controller.obscuresBackgroundDuringPresentation = false
        controller.searchResultsUpdater = self
        controller.searchBar.delegate = self
        return controller
    }()

    private lazy var countLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 11, weight: .regular)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // MARK: - Init

    init(logger: AppLogger) {
        self.logger = logger
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { nil }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        setupLayout()

        configureToolbarItems()

        let traceId = UUID()
        logger.debug("View did load", category: .userInterface, traceId: traceId)

        output?.viewDidLoad(traceId: traceId)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationItem.searchController = searchController
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.setToolbarHidden(false, animated: false)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        isVisible = true

        if let change = pendingChange {
            pendingChange = nil
            dataSource.apply(change: change)
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.setToolbarHidden(true, animated: false)

        isVisible = false
    }

    // MARK: - Private Methods

    private func setupUI() {
        title = String(localized: .titleScreenTodoList)

        definesPresentationContext = true

        view.backgroundColor = .systemBackground
        view.addSubviews([tableView])
    }

    private func configureToolbarItems() {
        setToolbarItems(
            [
                .flexibleSpace(),
                UIBarButtonItem(customView: countLabel),
                .flexibleSpace(),
                UIBarButtonItem(
                    barButtonSystemItem: .compose,
                    target: self,
                    action: #selector(didTapAdd)
                )
            ],
            animated: false
        )
    }

    // MARK: - Actions

    @objc
    private func didTapAdd() {
        let traceId = UUID()

        logger.debug("Did tap add", category: .userInterface, traceId: traceId)
        output?.didTapCreate(traceId: traceId)
    }

    // MARK: - Constraints

    private func setupLayout() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            countLabel.widthAnchor.constraint(equalToConstant: 100)
        ])
    }
}

extension TodoListViewController: TodoListViewInput {

    func render(change: TodoListViewChange, todosCount: Int) {
        if isVisible {
            dataSource.apply(change: change)
        } else {
            pendingChange = change
        }

        countLabel.text = String(localized: .titleTodoCount(todosCount))
    }

    func showError(message: String) {
        let alert = UIAlertController(
            title: String(localized: .titleAlertError),
            message: message,
            preferredStyle: .alert
        )

        alert.addAction(
            UIAlertAction(
                title: String(localized: .buttonAlertOk),
                style: .default
            )
        )
        present(alert, animated: true)
    }
}

// MARK: - UITableViewDelegate

extension TodoListViewController: UITableViewDelegate {

    func tableView(
        _ tableView: UITableView,
        contextMenuConfigurationForRowAt indexPath: IndexPath,
        point: CGPoint
    ) -> UIContextMenuConfiguration? {

        guard let item = dataSource.item(for: indexPath) else {
            return nil
        }

        let id = item.id

        return UIContextMenuConfiguration(
            identifier: id as NSCopying,
            previewProvider: {
                TodoListItemPreviewViewController(model: item)
            },
            actionProvider: { [weak self] _ in
                guard let self else { return nil }

                let edit = UIAction(
                    title: String(localized: .buttonEdit),
                    image: UIImage(systemName: "pencil")
                ) { _ in
                    self.output?.didSelectEdit(id: id)
                }

                let share = UIAction(
                    title: String(localized: .buttonShare),
                    image: UIImage(systemName: "square.and.arrow.up")
                ) { _ in
                    self.output?.didSelectShare(id: id)
                }

                let delete = UIAction(
                    title: String(localized: .buttonDelete),
                    image: UIImage(systemName: "trash"),
                    attributes: .destructive
                ) { _ in
                    let traceId = UUID()
                    self.logger.debug("Did tap delete", category: .userInterface, traceId: traceId)

                    self.pendingDelete = (id: id, traceId: traceId)
                }

                return UIMenu(title: "", children: [edit, share, delete])
            }
        )
    }

    func tableView(
        _ tableView: UITableView,
        willEndContextMenuInteraction configuration: UIContextMenuConfiguration,
        animator: UIContextMenuInteractionAnimating?
    ) {
        guard let pendingDelete else { return }

        animator?.addCompletion { [weak self] in
            self?.output?.didSelectDelete(
                id: pendingDelete.id,
                traceId: pendingDelete.traceId
            )
            self?.pendingDelete = nil
        }
    }
}

// MARK: - UISearchBarDelegate

extension TodoListViewController: UISearchBarDelegate {

    func searchBarCancelButtonClicked( _ searchBar: UISearchBar) {
        output?.didSearch(text: "")
    }
}

extension TodoListViewController: UISearchResultsUpdating {

    func updateSearchResults(for searchController: UISearchController) {
        let text = searchController.searchBar.text ?? ""

        output?.didSearch(text: text)
    }
}

// MARK: - Preview

#Preview("Loaded") {
    TodoListPreviewFactory.make(.loaded)
}

#Preview("Empty") {
    TodoListPreviewFactory.make(.empty)
}

#Preview("Error") {
    TodoListPreviewFactory.make(.error)
}
