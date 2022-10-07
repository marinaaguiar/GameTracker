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
    private let infoHorizontalStackView = UIStackView()
    private let infoVerticalStackView = UIStackView()
    private let chipsView = UIView()
    private let chipsHorizontalStackView = UIStackView()
    private let gameImageView = UIImageView()
    private let titleLabel = UILabel()
    private let priceLabel = UILabel()
    private let containerViewA = UIView()
    private let containerViewB = UIView()
    private let priceView = UIView()
    private let numberOfPlayersView = ChipView()
    private let playtimeView = ChipView()
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

        gameImageView.translatesAutoresizingMaskIntoConstraints = false
        gameImageView.clipsToBounds = true
        gameImageView.contentMode = .scaleAspectFit

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
        containerViewB.addSubview(infoHorizontalStackView)

        infoHorizontalStackView.axis = .horizontal
        infoHorizontalStackView.spacing = 5
        infoHorizontalStackView.distribution = .fill
        infoHorizontalStackView.backgroundColor = .white
        infoHorizontalStackView.translatesAutoresizingMaskIntoConstraints = false

        infoHorizontalStackView.addArrangedSubview(infoVerticalStackView)
        infoVerticalStackView.axis = .vertical
        infoVerticalStackView.distribution = .fill
        infoVerticalStackView.backgroundColor = .white
        infoVerticalStackView.translatesAutoresizingMaskIntoConstraints = false

        infoHorizontalStackView.addArrangedSubview(priceView)
        priceLabel.clipsToBounds = true
        priceLabel.font = .boldSystemFont(ofSize: 16)
        priceLabel.textColor = DSColor.black
        priceLabel.numberOfLines = 1
        priceLabel.textAlignment = .right
        priceLabel.translatesAutoresizingMaskIntoConstraints = false

        priceView.addSubview(priceLabel)
        priceView.translatesAutoresizingMaskIntoConstraints = false

        infoVerticalStackView.addArrangedSubview(titleLabel)
        titleLabel.clipsToBounds = true
        titleLabel.font = .systemFont(ofSize: 13)
        titleLabel.textColor = DSColor.black
        titleLabel.numberOfLines = 2
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        infoVerticalStackView.addArrangedSubview(chipsView)
        chipsView.translatesAutoresizingMaskIntoConstraints = false

        chipsView.addSubview(chipsHorizontalStackView)
//        chipsView.backgroundColor = .yellow
        chipsHorizontalStackView.axis = .horizontal
        chipsHorizontalStackView.distribution = .fill
        chipsHorizontalStackView.spacing = 5
        chipsHorizontalStackView.translatesAutoresizingMaskIntoConstraints = false

        chipsHorizontalStackView.addArrangedSubview(numberOfPlayersView)
        numberOfPlayersView.translatesAutoresizingMaskIntoConstraints = false

        chipsHorizontalStackView.addArrangedSubview(playtimeView)
        playtimeView.translatesAutoresizingMaskIntoConstraints = false

        let inset = CGFloat(12)
        NSLayoutConstraint.activate([
            containerViewB.heightAnchor.constraint(equalTo: mainStackView.heightAnchor),

            infoHorizontalStackView.leadingAnchor.constraint(equalTo: containerViewB.leadingAnchor, constant: inset),
            infoHorizontalStackView.trailingAnchor.constraint(equalTo: containerViewB.trailingAnchor, constant: -inset),
            infoHorizontalStackView.topAnchor.constraint(equalTo: containerViewB.topAnchor, constant: inset),
            infoHorizontalStackView.bottomAnchor.constraint(equalTo: containerViewB.bottomAnchor, constant: -inset),

            infoVerticalStackView.leadingAnchor.constraint(equalTo: infoHorizontalStackView.leadingAnchor),
            infoVerticalStackView.trailingAnchor.constraint(equalTo: priceLabel.leadingAnchor),
            infoVerticalStackView.topAnchor.constraint(equalTo: infoHorizontalStackView.topAnchor),
            infoVerticalStackView.bottomAnchor.constraint(equalTo: infoHorizontalStackView.bottomAnchor),

            chipsView.widthAnchor.constraint(greaterThanOrEqualToConstant: CGFloat(45)),
            chipsView.heightAnchor.constraint(greaterThanOrEqualToConstant: CGFloat(25)),

            chipsHorizontalStackView.bottomAnchor.constraint(equalTo: chipsView.bottomAnchor),
            chipsHorizontalStackView.leadingAnchor.constraint(equalTo: chipsView.leadingAnchor),
            chipsHorizontalStackView.heightAnchor.constraint(equalToConstant: CGFloat(25)),
            chipsHorizontalStackView.widthAnchor.constraint(greaterThanOrEqualToConstant: CGFloat(45)),

            priceLabel.widthAnchor.constraint(equalToConstant: CGFloat(90)),
            priceLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: CGFloat(18)),
            priceLabel.trailingAnchor.constraint(equalTo: priceView.trailingAnchor),
            priceLabel.bottomAnchor.constraint(equalTo: priceView.bottomAnchor)
          ])
    }

    private func updateActivityIndicatorStatus(isLoading: Bool) {
        setupActivityIndicator()
        if isLoading {
            titleLabel.isHidden = true
            priceLabel.isHidden = true
            playtimeView.isHidden = true
            numberOfPlayersView.isHidden = true

            activityIndicator.isHidden = false
            activityIndicator.startAnimating()
        } else {
            titleLabel.isHidden = false
            priceLabel.isHidden = false
            playtimeView.isHidden = false
            numberOfPlayersView.isHidden = false

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
        numberOfPlayersView.updateText(item.players)
        numberOfPlayersView.updateImage(UIImage(named: "PlayersIcon"))
        playtimeView.updateText("\(item.playtime ?? "") min")
        playtimeView.updateImage(UIImage(named: "TimerIcon"))

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
