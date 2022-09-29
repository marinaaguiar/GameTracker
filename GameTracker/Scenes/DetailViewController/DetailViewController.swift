//
//  DetailViewController.swift
//  GameTracker
//
//  Created by Marina Aguiar on 9/26/22.
//

import UIKit

class DetailViewController: UIViewController {
    private typealias DataSource = UICollectionViewDiffableDataSource<SectionType, ItemType>

    enum SectionType: Int, CaseIterable {
        case gameImages = 0
        case gameInfos
        case description
        case gameVideos

        var title: String {
            switch self {
            case .gameImages:
                return ""
            case .gameInfos:
                return ""
            case .description:
                return "Description"
            case .gameVideos:
                return "Videos"
            }
        }
    }

    enum ItemType: Hashable {
        case gameImages(GameImageResponse)
        case gameInfo(GameDetail)
        case gameDescription(GameDetail)
        case gameVideos(GameVideoResponse)

        func cell(in collectionView: UICollectionView, at indexPath: IndexPath) -> UICollectionViewCell {
            switch self {
            case let .gameImages(gameImageResponse):
                return GameDetailImagesCell.dequeue(in: collectionView, indexPath: indexPath, model: gameImageResponse)
            case let .gameInfo(gameDetail):
                return GameDetailInfosCell.dequeue(in: collectionView, indexPath: indexPath, model: gameDetail)
            case let .gameDescription(gameDetail):
                return GameDetailDescriptionCell.dequeue(in: collectionView, indexPath: indexPath, model: gameDetail)
            case let .gameVideos(gameVideos):
                return  GameDetailVideosCell.dequeue(in: collectionView, indexPath: indexPath, model: gameVideos)
            }
        }
    }

    static let reuseIdentifier = "DetailViewController"
    private var dataSource: DataSource?
    private let apiService = APIService()
    private var collectionView: UICollectionView!
    private var gameImages: [GameImageResponse] = []
    private var gameVideos: [GameVideoResponse] = []

    var gameDetail: GameDetail!

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        tabBarController?.tabBar.isHidden = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupCollectionView()
        fetchImages()
    }

    func setup() {
        title = "\(gameDetail.name) (\(gameDetail.yearPublished))"
    }

    func setupCollectionView() {
//        collectionView.delegate = self
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = DSColor.backgroundColor
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 30, right: 0)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)

        NSLayoutConstraint.activate([
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])

        collectionView.register(
            SectionHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: SectionHeaderView.reuseIdentifier
        )

        collectionView.register(
            GameDetailImagesCell.self,
            forCellWithReuseIdentifier: GameDetailImagesCell.reuseIdentifier
        )

        collectionView.register(
            GameDetailDescriptionCell.self,
            forCellWithReuseIdentifier: GameDetailDescriptionCell.reuseIdentifier
        )

        collectionView.register(
            GameDetailVideosCell.self,
            forCellWithReuseIdentifier: GameDetailVideosCell.reuseIdentifier
        )

        collectionView.register(
            GameDetailInfosCell.self,
            forCellWithReuseIdentifier: GameDetailInfosCell.reuseIdentifier
        )

        createDataSource()
//        reloadData()
    }

    func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment in
            let section = SectionType(rawValue: sectionIndex)

            switch section {
            case .gameImages:
                return SectionLayoutBuilder.bigSizeTableSection()
            case .gameInfos:
                return SectionLayoutBuilder.createSmallSizeTableSection()
            case .description:
                return SectionLayoutBuilder.createDescriptionLayoutSection()
            case .gameVideos:
                return SectionLayoutBuilder.createMediumSizeTableSection()
            case .none:
                return SectionLayoutBuilder.createMediumSizeTableSection()
            }
        }

        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 5
        layout.configuration = config
        return layout
    }
}

// MARK: - DataSource

extension DetailViewController {

    func createDataSource() {
        dataSource = DataSource(collectionView: collectionView) { collectionView, indexPath, item in
            return item.cell(in: collectionView, at: indexPath)
        }

        dataSource?.supplementaryViewProvider = { [weak self] collectionView, kind, indexPath -> UICollectionReusableView? in

            guard kind == UICollectionView.elementKindSectionHeader else { return nil }

            guard let view = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: SectionHeaderView.reuseIdentifier,
                for: indexPath) as? SectionHeaderView else {
                return nil
            }

            if let section = self?.dataSource?.snapshot()
                .sectionIdentifiers[indexPath.section] {
                view.label.text = section.title
            }
            return view
        }
    }

    func reloadData() {
        var snapshot = NSDiffableDataSourceSnapshot<SectionType, ItemType>()

        let sections: [SectionType] = [.gameImages, .gameInfos, .description]
        snapshot.appendSections(sections)

        for section in sections {
            if section == .gameImages && !gameImages.isEmpty {
                let gameImages = gameImages.map { gameImageResponse in
                    ItemType.gameImages(gameImageResponse)
                }
                snapshot.appendItems(gameImages, toSection: section)
            }

            if section == .gameInfos {
                let gameInfoDetail = gameDetail.map { gameDetailResponse in
                    ItemType.gameInfo(gameDetailResponse)
                }
                snapshot.appendItems([gameInfoDetail].compactMap { $0 }, toSection: section)
            }

            if section == .description {
                let gameDetail = gameDetail.map { gameDetailResponse in
                    ItemType.gameDescription(gameDetailResponse)
                }
                snapshot.appendItems([gameDetail].compactMap { $0 }, toSection: section)
            }

            if section == .gameVideos {
                let gameVideos = gameVideos.map { gameVideoResponse in
                    ItemType.gameVideos(gameVideoResponse)
                }
                snapshot.appendItems(gameVideos, toSection: section)
            }
        }

        dataSource?.apply(snapshot)
    }
}

// MARK: - APIRequests

extension DetailViewController {

    func fetchImages() {
        apiService.loadGameImages(limitItems: 5, gameId: gameDetail.id) { result in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    self.gameImages = data.images
                    self.reloadData()
                }
                print("Load Game Images sucessfully")
            case .failure(let error):
                print(error)
            }
        }
    }
}
