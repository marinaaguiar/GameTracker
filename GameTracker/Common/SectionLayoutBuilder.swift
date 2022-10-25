//
//  SectionLayoutBuilder.swift
//  GameTracker
//
//  Created by Marina Aguiar on 9/27/22.
//

import UIKit

class SectionLayoutBuilder {
    private init() {}

    static func bigSizeTableSection() -> NSCollectionLayoutSection {
        let item = CompositionalLayout.createItem(
            width: .fractionalWidth(1),
            height: .fractionalHeight(1),
            spacing: 5)
        let horizontalGroup = CompositionalLayout.createGroup(
            aligment: .horizontal,
            width: .absolute(CGFloat(250)),
            height: .absolute(CGFloat(220)),
            item: item,
            count: 1)
        let section = NSCollectionLayoutSection(group: horizontalGroup)
        section.orthogonalScrollingBehavior = .groupPaging
        section.contentInsets = .init(top: 6, leading: 12, bottom: 12, trailing: 12)

        let sectionHeader = createSectionHeader()
        section.boundarySupplementaryItems = [sectionHeader]

        return section
    }

    static func mediumSizeTableSection() -> NSCollectionLayoutSection {
        let item = CompositionalLayout.createItem(
            width: .fractionalWidth(1),
            height: .fractionalHeight(1),
            spacing: 5)
        let horizontalGroup = CompositionalLayout.createGroup(
            aligment: .horizontal,
            width: .fractionalWidth(1/3),
            height: .fractionalWidth(1/3),
            item: item,
            count: 1)
        let section = NSCollectionLayoutSection(group: horizontalGroup)
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = .init(top: 6, leading: 12, bottom: 12, trailing: 12)

        let sectionHeader = createSectionHeader()
        section.boundarySupplementaryItems = [sectionHeader]

        return section
    }

    static func smallSizeTableSection() -> NSCollectionLayoutSection {

        let item = CompositionalLayout.createItem(
            width: .estimated(120),
            height: .absolute(36),
            spacing: 0)

        let group = CompositionalLayout.createGroup(
            aligment: .horizontal,
            width: item.layoutSize.widthDimension,
            height: item.layoutSize.heightDimension,
            items: [.init(layoutSize: item.layoutSize)]
        )

        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = .init(top: 12, leading: 12, bottom: 12, trailing: 12)
        section.interGroupSpacing = 8

        let sectionHeader = createSectionHeader()
        section.boundarySupplementaryItems = [sectionHeader]

        return section
    }

    static func descriptionLayoutSection() -> NSCollectionLayoutSection {
        let item = CompositionalLayout.createItem(
            width: .fractionalWidth(1),
            height: .estimated(120),
            spacing: 0)
        let group = CompositionalLayout.createGroup(
            aligment: .vertical,
            width: item.layoutSize.widthDimension,
            height: item.layoutSize.heightDimension,
            items: [.init(layoutSize: item.layoutSize)]
        )

        let section = NSCollectionLayoutSection(group: group)

        let sectionHeader = createSectionHeader()
        section.boundarySupplementaryItems = [sectionHeader]

        return section
    }

    static func gameCellLayoutSection() -> NSCollectionLayoutSection {
        let item = CompositionalLayout.createItem(
            width: .fractionalWidth(1),
            height: .absolute(100),
            spacing: 10)
        let group = CompositionalLayout.createGroup(
            aligment: .vertical,
            width: item.layoutSize.widthDimension,
            height: item.layoutSize.heightDimension,
            items: [.init(layoutSize: item.layoutSize)]
        )

        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: 0, leading: 12, bottom: 12, trailing: 12)
        section.interGroupSpacing = 6

        let sectionHeader = createSectionHeader()
        section.boundarySupplementaryItems = [sectionHeader]

        return section
    }

    static func imagesLayoutSection() -> NSCollectionLayoutSection {
        let item = CompositionalLayout.createItem(
            width: .fractionalWidth(1),
            height: .fractionalHeight(1),
            spacing: 5)
        let horizontalGroup = CompositionalLayout.createGroup(
            aligment: .horizontal,
            width: .fractionalWidth(2.7/3),
            height: .fractionalHeight(1/3),
            item: item,
            count: 1)
        let section = NSCollectionLayoutSection(group: horizontalGroup)
        section.orthogonalScrollingBehavior = .groupPaging
        section.contentInsets = .init(top: 0, leading: 12, bottom: 0, trailing: 12)

        let sectionHeader = createSectionHeader()
        section.boundarySupplementaryItems = [sectionHeader]

        return section
    }

    static func videosLayoutSection() -> NSCollectionLayoutSection {
        let item = CompositionalLayout.createItem(
            width: .fractionalWidth(1),
            height: .fractionalHeight(1),
            spacing: 5)
        let horizontalGroup = CompositionalLayout.createGroup(
            aligment: .horizontal,
            width: .fractionalWidth(2/3),
            height: .absolute(180),
            item: item,
            count: 1)
        let section = NSCollectionLayoutSection(group: horizontalGroup)
        section.orthogonalScrollingBehavior = .continuous

        let sectionHeader = createSectionHeader()
        section.boundarySupplementaryItems = [sectionHeader]

        return section
    }

    static func infoLayoutSection() -> NSCollectionLayoutSection {
        let item = CompositionalLayout.createItem(
            width: .estimated(200),
            height: .absolute(30),
            spacing: 0)
        let group = CompositionalLayout.createGroup(
            aligment: .horizontal,
            width: item.layoutSize.widthDimension,
            height: item.layoutSize.heightDimension,
            items: [.init(layoutSize: item.layoutSize)]
        )

        let section = NSCollectionLayoutSection(group: group)

        let sectionHeader = createSectionHeader()
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = .init(top: 0, leading: 12, bottom: 0, trailing: 0)
        section.interGroupSpacing = 8
        section.boundarySupplementaryItems = [sectionHeader]

        return section
    }

    static func buttonsLayoutSection() -> NSCollectionLayoutSection {
        let item = CompositionalLayout.createItem(
            width: .fractionalWidth(1/2),
            height: .absolute(50),
            spacing: 0)
        let group = CompositionalLayout.createGroup(
            aligment: .horizontal,
            width: .fractionalWidth(1),
            height: item.layoutSize.heightDimension,
            items: [item]
        )

        let section = NSCollectionLayoutSection(group: group)

        let sectionHeader = createSectionHeader()
        section.contentInsets = .init(top: 0, leading: 12, bottom: 0, trailing: 0)
        section.interGroupSpacing = 8
        section.boundarySupplementaryItems = [sectionHeader]

        return section
    }

    static func wishlistGameSection() -> NSCollectionLayoutSection {
        let item = CompositionalLayout.createItem(
            width: .fractionalWidth(1),
            height: .fractionalHeight(1),
            spacing: 12
        )
        let group = CompositionalLayout.createGroup(
            aligment: .horizontal,
            width: .fractionalWidth(1),
            height: .absolute(170),
            item: item,
            count: 2
        )

        let section = NSCollectionLayoutSection(group: group)

        let sectionHeader = createSectionHeader()
        section.contentInsets = .init(top: 0, leading: 12, bottom: 0, trailing: 0)
        section.interGroupSpacing = 8
        section.boundarySupplementaryItems = [sectionHeader]

        return section
    }

    static func createSectionHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
        let sectionHeaderSize = NSCollectionLayoutSize(widthDimension: .estimated(30), heightDimension: .estimated(30))
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: sectionHeaderSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .topLeading)
        return sectionHeader
    }
}
