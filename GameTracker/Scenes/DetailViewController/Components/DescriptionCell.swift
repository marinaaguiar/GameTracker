//
//  DescriptionCell.swift
//  GameTracker
//
//  Created by Marina Aguiar on 9/27/22.
//

import UIKit

final class DescriptionCell: UICollectionViewCell, StandardConfiguringCell {
    typealias CellModel = GameDetail

    static let reuseIdentifier: String = "DescriptionCell"

    private let label = UILabel()
    private let contentContainer = UIView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    private func setup() {
        contentContainer.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(contentContainer)

        contentView.backgroundColor = .yellow
        contentContainer.backgroundColor = .systemPink
        label.backgroundColor = .blue
        label.clipsToBounds = true
        label.contentMode = .scaleAspectFill
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        contentContainer.addSubview(label)

        NSLayoutConstraint.activate([
          contentContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
          contentContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
          contentContainer.topAnchor.constraint(equalTo: contentView.topAnchor),
          contentContainer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

          label.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor, constant: CGFloat(10)),
          label.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor, constant: CGFloat(10)),
          label.bottomAnchor.constraint(equalTo: contentContainer.bottomAnchor),
          label.topAnchor.constraint(equalTo: contentContainer.topAnchor)
        ])
    }

    func configure(with item: GameDetail) {
        label.text = item.description
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fatalError("init(coder:) has not been implemented")
    }
}
