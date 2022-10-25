//
//  LinkView.swift
//  GameTracker
//
//  Created by Marina Aguiar on 10/24/22.
//

import UIKit

class LinkView: UIView {

    let view = UIView()
    let stackView = UIStackView()
    let label = UILabel()
    let imageView = UIImageView()

    enum `Type` {
        case rule, website
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }

    private func setupLayout() {
        self.addSubview(view)

        let imageHeight: CGFloat = 22
        let fontSize: CGFloat = 16
        let imageMinWidth: CGFloat = 18
        let imageMaxWidth: CGFloat = 22
        let cornerRadius: CGFloat = 8
        let spacing: CGFloat = 0

        view.backgroundColor = .cyan
        view.layer.cornerRadius = cornerRadius
        view.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(stackView)
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = spacing
        stackView.translatesAutoresizingMaskIntoConstraints = false

        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(label)

        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false

        label.clipsToBounds = true
        label.font = .systemFont(ofSize: fontSize)
        label.textColor = DSColor.light
        label.numberOfLines = 1
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: self.topAnchor),
            view.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            view.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: CGFloat(-12)),

            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: CGFloat(18)),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: CGFloat(-18)),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),

            imageView.heightAnchor.constraint(equalToConstant: imageHeight),
            imageView.widthAnchor.constraint(greaterThanOrEqualToConstant: imageMinWidth),
            imageView.widthAnchor.constraint(lessThanOrEqualToConstant: imageMaxWidth),

            label.widthAnchor.constraint(greaterThanOrEqualToConstant: CGFloat(20))
        ])
    }

    func updateCell(type: `Type`) {

        switch type {
        case .rule:
            view.backgroundColor = DSColor.purple
            label.text = "Game Rules"
            imageView.image = DSImages.dices
        case .website:
            view.backgroundColor = DSColor.blue
            label.text = "More Info"
            imageView.image = DSImages.website
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
