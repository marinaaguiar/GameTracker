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
        contentView.addSubview(contentContainer)
        contentContainer.backgroundColor = .white
        contentContainer.clipsToBounds = true
        contentContainer.translatesAutoresizingMaskIntoConstraints = false
        contentContainer.layer.cornerRadius = 20

        contentContainer.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontForContentSizeCategory = true
        label.textColor = Color.darkGray
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textAlignment = .center
        label.numberOfLines = 1
        let inset = CGFloat(5)

        NSLayoutConstraint.activate([
            contentContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            contentContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            contentContainer.topAnchor.constraint(equalTo: contentView.topAnchor),
            contentContainer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),


            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: inset),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -inset),
            label.topAnchor.constraint(equalTo: topAnchor, constant: inset),
            label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -inset)
        ])
    }

    func configure(with item: String) {
        label.text = item
    }


//    func configure(index: Int) {
//        let complexityLevels = ComplexityLevel.allCases
//        label.text = complexityLevels[index].rawValue
//    }
}
