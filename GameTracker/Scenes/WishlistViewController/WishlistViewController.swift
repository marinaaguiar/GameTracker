//
//  WishlistViewController.swift
//  GameTracker
//
//  Created by Marina Aguiar on 9/15/22.
//

import UIKit
import RealmSwift

class WishlistViewController: UIViewController {
    private typealias DataSource = UICollectionViewDiffableDataSource<SectionType, ItemType>
    static let reuseIdentifier = "WishlistViewController"

    private var dataSource: DataSource?
    private let apiService = APIService()
    let realm = try! Realm()
    private var games: [SectionType: [GameResponse]] = [:]
    private var collectionView: UICollectionView!

    enum SectionType: Int, CaseIterable {
        case wishlist

        var title: String {
            switch self {
            case .wishlist:
                return ""
            }
        }
    }

    enum ItemType: Hashable {
        case wishlist(GameResponse)

        func cell(in collectionView: UICollectionView, at indexPath: IndexPath) -> UICollectionViewCell {
            switch self {
            case let .wishlist(gameResponse):
                return WishlistGameCell.dequeue(in: collectionView, indexPath: indexPath, model: gameResponse)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Wishlist"
        setupCollectionView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationItem.largeTitleDisplayMode = .always
        tabBarController?.tabBar.isHidden = false

        let allGamesOnWishlist = realm.objects(Game.self)
        var gameIDs: [String] = []

        allGamesOnWishlist.forEach { game in
            gameIDs.append(game.gameID)
        }

        let gameIDsString = gameIDs.joined(separator: ",")

        if !gameIDsString.isEmpty {
            fetchWishlistGames(ids: gameIDsString)
        } else {
            // show an message to user that the
            // wishlist is empty
            // and ask them to add a new game on the wishlist
        }
    }

    func setupCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = DSColor.backgroundColor
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 30, right: 0)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.isUserInteractionEnabled = true
        collectionView.delegate = self
        registerCells()
        view.addSubview(collectionView)

        NSLayoutConstraint.activate([
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        createDataSource()
    }

    func registerCells() {
        collectionView.register(
            SectionHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: SectionHeaderView.reuseIdentifier
        )

        collectionView.register(
            WishlistGameCell.self,
            forCellWithReuseIdentifier: WishlistGameCell.reuseIdentifier
        )
    }

    func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, layoutEnrivonment in
            let section = SectionType(rawValue: sectionIndex)

            switch section {
            case .wishlist:
                return SectionLayoutBuilder.wishlistGameSection()
            case .none:
                return SectionLayoutBuilder.wishlistGameSection()
            }
        }

        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 5
        layout.configuration = config
        return layout
    }
}

//MARK: - UICollectionViewDelegate

extension WishlistViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let section = SectionType(rawValue: indexPath.section) else { return }

        switch section {
        case .wishlist:
            let detailViewController = storyboard?.instantiateViewController(withIdentifier: DetailViewController.reuseIdentifier) as! DetailViewController
            if let games = games[section] {
                detailViewController.gameDetail = GameDetail(gameResponse: games[indexPath.item])
                self.navigationController?.pushViewController(detailViewController, animated: true)
            } else {
                print("Error. There is no game selected.")
            }
        }
    }
}

// MARK: - DataSource

extension WishlistViewController {

    func createDataSource() {
        dataSource = DataSource(collectionView: collectionView) {
            collectionView, indexPath, item in
            return item.cell(in: collectionView, at: indexPath)
        }

        dataSource?.supplementaryViewProvider = { [weak self]
            collectionView, kind, indexPath -> UICollectionReusableView? in
            guard kind == UICollectionView.elementKindSectionHeader else { return nil }
            guard let view = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: SectionHeaderView.reuseIdentifier,
                for: indexPath) as? SectionHeaderView else {
                return nil
            }

            if let section = self?.dataSource?.snapshot().sectionIdentifiers[indexPath.section] {
                view.label.text = section.title
            }
            return view
        }
    }

    func reloadData() {
        var snapshot = NSDiffableDataSourceSnapshot<SectionType, ItemType>()
        let sections: [SectionType] = [.wishlist]
        snapshot.appendSections(sections)

        for section in sections {
            if let sectionGames = games[section] {
                let games = sectionGames.map { gameResponse in
                    ItemType.wishlist(gameResponse)
                }
                snapshot.appendItems(games, toSection: section)
            }
        }
        dataSource?.apply(snapshot)
    }
}

// MARK: - APIRequests

extension WishlistViewController {

    func fetchWishlistGames(ids: String) {
        apiService.loadGameWishlist(ids: ids) { result in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    self.games[.wishlist] = data.games
                    self.reloadData()
                }
                print("Load filtered list sucessfully")
            case .failure(let error):
                print(error)
            }
        }
    }
}



