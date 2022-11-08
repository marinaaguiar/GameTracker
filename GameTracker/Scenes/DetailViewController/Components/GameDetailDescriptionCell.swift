//
//  GameDetailDescriptionCell.swift
//  GameTracker
//
//  Created by Marina Aguiar on 9/27/22.
//

import UIKit

final class GameDetailDescriptionCell: UICollectionViewCell, StandardConfiguringCell {
    typealias CellModel = GameDetailDescriptionModel

    static let reuseIdentifier: String = "DescriptionCell"

    private let stackView = UIStackView()
    private let label = UILabel()
    private let contentContainer = UIView()
    private let arrowImage = UIImageView()
    @objc private let seeMoreButton = UIButton(type: .system)

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    private func setup() {
        configureStackView()
    }

    private func configureStackView() {
        contentView.addSubview(stackView)
        contentView.isUserInteractionEnabled = true

        stackView.axis = .vertical
        stackView.alignment = .top
        stackView.distribution = .fill
        stackView.spacing = 10
        stackView.isUserInteractionEnabled = true

        stackView.translatesAutoresizingMaskIntoConstraints = false
        let inset = CGFloat(12)
        NSLayoutConstraint.activate([
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -inset),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: inset),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: inset),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -inset)
        ])
        addLabelToStackView()
        addArrowImageToStackView()
    }

    private func addLabelToStackView() {
        stackView.addArrangedSubview(label)
        label.textColor = DSColor.darkGray
        label.clipsToBounds = true
        label.contentMode = .topLeft
        label.textAlignment = .justified
        label.font = .preferredFont(forTextStyle: .body, compatibleWith: .none)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
    }

    private func addArrowImageToStackView() {
        stackView.addArrangedSubview(contentContainer)
        contentContainer.addSubview(arrowImage)
        contentContainer.backgroundColor = DSColor.secondaryBGColor
        contentContainer.layer.cornerRadius = 10
        arrowImage.image = UIImage(named: "ArrowUp")
        arrowImage.contentMode = .scaleAspectFit

        contentContainer.translatesAutoresizingMaskIntoConstraints = false
        arrowImage.translatesAutoresizingMaskIntoConstraints = false
        let inset = CGFloat(12)
        NSLayoutConstraint.activate([
            contentContainer.heightAnchor.constraint(equalToConstant: CGFloat(30)),
            contentContainer.widthAnchor.constraint(equalTo: stackView.widthAnchor),

            arrowImage.centerXAnchor.constraint(equalTo: contentContainer.centerXAnchor),
            arrowImage.centerYAnchor.constraint(equalTo: contentContainer.centerYAnchor),
            arrowImage.heightAnchor.constraint(equalToConstant: CGFloat(15))
        ])
    }

    func configure(with item: GameDetailDescriptionModel) {
        if item.gameDetail.descriptionPreview == "" {
            arrowImage.isHidden = true
        } else {
            if item.isDescriptionExpanded {
                label.numberOfLines = 0
                arrowImage.image = UIImage(named: "ArrowUp")
            } else {
                label.numberOfLines = 10
                arrowImage.image = UIImage(named: "ArrowDown")
            }
        }
        label.attributedText = formattingString(item.gameDetail.description)
    }

    func formattingString(_ text: String) -> NSAttributedString? {
        let htmlDescription  = text
        let data = Data(htmlDescription.utf8)

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .justified

        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 16),
            .foregroundColor: DSColor.darkGray!,
            .paragraphStyle: paragraphStyle
        ]

        if let attributedString = try?
            NSMutableAttributedString(
                data: data,
                options: [
                    .documentType: NSAttributedString.DocumentType.html,
                    .characterEncoding: NSUTF8StringEncoding
                ],
                documentAttributes: nil
            ) {

            attributedString.addAttributes(
                attributes,
                range: NSRange.init(location: 0, length: attributedString.length)
            )

            let formattedString = attributedString
            return formattedString
        }
        return NSAttributedString(string: "")
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fatalError("init(coder:) has not been implemented")
    }
}
