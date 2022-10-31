//
//  ChipView.swift
//  GameTracker
//
//  Created by Marina Aguiar on 10/5/22.
//

import UIKit

class ChipView: UIView {

    let view = UIView()
    let stackView = UIStackView()
    let label = UILabel()
    let imageView = UIImageView()

    var size: Size

    enum Size {
        case small, medium
    }

    init(frame: CGRect, size: Size) {
        self.size = size
        super.init(frame: frame)
        setupLayout(size: size)
    }

    private func setupLayout(size: Size) {
        self.addSubview(view)

        let imageHeight: CGFloat
        let fontSize: CGFloat
        let imageMinWidth: CGFloat
        let imageMaxWidth: CGFloat
        let cornerRadius: CGFloat
        let backgroundColor: UIColor
        let spacing: CGFloat

        switch size {
        case .small:
            imageHeight = 14
            imageMinWidth = 8
            imageMaxWidth = 16
            fontSize = 11
            cornerRadius = 10
            backgroundColor = DSColor.light!
            spacing = 5
        case .medium:
            imageHeight = 16
            imageMinWidth = 14
            imageMaxWidth = 18
            fontSize = 15
            cornerRadius = 12
            backgroundColor = .white
            spacing = 8
        }

        view.backgroundColor = backgroundColor
        view.layer.cornerRadius = cornerRadius
        view.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(stackView)
        stackView.axis = .horizontal
        stackView.spacing = spacing
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false

        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(label)

        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false

        label.clipsToBounds = true
        label.font = .systemFont(ofSize: fontSize)
        label.textColor = .darkGray
        label.numberOfLines = 1
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: self.topAnchor),
            view.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            view.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: self.trailingAnchor),

            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: CGFloat(10)),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: CGFloat(-10)),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),

            imageView.heightAnchor.constraint(equalToConstant: imageHeight),
            imageView.widthAnchor.constraint(greaterThanOrEqualToConstant: imageMinWidth),
            imageView.widthAnchor.constraint(lessThanOrEqualToConstant: imageMaxWidth),

            label.widthAnchor.constraint(greaterThanOrEqualToConstant: CGFloat(20))
        ])
    }

    func updateText(_ text: String?) {
        guard let text = text else { return }
        label.text = text
    }

    func updateImage(_ image: UIImage?) {
        guard let image = image else { return }
        imageView.image = image
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
