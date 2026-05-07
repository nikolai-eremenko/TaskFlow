//
//  UITableView+Cell.swift
//  todo
//
//  Created by Nikolai Eremenko on 27.04.2026.
//

import UIKit

extension UITableView {

    func dequeueReusableCell<T: UITableViewCell>(
        _ type: T.Type,
        for indexPath: IndexPath
    ) -> T {
        guard let cell = dequeueReusableCell(
            withIdentifier: String(describing: type),
            for: indexPath
        ) as? T else {
            fatalError("Could not dequeue cell: \(type)")
        }
        return cell
    }
}
