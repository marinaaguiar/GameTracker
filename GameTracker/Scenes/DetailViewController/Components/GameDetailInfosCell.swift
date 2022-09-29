//
//  GameDetailInfosCell.swift
//  GameTracker
//
//  Created by Marina Aguiar on 9/28/22.
//

import UIKit

final class GameDetailInfosCell: UICollectionViewCell, StandardConfiguringCell {
    typealias CellModel = GameDetail

    static let reuseIdentifier: String = "GameDetailInfosCell"

    private let bigStackView = UIStackView()
    private let stackView = UIStackView()
    private let label = UILabel()
    private let imageView = UIImageView()
    private let contentRightContainer = UIView()
    private let contentLeftContainer = UIView()

    @objc private let seeMoreButton = UIButton(type: .system)

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    private func setup() {
        contentView.addSubview(bigStackView)
        bigStackView.addArrangedSubview(contentLeftContainer)
        bigStackView.addArrangedSubview(contentRightContainer)
        bigStackView.backgroundColor = .cyan
        bigStackView.axis = .horizontal
        bigStackView.distribution = .fill
        configureStackView()
//        contentRightContainer.addSubview(stackView)

        bigStackView.translatesAutoresizingMaskIntoConstraints = false
        let inset = CGFloat(12)
        NSLayoutConstraint.activate([
            bigStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            bigStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            bigStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            bigStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }

    private func configureStackView() {
        contentLeftContainer.addSubview(stackView)
        stackView.axis = .horizontal
        stackView.alignment = .leading
        stackView.distribution = .fillProportionally
        stackView.spacing = 8
        stackView.isUserInteractionEnabled = true
        stackView.backgroundColor = .white
        stackView.layer.cornerRadius = 10

        stackView.translatesAutoresizingMaskIntoConstraints = false
        let viewHeight = CGFloat(30)
        let inset = CGFloat(12)
        NSLayoutConstraint.activate([
            stackView.heightAnchor.constraint(equalToConstant: viewHeight),
            stackView.leadingAnchor.constraint(equalTo: contentLeftContainer.leadingAnchor)
        ])
        addImageToStackView()
        addLabelToStackView()
    }

    private func addLabelToStackView() {
        stackView.addArrangedSubview(label)
        label.textColor = DSColor.darkGray
        label.font = UIFont(name: "SFPro-Light", size: 10)
        label.clipsToBounds = true
        label.contentMode = .scaleAspectFill
        label.textAlignment = .center
        label.numberOfLines = 1

        let inset = CGFloat(12)
        let labelHeight = CGFloat(25)
        let labelMinWidth = CGFloat(50)
        NSLayoutConstraint.activate([
            label.centerYAnchor.constraint(equalTo: stackView.centerYAnchor),
            label.heightAnchor.constraint(equalToConstant: labelHeight),
            label.widthAnchor.constraint(greaterThanOrEqualToConstant: labelMinWidth),
            label.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: inset),
        ])
    }

    private func addImageToStackView() {
        stackView.addArrangedSubview(imageView)
        imageView.image = UIImage(named: "PlayersIcon")
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.frame = CGRect(x: 0, y: 0, width: 15, height: 15)

        let inset = CGFloat(12)
        NSLayoutConstraint.activate([
            imageView.centerYAnchor.constraint(equalTo: stackView.centerYAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 18),
            imageView.widthAnchor.constraint(equalToConstant: 22),
            imageView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: inset)
        ])

    }

    func configure(with item: GameDetail) {
        label.text = item.players
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fatalError("init(coder:) has not been implemented")
    }
}
