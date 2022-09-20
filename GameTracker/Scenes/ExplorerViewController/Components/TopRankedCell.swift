//
//  TopRankedCell.swift
//  GameTracker
//
//  Created by Marina Aguiar on 9/16/22.
//

import UIKit
import Kingfisher

class TopRankedCell: UICollectionViewCell, SelfConfiguringCell {
    static let reuseIdentifier: String = "TopRankedCell"
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

    func setup() {
        contentContainer.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(contentContainer)

        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleToFill

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

          imageView.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor),
          imageView.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor),
          imageView.bottomAnchor.constraint(equalTo: contentContainer.bottomAnchor),
          imageView.topAnchor.constraint(equalTo: contentContainer.topAnchor)
        ])

    }

    func setupActivityIndicator() {
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(activityIndicator)
        activityIndicator.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
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

    func configure(with item: GameResponse) {
        guard let url = URL(string: "\(item.imageUrl)") else { return }
        photoURL = url

        updateActivityIndicatorStatus(isLoading: true)

        imageView.kf.setImage(with: photoURL) { [self] result in
            updateActivityIndicatorStatus(isLoading: false)
        }
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
//        setupActivityIndicator()
        fatalError("init(coder:) has not been implemented")
    }
}
