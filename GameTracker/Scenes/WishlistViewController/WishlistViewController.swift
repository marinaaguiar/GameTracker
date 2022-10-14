//
//  WishlistViewController.swift
//  GameTracker
//
//  Created by Marina Aguiar on 9/15/22.
//

import UIKit

class WishlistViewController: UIViewController {
    private typealias DataSource = UICollectionViewDiffableDataSource<SectionType, ItemType>
    static let reuseIdentifier = "WishlistViewController"

    private var dataSource: DataSource?
    private let apiService = APIService()
    private var collectionView: UICollectionView!

    enum SectionType: Int, CaseIterable {
        case wishlist

        var title: String {
            switch self {
            case .wishlist:
                return "Wishlist"
            }
        }
    }

    enum ItemType: Hashable {
        case wishlist(GameResponse)

        func cell(in collectionView: UICollectionView, at indexPath: IndexPath) -> UICollectionViewCell {
            switch self {
            case let .wishlist(gameResponse):
                return ImageGameCell.dequeue(in: collectionView, indexPath: indexPath, model: gameResponse)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
}
