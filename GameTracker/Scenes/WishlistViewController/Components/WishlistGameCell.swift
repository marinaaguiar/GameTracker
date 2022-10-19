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
    private let secondaryLabel = UILabel()
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

        contentContainer.addSubview(secondaryLabel)
        secondaryLabel.translatesAutoresizingMaskIntoConstraints = false
        secondaryLabel.textColor = DSColor.lightMediumGray
        secondaryLabel.font = .systemFont(ofSize: 12)

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

          secondaryLabel.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor),
          secondaryLabel.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor),
          secondaryLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: CGFloat(3))
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

        if let yearPublished = item.yearPublished {
            secondaryLabel.text = "(\(yearPublished))"
        } else {
            secondaryLabel.text = ""
        }
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fatalError("init(coder:) has not been implemented")
    }
}
