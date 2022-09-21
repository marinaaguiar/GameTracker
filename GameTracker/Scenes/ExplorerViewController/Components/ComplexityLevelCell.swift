//
//  ComplexityLevelCell.swift
//  GameTracker
//
//  Created by Marina Aguiar on 9/21/22.
//

import Foundation

import UIKit
import Kingfisher

class ComplexityLevelCell: UICollectionViewCell, StandardConfiguringCell {

    enum ComplexityLevel: String, CaseIterable {
        case veryEasy = "very easy"
        case easy = "easy"
        case moderate = "moderate"
        case difficult = "difficult"
        case veryDifficult = "very difficult"
    }

    static let reuseIdentifier: String = "ComplexityLevel"
    private var downloadTask: DownloadTask?

    let label = UILabel()
    private let contentContainer = UIView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }
}

extension ComplexityLevelCell {
    func setup() {
        backgroundColor = Color.backgroundColor

        addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontForContentSizeCategory = true
        label.textColor = Color.darkGray
        label.font = UIFont.boldSystemFont(ofSize: 15)

        let inset = CGFloat(5)

        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: inset),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -inset),
            label.topAnchor.constraint(equalTo: topAnchor, constant: inset),
            label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -inset)
        ])
    }

    func configure() {
        let complexityLevels = ComplexityLevel.allCases

        for level in complexityLevels {
            label.text = level.rawValue
        }
    }
}
