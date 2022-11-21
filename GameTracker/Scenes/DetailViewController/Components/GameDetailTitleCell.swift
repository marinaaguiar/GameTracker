//
//  GameDetailTitleCell.swift
//  GameTracker
//
//  Created by Marina Aguiar on 10/31/22.
//

import UIKit

final class GameDetailTitleCell: UICollectionViewCell, StandardConfiguringCell {
    static let reuseIdentifier = "GameDetailTitleCell"
    typealias CellModel = GameDetailDescriptionModel

    let stackView = UIStackView()
    let subtitleLabel = UILabel()
    let yearLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }
}

extension GameDetailTitleCell {
    func setup() {
        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fill
        stackView.axis = .vertical
        stackView.spacing = CGFloat(5)

        stackView.addArrangedSubview(subtitleLabel)
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.textColor = DSColor.darkGray
        subtitleLabel.numberOfLines = 0
        subtitleLabel.font = UIFont.systemFont(ofSize: 25)

        stackView.addArrangedSubview(yearLabel)
        yearLabel.translatesAutoresizingMaskIntoConstraints = false
        yearLabel.textColor = DSColor.darkGray
        yearLabel.font = UIFont.systemFont(ofSize: 16)

        let inset = CGFloat(12)
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: inset),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -inset),
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: CGFloat(5)),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),

            subtitleLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: CGFloat(100)),
            subtitleLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: CGFloat(20)),

            yearLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: CGFloat(100)),
            yearLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: CGFloat(15))
        ])
    }

    func configure(with item: GameDetailDescriptionModel) {
        let gameName = item.gameDetail.name
        let year = item.gameDetail.yearPublished
        if gameName.localizedStandardContains(":") {
            subtitleLabel.isHidden = false
            let subtitle = item.gameDetail.name.components(separatedBy: ":")[1]
            subtitleLabel.text = subtitle
        } else {
            subtitleLabel.isHidden = true
            subtitleLabel.text = ""
        }
        yearLabel.text = " (\(year))"
    }
}
