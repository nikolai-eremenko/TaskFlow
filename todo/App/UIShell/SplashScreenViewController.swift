//
//  SplashScreenViewController.swift
//  todo
//
//  Created by Nikolai Eremenko on 15.04.2026.
//

import UIKit

final class SplashScreenViewController: UIViewController {

    private lazy var logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage.Ic.logo
        return imageView
    }()

    private lazy var appNameLabel: UILabel = {
        let view = UILabel()
        view.text = String(localized: .appName)
        view.font = .systemFont(ofSize: 50, weight: .bold)
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupLayout()
    }

    private func setupViews() {
        view.backgroundColor = .systemBackground
        view.addSubviews(
            [logoImageView, appNameLabel]
        )
    }

    private func setupLayout() {
        setupConstraintsLogoImageView()
        setupConstraintsAppNameLabel()
    }

    private func setupConstraintsLogoImageView() {
        NSLayoutConstraint.activate([
            logoImageView.centerXAnchor.constraint(
                equalTo: view.centerXAnchor
            ),
            logoImageView.centerYAnchor.constraint(
                equalTo: view.centerYAnchor
            ),
            logoImageView.widthAnchor.constraint(equalToConstant: 240),
            logoImageView.heightAnchor.constraint(equalToConstant: 240)
        ])
    }

    private func setupConstraintsAppNameLabel() {
        NSLayoutConstraint.activate([
            appNameLabel.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 40),
            appNameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
}

// MARK: - Preview

#if DEBUG
@available(iOS 17.0, *)
#Preview("Splash") {
    SplashScreenViewController()
}
#endif
