//
//  TodoChangeObserver.swift
//  todo
//
//  Created by Nikolai Eremenko on 24.04.2026.
//

import CoreData
import Foundation

final class TodoChangeObserver: NSObject {

    var onChange: ((TodoChange) -> Void)?

    private let frc: NSFetchedResultsController<TodoEntity>

    private var hasStructuralChanges = false

    // MARK: - Init

    init(context: NSManagedObjectContext) {

        let request: NSFetchRequest<TodoEntity> = TodoEntity.fetchRequest()
        request.sortDescriptors = [
            NSSortDescriptor(key: "createdAt", ascending: true)
        ]

        frc = NSFetchedResultsController(
            fetchRequest: request,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil
        )

        super.init()
        frc.delegate = self
    }

    // MARK: - Public methods

    func start() {
        try? frc.performFetch()
        emitReload()
    }

    func updateSearch(text: String) {

        if text.isEmpty {
            frc.fetchRequest.predicate = nil
        } else {
            frc.fetchRequest.predicate = NSCompoundPredicate(orPredicateWithSubpredicates: [
                NSPredicate(format: "title CONTAINS[cd] %@", text),
                NSPredicate(format: "taskDescription CONTAINS[cd] %@", text)
            ])
        }

        try? frc.performFetch()
        emitReload()
    }

    // MARK: - Private methods

    private func emitReload() {
        let todos = (frc.fetchedObjects ?? []).map(Todo.init)
        onChange?(.reload(todos))
    }
}

// MARK: - NSFetchedResultsControllerDelegate

extension TodoChangeObserver: NSFetchedResultsControllerDelegate {

    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        hasStructuralChanges = false
    }

    func controller(
        _ controller: NSFetchedResultsController<NSFetchRequestResult>,
        didChange anObject: Any,
        at indexPath: IndexPath?,
        for type: NSFetchedResultsChangeType,
        newIndexPath: IndexPath?
    ) {
        guard let entity = anObject as? TodoEntity else { return }

        let todo = Todo(entity: entity)

        switch type {

        case .update:
            onChange?(.update(todo))

        case .insert, .move, .delete:
            hasStructuralChanges = true

        @unknown default:
            break
        }
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {

        if hasStructuralChanges {
            emitReload()
        }
    }
}
