//
//  PopularGamesCell.swift
//  GameTracker
//
//  Created by Marina Aguiar on 9/19/22.
//

import UIKit
import Kingfisher

class PopularGamesCell: UICollectionViewCell, SelfConfiguringCell {

    func updateActivityIndicatorStatus(isLoading: Bool) {
        //
    }

    var photoURL: URL?

    static let reuseIdentifier: String = "PopularGamesCell"

    let imageView = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemGreen
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit

        contentView.addSubview(imageView)

        NSLayoutConstraint.activate([
            contentView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            contentView.topAnchor.constraint(equalTo: contentView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }

    func configure(with item: GameResponse) {
//        let url = URL(string: "\(item.imageUrl)")
//        imageView.kf.setImage(with: url)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
