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

    private var isVoiceInputActive = false
    private let emptyInputView = UIView(frame: .zero)

    private lazy var dataSource: TodoListDataSource = {
        TodoListDataSource(
            tableView: tableView,
            onCheckboxTapped: { [weak self] id in
                self?.output?.didTapCheckbox(id: id)
            }
        )
    }()

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 90
        tableView.contentInsetAdjustmentBehavior = .automatic
        tableView.register(TodoListCell.self, forCellReuseIdentifier: TodoListCell.reuseId)
        return tableView
    }()

    private lazy var searchController: UISearchController = {
        let controller = UISearchController()
        controller.searchBar.showsBookmarkButton = true
        controller.searchBar.setImage(UIImage(systemName: "microphone"), for: .bookmark, state: [])
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

    private lazy var composeButton: UIBarButtonItem = {
        let button = UIButton(type: .system)

        button.setImage(
            UIImage(systemName: "square.and.pencil"),
            for: .normal
        )

        button.addAction(
            UIAction { [weak self] _ in
                guard let self else { return }

                let traceId = UUID()

                self.logger.debug(
                    "Did tap add",
                    category: .userInterface,
                    traceId: traceId
                )

                self.output?.didTapCreate(traceId: traceId)
            },
            for: .touchUpInside
        )

        return UIBarButtonItem(customView: button)
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

        setupView()
        setupLayout()

        let traceId = UUID()
        logger.debug("View did load", category: .userInterface, traceId: traceId)

        output?.viewDidLoad(traceId: traceId)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        setupNavController(animated)

        isVisible = true

        if let change = pendingChange {
            pendingChange = nil
            dataSource.apply(change: change)
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        isVisible = false
    }

    // MARK: - Private Methods

    private func setupView() {

        view.backgroundColor = .systemBackground
        view.addSubviews([tableView])
    }

    private func setupNavController(_ animated: Bool) {

        navigationController?.navigationBar.isTranslucent = true
        navigationController?.setToolbarHidden(false, animated: animated)

        if navigationItem.searchController == nil {
            navigationItem.searchController = searchController
        }

        navigationItem.title = String(localized: .titleScreenTodoList)
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.hidesSearchBarWhenScrolling = false

        let flexibleSpace = UIBarButtonItem.flexibleSpace()

        if #available(iOS 26.0, *) {
            setToolbarItems([
                navigationItem.searchBarPlacementBarButtonItem,
                flexibleSpace,
                composeButton
            ], animated: animated)

        } else {
            setToolbarItems([
                flexibleSpace,
                UIBarButtonItem(customView: countLabel),
                flexibleSpace,
                composeButton
            ], animated: animated)
        }
    }

    private func findBookmarkButton() -> UIButton? {
        return searchController.searchBar.subviews
            .flatMap { $0.subviews }
            .compactMap { $0 as? UIButton }
            .first
    }

    private func setMicPulsing(_ enabled: Bool) {

        guard let button = findBookmarkButton() else { return }

        button.layer.removeAnimation(forKey: "pulse")

        guard enabled else { return }

        let animation = CABasicAnimation(keyPath: "transform.scale")
        animation.fromValue = 1.0
        animation.toValue = 1.2
        animation.duration = 0.6
        animation.autoreverses = true
        animation.repeatCount = .infinity

        button.layer.add(animation, forKey: "pulse")
    }

    // MARK: - Constraints

    private func setupLayout() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

// MARK: - TodoListViewInput

extension TodoListViewController: TodoListViewInput {

    func render(change: TodoListViewChange, todosCount: Int) {
        if isVisible {
            dataSource.apply(change: change)
        } else {
            pendingChange = change
        }

        if #available(iOS 26.0, *) {
            navigationItem.subtitle = String(localized: .titleTodoCount(todosCount))
        } else {
            countLabel.text = String(localized: .titleTodoCount(todosCount))
        }
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

    func updateSearchText(_ text: String) {
        let searchBar = searchController.searchBar

        guard searchBar.text != text else { return }

        searchBar.text = text

        output?.didSearch(text: text)
    }

    func setVoiceInputState(_ state: VoiceInputStateUI) {
        let searchBar = searchController.searchBar
        let textField = searchBar.searchTextField

        switch state {

        case .idle:
            isVoiceInputActive = false

            textField.inputView = nil
            textField.reloadInputViews()

            searchBar.setImage(
                UIImage(systemName: "microphone"),
                for: .bookmark,
                state: .normal
            )

            searchBar.tintColor = nil
            setMicPulsing(false)

        case .recording:
            isVoiceInputActive = true

            // 🔥 search becomes active
            searchController.isActive = true

            // 🔥 focus text field WITHOUT keyboard
            textField.inputView = emptyInputView
            textField.reloadInputViews()

            if !textField.isFirstResponder {
                textField.becomeFirstResponder()
            }

            searchBar.setImage(
                UIImage(systemName: "mic.fill"),
                for: .bookmark,
                state: .normal
            )

            searchBar.tintColor = .systemRed
            setMicPulsing(true)

        case .processing:
            searchBar.setImage(
                UIImage(systemName: "waveform"),
                for: .bookmark,
                state: .normal
            )

            searchBar.tintColor = .systemBlue
            setMicPulsing(false)

        case .unavailable:
            searchBar.setImage(
                UIImage(systemName: "mic.slash"),
                for: .bookmark,
                state: .normal
            )

            searchBar.tintColor = .systemGray
            setMicPulsing(false)

        case .error:
            searchBar.setImage(
                UIImage(systemName: "exclamationmark.mic"),
                for: .bookmark,
                state: .normal
            )

            searchBar.tintColor = .systemOrange
            setMicPulsing(false)
        }
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

    func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
        let traceId = UUID()
        logger.debug("Did tap microphone", category: .userInterface, traceId: traceId)
        output?.didTapVoiceSearch(traceId)
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
