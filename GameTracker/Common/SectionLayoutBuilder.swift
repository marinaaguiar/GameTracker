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
            width: .fractionalWidth(2.8/3),
            height: .fractionalHeight(1/3),
            item: item,
            count: 1)
        let section = NSCollectionLayoutSection(group: horizontalGroup)
        section.orthogonalScrollingBehavior = .groupPaging

        let sectionHeader = createSectionHeader()
        section.boundarySupplementaryItems = [sectionHeader]

        return section
    }

    static func createMediumSizeTableSection() -> NSCollectionLayoutSection {
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

        let sectionHeader = createSectionHeader()
        section.boundarySupplementaryItems = [sectionHeader]

        return section
    }

    static func createSmallSizeTableSection() -> NSCollectionLayoutSection {
        let item = CompositionalLayout.createItem(
            width: .fractionalWidth(1),
            height: .fractionalHeight(1),
            spacing: 10)
        let horizontalGroup = CompositionalLayout.createGroup(
            aligment: .horizontal,
            width: .absolute(180),
            height: .absolute(60),
            item: item,
            count: 1)
        let section = NSCollectionLayoutSection(group: horizontalGroup)
        section.orthogonalScrollingBehavior = .continuous

        let sectionHeader = createSectionHeader()
        section.boundarySupplementaryItems = [sectionHeader]

        return section
    }

    static func createDescriptionLayoutSection() -> NSCollectionLayoutSection {
        let item = CompositionalLayout.createItem(
            width: .fractionalWidth(1),
            height: .fractionalHeight(1),
            spacing: 0)
        let horizontalGroup = CompositionalLayout.createGroup(
            aligment: .vertical,
            width: .fractionalWidth(1),
            height: .absolute(300),
            item: item,
            count: 1)
        let section = NSCollectionLayoutSection(group: horizontalGroup)

        let sectionHeader = createSectionHeader()
        section.boundarySupplementaryItems = [sectionHeader]

        return section
    }

    static func createSectionHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
        let sectionHeaderSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(30))
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: sectionHeaderSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        return sectionHeader
    }
}
