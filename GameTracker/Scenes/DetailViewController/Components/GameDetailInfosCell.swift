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

    private let chipView = ChipView(frame: .zero, size: .medium)

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    private func setup() {
        contentView.addSubview(chipView)
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
        case .playtime(let gameDetail):
            if gameDetail.playtime != "" {
                chipView.isHidden = false
                chipView.updateText("\(gameDetail.playtime) min")
                chipView.updateImage(DSImages.playtimeIcon)
            } else {
                chipView.isHidden = true
//                chipView.removeFromSuperview()
            }
        case .numberOfPlayers(let gameDetail):
            if gameDetail.players != "" {
                chipView.isHidden = false
                chipView.updateText(gameDetail.players)
                chipView.updateImage(DSImages.playersIcon)
            } else {
                chipView.isHidden = true
            }
        case .minAge(let gameDetail):
            if gameDetail.minAge != 0 {
                chipView.isHidden = false
                chipView.updateText("+\(gameDetail.minAge)")
                chipView.updateImage(DSImages.minAgeIcon)
            } else {
                chipView.isHidden = true
            }
        }
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fatalError("init(coder:) has not been implemented")
    }
}
