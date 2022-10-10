//
//  GameDetailInfosCell.swift
//  GameTracker
//
//  Created by Marina Aguiar on 9/28/22.
//

import UIKit

final class GameDetailInfosCell: UICollectionViewCell, StandardConfiguringCell {
    typealias CellModel = GameInfoType
    static let reuseIdentifier: String = "GameDetailInfosCell"

    private let chipView = ChipView()


//    private let bigStackView = UIStackView()
//    private let rightStackView = UIStackView()
//    private let leftStackView = UIStackView()
//    private let playersLabel = UILabel()
//    private let timeLabel = UILabel()
//    private let playersImageView = UIImageView()
//    private let timeImageView = UIImageView()
//    private let contentRightContainer = UIView()
//    private let contentLeftContainer = UIView()

    @objc private let seeMoreButton = UIButton(type: .system)

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    private func setup() {
        configureBigStackView()
    }

    private func configureBigStackView() {
        contentView.addSubview(chipView)
        contentView.backgroundColor = .white
        chipView.translatesAutoresizingMaskIntoConstraints = false

        let inset = CGFloat(12)
        NSLayoutConstraint.activate([
            chipView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            chipView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            chipView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            chipView.topAnchor.constraint(equalTo: contentView.topAnchor),
            ])
    }

    func configure(with item: GameInfoType) {

        switch item {
        case .numberOfPlayers(let gameDetail):
            chipView.updateText(gameDetail.players)
            chipView.updateImage(DSImages.playersIcon)
        case .playtime(let gameDetail):
            chipView.updateText("\(gameDetail.playtime) min")
            chipView.updateImage(DSImages.playtimeIcon)
        case .minAge(let gameDetail):
            chipView.updateText("+\(gameDetail.minAge)")
            chipView.updateImage(DSImages.minAgeIcon)
        }
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fatalError("init(coder:) has not been implemented")
    }
}
