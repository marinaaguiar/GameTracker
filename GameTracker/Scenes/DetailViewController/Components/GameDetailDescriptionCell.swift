//
//  GameDetailDescriptionCell.swift
//  GameTracker
//
//  Created by Marina Aguiar on 9/27/22.
//

import UIKit

final class GameDetailDescriptionCell: UICollectionViewCell, StandardConfiguringCell {
    typealias CellModel = GameDetail

    static let reuseIdentifier: String = "DescriptionCell"

    private let stackView = UIStackView()
    private let label = UILabel()
    private let contentContainer = UIView()
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
        stackView.axis = .vertical
        stackView.alignment = .top
        stackView.distribution = .fill
        stackView.spacing = 0
        stackView.isUserInteractionEnabled = true

        stackView.translatesAutoresizingMaskIntoConstraints = false
        let inset = CGFloat(12)
        NSLayoutConstraint.activate([
            stackView.trailingAnchor.constraint(equalTo: contentView.readableContentGuide.trailingAnchor, constant: inset),
            stackView.leadingAnchor.constraint(equalTo: contentView.readableContentGuide.leadingAnchor, constant: -inset),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: (inset)),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: (inset)),
        ])
        addLabelToStackView()
        addButtonToStackView()
    }

    private func addLabelToStackView() {
        stackView.addArrangedSubview(label)
//        label.backgroundColor = DSColor.backgroundColor
        label.textColor = DSColor.darkGray
        label.clipsToBounds = true
        label.contentMode = .topLeft
        label.textAlignment = .justified
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
    }

    private func addButtonToStackView() {
        stackView.addArrangedSubview(seeMoreButton)
        seeMoreButton.setTitle("See more", for: .normal)
        seeMoreButton.isUserInteractionEnabled = true
        seeMoreButton.titleLabel?.font = UIFont(name: "SF", size: 11)
        seeMoreButton.setTitleColor(.systemBlue, for: .normal)
        seeMoreButton.setTitleColor(.lightGray, for: .selected)
        seeMoreButton.clipsToBounds = true
        seeMoreButton.addTarget(self, action: #selector(getter: seeMoreButton), for: .touchUpInside)

        seeMoreButton.translatesAutoresizingMaskIntoConstraints = false
        let inset = CGFloat(12)
        NSLayoutConstraint.activate([
            seeMoreButton.centerYAnchor.constraint(equalTo: seeMoreButton.centerYAnchor),
            seeMoreButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: (inset)),
            seeMoreButton.heightAnchor.constraint(equalToConstant: 30)
        ])
    }

    @objc func seeMoreButtonPressed(_ sender: UIButton) {
        print("button pressed")
    }


    func configure(with item: GameDetail) {
        label.text = formattingString(item.description)
    }

    func formattingString(_ text: String) -> String {
        let htmlDescription  = text
        let data = Data(htmlDescription.utf8)

        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 16)
        ]

        if let attributedString = try?
            NSAttributedString(
                data: data,
                options: [.documentType: NSAttributedString.DocumentType.html],
                documentAttributes: nil
            ) {
            let formattedString = attributedString.string
            return formattedString
        }
        return ""
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fatalError("init(coder:) has not been implemented")
    }
}
