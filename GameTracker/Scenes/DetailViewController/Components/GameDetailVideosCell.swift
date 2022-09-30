//
//  GameDetailVideosCell.swift
//  GameTracker
//
//  Created by Marina Aguiar on 9/28/22.
//

import UIKit
import Kingfisher

final class GameDetailVideosCell: UICollectionViewCell, StandardConfiguringCell {
    typealias CellModel = GameVideoResponse

    static let reuseIdentifier: String = "GameDetailVideosCell"
    private var downloadTask: DownloadTask?

    private let stackView = UIStackView()
    private let playerImageView = UIImageView()
    private let videoImageView = UIImageView()
    private let titleLabel = UILabel()
    private let containerViewA = UIView()
    private let containerViewB = UIView()
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
        if videoImageView.image == nil {
            downloadTask?.cancel()
        }
    }

    private func setup() {
        addStackViewToContentView()
    }

    private func addStackViewToContentView() {
        contentView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
//        stackView.backgroundColor = .cyan
        stackView.spacing = 5
        stackView.alignment = .leading
        stackView.axis = .vertical
        stackView.distribution = .fill

        stackView.addArrangedSubview(containerViewA)
        stackView.addArrangedSubview(containerViewB)
        containerViewA.translatesAutoresizingMaskIntoConstraints = false
        containerViewA.layer.cornerRadius = 5
        containerViewA.clipsToBounds = true
        containerViewB.translatesAutoresizingMaskIntoConstraints = false

//        containerViewA.backgroundColor = .yellow
//        containerViewB.backgroundColor = .red

        containerViewA.addSubview(videoImageView)
        videoImageView.translatesAutoresizingMaskIntoConstraints = false
        videoImageView.clipsToBounds = true
        videoImageView.contentMode = .scaleAspectFill

        containerViewA.addSubview(playerImageView)
        playerImageView.translatesAutoresizingMaskIntoConstraints = false
        playerImageView.clipsToBounds = true
        playerImageView.image = UIImage.init(systemName: "play.circle.fill")?.withTintColor(.white, renderingMode: .alwaysOriginal)
        playerImageView.contentMode = .scaleAspectFit
        playerImageView.alpha = 0.9
        playerImageView.layer.masksToBounds = false

        containerViewB.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.clipsToBounds = true
        titleLabel.font = .boldSystemFont(ofSize: 18)
        titleLabel.textColor = DSColor.black
        titleLabel.numberOfLines = 2

        let inset = CGFloat(12)
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: inset),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

            containerViewA.widthAnchor.constraint(equalTo: stackView.widthAnchor),
            containerViewA.heightAnchor.constraint(lessThanOrEqualToConstant: CGFloat(250)),

            containerViewB.widthAnchor.constraint(equalTo: stackView.widthAnchor),
            containerViewB.heightAnchor.constraint(greaterThanOrEqualToConstant: CGFloat(25)),

            videoImageView.trailingAnchor.constraint(equalTo: containerViewA.trailingAnchor),
            videoImageView.leadingAnchor.constraint(equalTo: containerViewA.leadingAnchor),
            videoImageView.topAnchor.constraint(equalTo: containerViewA.topAnchor),
            videoImageView.bottomAnchor.constraint(equalTo: containerViewA.bottomAnchor),

            playerImageView.centerXAnchor.constraint(equalTo: containerViewA.centerXAnchor),
            playerImageView.centerYAnchor.constraint(equalTo: containerViewA.centerYAnchor),
            playerImageView.widthAnchor.constraint(equalToConstant: CGFloat(50)),
            playerImageView.heightAnchor.constraint(equalToConstant: CGFloat(50)),

            titleLabel.topAnchor.constraint(equalTo: containerViewB.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: containerViewB.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: containerViewB.trailingAnchor)
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

    func configure(with item: GameVideoResponse) {
        guard let url = URL(string: "\(item.imageUrl)") else { return }
        photoURL = url
        updateActivityIndicatorStatus(isLoading: true)

        videoImageView.kf.setImage(with: photoURL) { [self] result in
            updateActivityIndicatorStatus(isLoading: false)
        }
        titleLabel.text = item.title
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fatalError("init(coder:) has not been implemented")
    }
}
