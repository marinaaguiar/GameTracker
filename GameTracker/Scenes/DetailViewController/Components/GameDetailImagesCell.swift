//
//  GameDetailImagesCell.swift
//  GameTracker
//
//  Created by Marina Aguiar on 9/28/22.
//

import UIKit
import Kingfisher

final class GameDetailImagesCell: UICollectionViewCell, StandardConfiguringCell {
    typealias CellModel = GameImageResponse

    static let reuseIdentifier: String = "GameDetailImagesCell"
    private var downloadTask: DownloadTask?

    private let imageView = UIImageView()
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

        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill

        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 5
        imageView.backgroundColor = .white
        contentContainer.addSubview(imageView)
        updateActivityIndicatorStatus(isLoading: false)

        NSLayoutConstraint.activate([
          contentContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
          contentContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
          contentContainer.topAnchor.constraint(equalTo: contentView.topAnchor),
          contentContainer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

          imageView.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor, constant: CGFloat(10)),
          imageView.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor),
          imageView.bottomAnchor.constraint(equalTo: contentContainer.bottomAnchor),
          imageView.topAnchor.constraint(equalTo: contentContainer.topAnchor)
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

    func configure(with item: GameImageResponse) {
        guard let url = URL(string: "\(item.imageURL)") else { return }
        photoURL = url
        updateActivityIndicatorStatus(isLoading: true)

        imageView.kf.setImage(with: photoURL) { [self] result in
            updateActivityIndicatorStatus(isLoading: false)
        }
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fatalError("init(coder:) has not been implemented")
    }
}
