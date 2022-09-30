//
//  GameDetailInfosCell.swift
//  GameTracker
//
//  Created by Marina Aguiar on 9/28/22.
//

import UIKit

final class GameDetailInfosCell: UICollectionViewCell, StandardConfiguringCell {
    typealias CellModel = GameDetail
    static let reuseIdentifier: String = "GameDetailInfosCell"

    enum GameInfos: Int, CaseIterable {
        case numberOfPlayers(GameDetail) = 0
        case gameDuration(GameDetail)
        case minAge(GameDetail)
    }

    private let bigStackView = UIStackView()
    private let rightStackView = UIStackView()
    private let leftStackView = UIStackView()
    private let playersLabel = UILabel()
    private let timeLabel = UILabel()
    private let playersImageView = UIImageView()
    private let timeImageView = UIImageView()
    private let contentRightContainer = UIView()
    private let contentLeftContainer = UIView()

    @objc private let seeMoreButton = UIButton(type: .system)

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    private func setup() {
        configureBigStackView()
    }

    private func configureBigStackView() {
        contentView.addSubview(bigStackView)
//        bigStackView.backgroundColor = .cyan
        bigStackView.axis = .horizontal
        bigStackView.distribution = .fill
        bigStackView.spacing = 100
        setConstraintsToBigStackView()

        bigStackView.addArrangedSubview(contentLeftContainer)
        bigStackView.addArrangedSubview(contentRightContainer)
        configureStackView(containerView: contentRightContainer, stackView: rightStackView)
        configureStackView(containerView: contentLeftContainer, stackView: leftStackView)

//        contentLeftContainer.backgroundColor = .green
//        contentRightContainer.backgroundColor = .systemPink
    }

    private func setConstraintsToBigStackView() {
        bigStackView.translatesAutoresizingMaskIntoConstraints = false
        let inset = CGFloat(12)
        NSLayoutConstraint.activate([
            bigStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            bigStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            bigStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: inset),
            bigStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -inset)
        ])
    }

    private func configureStackView(containerView: UIView, stackView: UIStackView) {
        containerView.addSubview(stackView)
        containerView.setContentHuggingPriority(.required, for: .horizontal)

        stackView.axis = .horizontal
        stackView.alignment = .leading
        stackView.distribution = .fill
        stackView.spacing = 8
        stackView.isUserInteractionEnabled = true
        stackView.backgroundColor = .white
        stackView.layer.cornerRadius = 10
        setConstraintsToStackView(stackView)

        if containerView == contentLeftContainer {
            leftStackView.addArrangedSubview(playersLabel)
            addImageToStackView(playersImageView, stackView: leftStackView)
            addLabelToStackView(playersLabel, stackView: leftStackView)
        } else {
            rightStackView.addArrangedSubview(timeLabel)
            addImageToStackView(timeImageView, stackView: rightStackView)
            addLabelToStackView(timeLabel, stackView: rightStackView)
        }
    }

    private func setConstraintsToStackView(_ stackView: UIStackView) {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        let viewHeight = CGFloat(30)
        let viewMinWidth = CGFloat(40)
        let inset = CGFloat(12)
        NSLayoutConstraint.activate([
            stackView.heightAnchor.constraint(equalToConstant: viewHeight),
            stackView.widthAnchor.constraint(greaterThanOrEqualToConstant: viewMinWidth)
        ])
    }

    private func addLabelToStackView(_ label: UILabel, stackView: UIStackView) {
        if stackView == leftStackView {
            stackView.addArrangedSubview(playersLabel)
        } else {
            stackView.addArrangedSubview(timeLabel)
        }
        label.textColor = .darkGray
        label.font = UIFont(name: "SFPro-Light", size: 10)
        label.clipsToBounds = true
        label.contentMode = .scaleAspectFill
        label.textAlignment = .left
        label.numberOfLines = 1

        let inset = CGFloat(12)
        let labelHeight = CGFloat(25)
        let labelMinWidth = CGFloat(50)
        NSLayoutConstraint.activate([
            label.centerYAnchor.constraint(equalTo: stackView.centerYAnchor),
            label.heightAnchor.constraint(equalToConstant: labelHeight),
            label.widthAnchor.constraint(greaterThanOrEqualToConstant: labelMinWidth),
            label.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: -inset)
        ])
    }

    private func addImageToStackView(_ imageView: UIImageView, stackView: UIStackView) {
        if stackView == leftStackView {
            stackView.addArrangedSubview(playersImageView)
            imageView.image = UIImage(named: "PlayersIcon")
        } else {
            stackView.addArrangedSubview(timeImageView)
            imageView.image = UIImage(named: "TimerIcon")
        }
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.frame = CGRect(x: 0, y: 0, width: 15, height: 15)

        let inset = CGFloat(12)
        NSLayoutConstraint.activate([
            imageView.centerYAnchor.constraint(equalTo: stackView.centerYAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 18),
            imageView.widthAnchor.constraint(equalToConstant: 22),
            imageView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: inset),
            imageView.topAnchor.constraint(equalTo: stackView.topAnchor, constant: CGFloat(5)),
            imageView.bottomAnchor.constraint(equalTo: stackView.bottomAnchor, constant: CGFloat(-5))
        ])
    }

    func configure(with item: GameDetail) {

        playersLabel.text = item.players
        timeLabel.text = "\(item.playtime) min   "
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fatalError("init(coder:) has not been implemented")
    }
}
