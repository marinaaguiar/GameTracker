//
//  GameDetailLinks.swift
//  GameTracker
//
//  Created by Marina Aguiar on 10/24/22.
//

import UIKit

final class GameDetailLinksCell: UICollectionViewCell, StandardConfiguringCell {
    typealias CellModel = GameLinkType
    static let reuseIdentifier: String = "GameDetailLinksCell"

    private let linkView = LinkView(frame: .zero)

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    private func setup() {
        configureBigStackView()
    }

    private func configureBigStackView() {
        contentView.addSubview(linkView)
        linkView.translatesAutoresizingMaskIntoConstraints = false

        let inset = CGFloat(12)
        NSLayoutConstraint.activate([
            linkView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            linkView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            linkView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            linkView.topAnchor.constraint(equalTo: contentView.topAnchor),
            ])
    }

    func configure(with item: GameLinkType) {
        switch item {
        case .ruleGame:
            linkView.updateCell(type: .rule)
        case .websiteGame:
            linkView.updateCell(type: .website)
        }
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fatalError("init(coder:) has not been implemented")
    }
}
