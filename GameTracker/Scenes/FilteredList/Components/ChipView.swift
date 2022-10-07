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

    override init(frame: CGRect){
        super.init(frame: frame)
        setupLayout()
    }

    private func setupLayout() {
        self.addSubview(view)
        view.backgroundColor = DSColor.lightGray
        view.layer.cornerRadius = 12
        view.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(stackView)
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.spacing = 5
        stackView.translatesAutoresizingMaskIntoConstraints = false

        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(label)

        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false

        label.clipsToBounds = true
        label.font = .systemFont(ofSize: 11)
        label.textColor = DSColor.darkGray
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
            stackView.topAnchor.constraint(equalTo: view.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            imageView.widthAnchor.constraint(greaterThanOrEqualToConstant: CGFloat(8)),
            imageView.widthAnchor.constraint(lessThanOrEqualToConstant: CGFloat(16)),
            imageView.heightAnchor.constraint(equalToConstant: CGFloat(10)),

            label.heightAnchor.constraint(equalToConstant: CGFloat(15)),
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
