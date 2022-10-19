//
//  WishlistGameCell.swift
//  GameTracker
//
//  Created by Marina Aguiar on 10/19/22.
//

import UIKit
import Kingfisher

final class WishlistGameCell: UICollectionViewCell, StandardConfiguringCell {
    typealias CellModel = GameResponse

    static let reuseIdentifier: String = "WishlistGameCell"
    private var downloadTask: DownloadTask?

    private let imageView = UIImageView()
    private let titleLabel = UILabel()
    private let priceLabel = UILabel()
    private let contentContainer = UIView()
    private lazy var activityIndicator = UIActivityIndicatorView(style: .medium)

    private var photoURL: URL? {
        didSet {
            setup()
            activityIndicator.isHidden = true
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        if imageView.image == nil {
            downloadTask?.cancel()
        }
    }

    private func setup() {
        contentContainer.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(contentContainer)

        contentContainer.addSubview(imageView)
        imageView.layer.cornerRadius = 15
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit

        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 5
        imageView.backgroundColor = .white
        updateActivityIndicatorStatus(isLoading: false)

        contentContainer.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textColor = DSColor.darkGray
        titleLabel.font = .boldSystemFont(ofSize: 14)
        titleLabel.numberOfLines = 1

        contentContainer.addSubview(priceLabel)
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        priceLabel.textColor = DSColor.red
        priceLabel.font = .italicSystemFont(ofSize: 11)

        NSLayoutConstraint.activate([
          contentContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
          contentContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
          contentContainer.topAnchor.constraint(equalTo: contentView.topAnchor),
          contentContainer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: CGFloat(-20)),

          imageView.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor),
          imageView.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor),
          imageView.bottomAnchor.constraint(equalTo: contentContainer.bottomAnchor),
          imageView.topAnchor.constraint(equalTo: contentContainer.topAnchor),

          titleLabel.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor),
          titleLabel.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor),
          titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: CGFloat(6)),

          priceLabel.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor),
          priceLabel.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor),
          priceLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor)
        ])
    }

    private func updateActivityIndicatorStatus(isLoading: Bool) {
        setupActivityIndicator()
        if isLoading {
            activityIndicator.isHidden = false
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
            activityIndicator.isHidden = true
        }
    }

    private func setupActivityIndicator() {
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.color = .gray
        contentView.addSubview(activityIndicator)
        activityIndicator.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
    }

    func configure(with item: GameResponse) {
        guard let url = URL(string: "\(item.images.medium)") else { return }
        photoURL = url
        updateActivityIndicatorStatus(isLoading: true)

        imageView.kf.setImage(with: photoURL) { [self] result in
            updateActivityIndicatorStatus(isLoading: false)
        }
        titleLabel.text = item.name
        if item.price != "0.00" {
            priceLabel.text = "$\(item.price)"
        } else {
            priceLabel.text = "not available"
            priceLabel.font = .italicSystemFont(ofSize: 12)
            priceLabel.textColor = DSColor.lightMediumGray
        }
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fatalError("init(coder:) has not been implemented")
    }
}
