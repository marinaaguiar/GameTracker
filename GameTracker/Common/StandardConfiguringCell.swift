//
//  StandardConfiguringCell.swift
//  GameTracker
//
//  Created by Marina Aguiar on 9/21/22.
//

import Foundation
import UIKit

protocol StandardConfiguringCell {
    associatedtype CellModel

    static var reuseIdentifier: String { get }
    func configure(with item: CellModel)
    static func dequeue(in collectionView: UICollectionView, indexPath: IndexPath, model: CellModel) -> Self
}

extension StandardConfiguringCell {
    static func dequeue(in collectionView: UICollectionView, indexPath: IndexPath, model: CellModel) -> Self {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: Self.reuseIdentifier,
            for: indexPath
        )

        guard let dequeuedCell = cell as? Self else {
            fatalError("Unable to dequeue cell of type \(String(describing: Self.self))")
        }

        dequeuedCell.configure(with: model)
        return dequeuedCell

    }
}
