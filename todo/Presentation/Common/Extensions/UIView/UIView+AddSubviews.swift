//
//  UIView+AddSubviews.swift
//  todo
//
//  Created by Nikolai Eremenko on 15.04.2026.
//

import UIKit

extension UIView {

    func addSubviews(
        _ views: [UIView],
        disableAutoresizingMask: Bool = true
    ) {
        views.forEach {
            addSubview($0)

            if disableAutoresizingMask {
                $0.translatesAutoresizingMaskIntoConstraints = false
            }
        }
    }
}
