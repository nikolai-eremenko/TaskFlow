//
//  TodoListDataSource.swift
//  todo
//
//  Created by Nikolai Eremenko on 23.04.2026.
//

import UIKit

final class TodoListDataSource {

    typealias Item = UUID
    typealias Snapshot = NSDiffableDataSourceSnapshot<Int, Item>

    // MARK: - Private properties

    private let tableView: UITableView
    private let onCheckboxTapped: (UUID) -> Void

    private var viewModels: [UUID: TodoCellViewModel] = [:]

    private lazy var dataSource: UITableViewDiffableDataSource<Int, Item> = {
        UITableViewDiffableDataSource<Int, Item>(
            tableView: tableView
        ) { [weak self] (tableView: UITableView, indexPath: IndexPath, itemIdentifier: UUID) -> UITableViewCell? in

            guard
                let self,
                let item = self.viewModels[itemIdentifier]
            else {
                return UITableViewCell()
            }

            let cell = tableView.dequeueReusableCell(TodoListCell.self, for: indexPath)

            cell.configure(with: item)
            cell.onCheckboxTapped = {
                self.onCheckboxTapped(itemIdentifier)
            }

            return cell
        }
    }()

    // MARK: - Init

    init(
        tableView: UITableView,
        onCheckboxTapped: @escaping (UUID) -> Void
    ) {
        self.tableView = tableView
        self.onCheckboxTapped = onCheckboxTapped
    }

    func apply(change: TodoListViewChange) {
        var snapshot = dataSource.snapshot()

        switch change {

        case .reload(let items):
            viewModels = Dictionary(uniqueKeysWithValues: items.map { ($0.id, $0) })

            snapshot.deleteAllItems()
            snapshot.appendSections([0])
            snapshot.appendItems(items.map { $0.id })

        case .update(let model):
            viewModels[model.id] = model

            guard snapshot.indexOfItem(model.id) != nil else { break }

            if snapshot.indexOfItem(model.id) != nil {
                snapshot.reconfigureItems([model.id])
            }
        }

        dataSource.apply(snapshot, animatingDifferences: true)
    }

    func item(for indexPath: IndexPath) -> TodoCellViewModel? {
        guard let id = dataSource.itemIdentifier(for: indexPath) else { return nil }
        return viewModels[id]
    }
}
