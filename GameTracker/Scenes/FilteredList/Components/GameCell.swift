//
//  GameCell.swift
//  GameTracker
//
//  Created by Marina Aguiar on 10/4/22.
//

import UIKit
import Kingfisher

final class GameCell: UICollectionViewCell, StandardConfiguringCell {
    typealias CellModel = GameResponse

    static let reuseIdentifier: String = "GameCell"
    private var downloadTask: DownloadTask?

    private let mainStackView = UIStackView()
    private let horizontalStackView = UIStackView()
    private let innerVerticalStackView = UIStackView()
    private let innerHorizontalStackView = UIStackView()
    private let gameImageView = UIImageView()
    private let titleLabel = UILabel()
    private let priceLabel = UILabel()
    private let containerViewA = UIView()
    private let containerViewB = UIView()
    private let infoCellsView = UIView()
    private let numberOfPlayersStackView = UIStackView()
    private let numberOfPlayersLabel = UILabel()
    private let numberOfPlayersImage = UIImageView()
    private let playtimeStackView = UIStackView()
    private let playtimeLabel = UILabel()
    private let playtimeImage = UIImageView()
    private lazy var activityIndicator = UIActivityIndicatorView(style: .medium)

    private var photoURL: URL? {
        didSet {
            setup()
            activityIndicator.isHidden = true
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        if gameImageView.image == nil {
            downloadTask?.cancel()
        }
    }

    private func setup() {
        setupMainStackView()
    }

    private func setupMainStackView() {
        contentView.addSubview(mainStackView)
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        mainStackView.backgroundColor = .white
        mainStackView.layer.cornerRadius = 10
        mainStackView.spacing = 5
        mainStackView.alignment = .leading
        mainStackView.axis = .horizontal
        mainStackView.distribution = .fill

        mainStackView.addArrangedSubview(containerViewA)
        mainStackView.addArrangedSubview(containerViewB)

        let inset = CGFloat(12)
        NSLayoutConstraint.activate([
            mainStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            mainStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            mainStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            mainStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
          ])
        setupContentViewA()
        setupContentViewB()
    }

    private func setupContentViewA() {
        containerViewA.addSubview(gameImageView)
        containerViewA.translatesAutoresizingMaskIntoConstraints = false
        containerViewA.layer.cornerRadius = 5
        containerViewA.clipsToBounds = true
        containerViewA.backgroundColor = .white
        //        containerViewA.backgroundColor = .yellow

        gameImageView.translatesAutoresizingMaskIntoConstraints = false
        gameImageView.clipsToBounds = true
        gameImageView.contentMode = .scaleAspectFit
//        gameImageView.layer.cornerRadius = 10

        let inset = CGFloat(12)
        NSLayoutConstraint.activate([
            containerViewA.widthAnchor.constraint(equalToConstant: CGFloat(84)),
            containerViewA.heightAnchor.constraint(equalTo: mainStackView.heightAnchor),

            gameImageView.centerXAnchor.constraint(equalTo: containerViewA.centerXAnchor),
            gameImageView.centerYAnchor.constraint(equalTo: containerViewA.centerYAnchor),
            gameImageView.widthAnchor.constraint(equalToConstant: CGFloat(70)),
            gameImageView.heightAnchor.constraint(equalToConstant: CGFloat(70))
          ])

    }

    private func setupContentViewB() {
        containerViewB.translatesAutoresizingMaskIntoConstraints = false
//        containerViewB.backgroundColor = .red
        containerViewB.addSubview(horizontalStackView)

        horizontalStackView.axis = .horizontal
        horizontalStackView.spacing = 5
        horizontalStackView.alignment = .lastBaseline
        horizontalStackView.distribution = .fill
        horizontalStackView.backgroundColor = .systemPink
        horizontalStackView.translatesAutoresizingMaskIntoConstraints = false

        horizontalStackView.addArrangedSubview(innerVerticalStackView)
        innerVerticalStackView.axis = .vertical
        innerVerticalStackView.distribution = .fillEqually
        innerVerticalStackView.backgroundColor = .yellow
        innerVerticalStackView.alignment = .fill
        innerVerticalStackView.translatesAutoresizingMaskIntoConstraints = false

        innerVerticalStackView.addArrangedSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.clipsToBounds = true
        titleLabel.font = .systemFont(ofSize: 13)
        titleLabel.textColor = DSColor.black
        titleLabel.numberOfLines = 2

        innerVerticalStackView.addArrangedSubview(infoCellsView)
        infoCellsView.translatesAutoresizingMaskIntoConstraints = false
        infoCellsView.backgroundColor = .blue
        setupInfoCellsView()

        horizontalStackView.addArrangedSubview(priceLabel)
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        priceLabel.clipsToBounds = true
        priceLabel.font = .boldSystemFont(ofSize: 16)
        priceLabel.textColor = DSColor.black
        priceLabel.numberOfLines = 1
        priceLabel.textAlignment = .right

        let inset = CGFloat(12)
        NSLayoutConstraint.activate([
            containerViewB.leadingAnchor.constraint(equalTo: containerViewA.trailingAnchor),
            containerViewB.trailingAnchor.constraint(equalTo: mainStackView.trailingAnchor),
            containerViewB.heightAnchor.constraint(equalTo: mainStackView.heightAnchor),

            horizontalStackView.leadingAnchor.constraint(equalTo: containerViewB.leadingAnchor, constant: inset),
            horizontalStackView.trailingAnchor.constraint(equalTo: containerViewB.trailingAnchor, constant: -inset),
            horizontalStackView.topAnchor.constraint(equalTo: containerViewB.topAnchor, constant: inset),
            horizontalStackView.bottomAnchor.constraint(equalTo: containerViewB.bottomAnchor, constant: -inset),

            innerVerticalStackView.leadingAnchor.constraint(equalTo: horizontalStackView.leadingAnchor),
            innerVerticalStackView.trailingAnchor.constraint(equalTo: priceLabel.leadingAnchor),
            innerVerticalStackView.topAnchor.constraint(equalTo: horizontalStackView.topAnchor),
            innerVerticalStackView.bottomAnchor.constraint(equalTo: horizontalStackView.bottomAnchor),

            infoCellsView.leadingAnchor.constraint(equalTo: innerVerticalStackView.leadingAnchor),
            infoCellsView.trailingAnchor.constraint(equalTo: innerVerticalStackView.trailingAnchor),
            infoCellsView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            infoCellsView.bottomAnchor.constraint(equalTo: innerVerticalStackView.bottomAnchor),

            priceLabel.widthAnchor.constraint(equalToConstant: CGFloat(90)),
            priceLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: CGFloat(18)),
            priceLabel.bottomAnchor.constraint(equalTo: horizontalStackView.bottomAnchor),
          ])

    }

    private func setupInfoCellsView() {
        infoCellsView.addSubview(innerHorizontalStackView)
        infoCellsView.translatesAutoresizingMaskIntoConstraints = false

        innerHorizontalStackView.axis = .horizontal
        innerHorizontalStackView.alignment = .fill
        innerHorizontalStackView.distribution = .equalCentering
        innerHorizontalStackView.spacing = 5
        innerHorizontalStackView.translatesAutoresizingMaskIntoConstraints = false

        innerHorizontalStackView.addArrangedSubview(numberOfPlayersStackView)
        numberOfPlayersStackView.backgroundColor = .green
        numberOfPlayersStackView.translatesAutoresizingMaskIntoConstraints = false
        setupInfoStackView(stackView: numberOfPlayersStackView, label: numberOfPlayersLabel, imageView: numberOfPlayersImage)

        innerHorizontalStackView.addArrangedSubview(playtimeStackView)
        playtimeStackView.backgroundColor = .cyan
        playtimeStackView.translatesAutoresizingMaskIntoConstraints = false
        setupInfoStackView(stackView: playtimeStackView, label: playtimeLabel, imageView: playtimeImage)

        let inset = CGFloat(12)
        NSLayoutConstraint.activate([

            innerHorizontalStackView.leadingAnchor.constraint(equalTo: infoCellsView.leadingAnchor),
            innerHorizontalStackView.trailingAnchor.constraint(equalTo: infoCellsView.trailingAnchor),
            innerHorizontalStackView.heightAnchor.constraint(equalToConstant: CGFloat(20)),

            numberOfPlayersStackView.leadingAnchor.constraint(equalTo: innerHorizontalStackView.leadingAnchor),
            numberOfPlayersStackView.bottomAnchor.constraint(equalTo: innerHorizontalStackView.bottomAnchor),

            playtimeStackView.trailingAnchor.constraint(equalTo: innerHorizontalStackView.trailingAnchor),
            playtimeStackView.bottomAnchor.constraint(equalTo: innerHorizontalStackView.bottomAnchor)
        ])
    }

    private func setupInfoStackView(stackView: UIStackView, label: UILabel, imageView: UIImageView) {
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.layer.cornerRadius = 10
        stackView.alignment = .center

        stackView.addArrangedSubview(imageView)
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false

        stackView.addArrangedSubview(label)
        label.clipsToBounds = true
        label.font = .systemFont(ofSize: 11)
        label.textColor = DSColor.darkGray
        label.numberOfLines = 1
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false

        let inset = CGFloat(3)
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: CGFloat(35)),
            label.widthAnchor.constraint(greaterThanOrEqualToConstant: CGFloat(40))
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

        gameImageView.kf.setImage(with: photoURL) { [self] result in
            updateActivityIndicatorStatus(isLoading: false)
        }
        titleLabel.text = item.name
        numberOfPlayersLabel.text = item.players
        numberOfPlayersImage.image = UIImage(named: "PlayersIcon")
        playtimeLabel.text = "\(item.playtime ?? "") min"
        playtimeImage.image = UIImage(named: "TimerIcon")

        if item.price == "0.00" {
            priceLabel.text = "(not available)"
            priceLabel.font = .systemFont(ofSize: 12)
            priceLabel.textColor = DSColor.darkGray

        } else {
            priceLabel.text = "$\(item.price)"
        }
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fatalError("init(coder:) has not been implemented")
    }
}
