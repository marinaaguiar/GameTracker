//
//  FilteredListViewController.swift
//  GameTracker
//
//  Created by Marina Aguiar on 10/3/22.
//

import UIKit
import Lottie

class FilteredListViewController: UIViewController {
    static let reuseIdentifier = "FilteredListViewController"
    private typealias DataSource = UICollectionViewDiffableDataSource<SectionType, ItemType>
    private var dataSource: DataSource?
    private let apiService = APIService()
    private var games: [SectionType: [GameResponse]] = [:]
    private var animationView: AnimationView?

    var sectionTitle: String!

    private var collectionView: UICollectionView!

    enum SectionType: Int, CaseIterable {
        case gameInfo

        var title: String {
            switch self {
            case .gameInfo:
                return ""
            }
        }
    }

    enum ItemType: Hashable {
        case gameInfo(GameResponse)

        func cell(in collectionView: UICollectionView, at indexPath: IndexPath) -> UICollectionViewCell {
            switch self {
            case let .gameInfo(gameResponse):
                return GameCell.dequeue(in: collectionView, indexPath: indexPath, model: gameResponse)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        title = sectionTitle
        collectionView.isHidden = true
        setupLottieAnimation()
    }
    
    func setupCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = DSColor.backgroundColor
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 30, right: 0)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.isUserInteractionEnabled = true
        collectionView.delegate = self
        view.addSubview(collectionView)

        NSLayoutConstraint.activate([
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])

        registerCells()
        createDataSource()
    }

    func setupLottieAnimation() {
        animationView = .init(name: "DiceLoader")

        guard let animationView = animationView else { return }

        animationView.frame = view.bounds
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        animationView.animationSpeed = 1.0
        animationView.isUserInteractionEnabled = false
        view.addSubview(animationView)
        animationView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            animationView.topAnchor.constraint(equalTo: view.topAnchor),
            animationView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            animationView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            animationView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        animationView.play()
    }


    func registerCells() {
        collectionView.register(
            SectionHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: SectionHeaderView.reuseIdentifier
        )

        collectionView.register(
            GameCell.self,
            forCellWithReuseIdentifier: GameCell.reuseIdentifier
        )
    }

    func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, layoutEnrivonment in
            let section = SectionType(rawValue: sectionIndex)

            switch section {
            case .gameInfo:
                return SectionLayoutBuilder.gameCellLayoutSection()
            case .none:
                return SectionLayoutBuilder.gameCellLayoutSection()
            }
        }

        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 5
        layout.configuration = config
        return layout
    }
}

//MARK: - UICollectionViewDelegate

extension FilteredListViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let section = SectionType(rawValue: indexPath.section) else { return }

        switch section {
        case .gameInfo:
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

extension FilteredListViewController {

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
        let sections: [SectionType] = [.gameInfo]
        snapshot.appendSections(sections)

        for section in sections {
            if let sectionGames = games[section] {
                let games = sectionGames.map { gameResponse in
                    ItemType.gameInfo(gameResponse)
                }
                snapshot.appendItems(games, toSection: section)
            }
        }
        dataSource?.apply(snapshot)
    }
}

// MARK: - APIRequests

extension FilteredListViewController {

    func fetchFilteredList(by filterParameter: FilterParameter, with value: Int) {
        apiService.loadGameListFiltered(limitItems: 15, filterBy: filterParameter, maxNumber: value, orderedBy: .rank) { result in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    self.games[.gameInfo] = data.games
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        self.animationView?.stop()
                        self.collectionView.isHidden = false
                        self.reloadData()
                    }
                }
                print("Load filtered list sucessfully")
            case .failure(let error):
                print(error)
            }
        }
    }
}
