//
//  DetailViewController.swift
//  GameTracker
//
//  Created by Marina Aguiar on 9/26/22.
//

import UIKit
import SafariServices
import RealmSwift

class DetailViewController: UIViewController {
    private typealias DataSource = UICollectionViewDiffableDataSource<SectionType, ItemType>
    static let reuseIdentifier = "DetailViewController"
    private var dataSource: DataSource?
    private let apiService = APIService()
    let realm = try! Realm()
    private var collectionView: UICollectionView!
    private lazy var activityIndicator = UIActivityIndicatorView(style: .medium)
    private var gameImages: [GameImageResponse] = []
    private var gameVideos: [GameVideoResponse] = []

    var wishlistGames: [String] = []
    var gameDetail: GameDetail! {
        didSet {
            gameDetailDescriptionModel = .init(gameDetail: gameDetail)
        }
    }
    var gameDetailDescriptionModel: GameDetailDescriptionModel!

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
        case gameInfo(GameInfoType)
        case gameDescription(GameDetailDescriptionModel)
        case gameVideos(GameVideoResponse)

        func cell(in collectionView: UICollectionView, at indexPath: IndexPath) -> UICollectionViewCell {
            switch self {
            case let .gameImages(gameImageResponse):
                return GameDetailImagesCell.dequeue(in: collectionView, indexPath: indexPath, model: gameImageResponse)
            case let .gameInfo(gameInfoDetail):
                return GameDetailInfosCell.dequeue(in: collectionView, indexPath: indexPath, model: gameInfoDetail)
            case let .gameDescription(gameDetail):
                return GameDetailDescriptionCell.dequeue(in: collectionView, indexPath: indexPath, model: gameDetail)
            case let .gameVideos(gameVideos):
                return  GameDetailVideosCell.dequeue(in: collectionView, indexPath: indexPath, model: gameVideos)
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        tabBarController?.tabBar.isHidden = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTitle()
        setupNavBar()
        setupCollectionView()
        collectionView.isHidden = true
        setupActivityIndicator()
        fetchImages()
        print(Realm.Configuration.defaultConfiguration.fileURL)
    }

    func setupTitle() {
        title = "\(gameDetail.name) (\(gameDetail.yearPublished))"
    }

    func setupNavBar() {
        // check if this game contains in the realm database already
        // if wishlist contain this game:
        let allGamesOnWishlist = realm.objects(Game.self)

        if allGamesOnWishlist.contains(where: {
            $0.gameID == gameDetail.id
        }) == true {
            let rightNavBarButton = UIBarButtonItem(image: UIImage(systemName: "heart.fill"), style: .plain, target: self, action: #selector(rightNavBarButtonPressed))
            rightNavBarButton.tintColor = .systemBlue
            navigationItem.rightBarButtonItems = [rightNavBarButton]
        }
else {
            let rightNavBarButton = UIBarButtonItem(image: UIImage(systemName: "heart"), style: .plain, target: self, action: #selector(rightNavBarButtonPressed))
            rightNavBarButton.tintColor = .systemBlue
            navigationItem.rightBarButtonItems = [rightNavBarButton]
        }
    }

    @objc func rightNavBarButtonPressed() {
        let allGamesOnWishlist = realm.objects(Game.self)

        if allGamesOnWishlist.contains(where: {
            $0.gameID == gameDetail.id
        }) == true {
            print("remove game of wishlist")
            removeGameOfWishlist()
        } else {
            print("add game to wishlist")
            saveGameOnWishlist()
        }
        setupNavBar()
    }

    func saveGameOnWishlist() {
        let game = Game(gameID: gameDetail.id)
        realm.beginWrite()
        realm.add(game)
        try! realm.commitWrite()
    }

    func removeGameOfWishlist() {
        let allGamesOnWishlist = realm.objects(Game.self)

        let gameToBeDeleted = allGamesOnWishlist.where {
            $0.gameID == gameDetail.id
        }

        realm.beginWrite()
        realm.delete(gameToBeDeleted)
        try! realm.commitWrite()
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

    func setupActivityIndicator() {
        view.addSubview(activityIndicator)
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }


    func registerCells() {
        collectionView.register(SectionHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: SectionHeaderView.reuseIdentifier
        )

        collectionView.register(GameDetailImagesCell.self,
            forCellWithReuseIdentifier: GameDetailImagesCell.reuseIdentifier
        )

        collectionView.register(GameDetailDescriptionCell.self,
            forCellWithReuseIdentifier: GameDetailDescriptionCell.reuseIdentifier
        )

        collectionView.register(GameDetailVideosCell.self,
            forCellWithReuseIdentifier: GameDetailVideosCell.reuseIdentifier
        )

        collectionView.register(GameDetailInfosCell.self,
            forCellWithReuseIdentifier: GameDetailInfosCell.reuseIdentifier
        )
    }

    func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment in
            let section = SectionType(rawValue: sectionIndex)

            switch section {
            case .gameImages:
                return SectionLayoutBuilder.imagesLayoutSection()
            case .gameInfos:
                return SectionLayoutBuilder.infoLayoutSection()
            case .description:
                return SectionLayoutBuilder.descriptionLayoutSection()
            case .gameVideos:
                return SectionLayoutBuilder.videosLayoutSection()
            case .none:
                return SectionLayoutBuilder.mediumSizeTableSection()
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

        let sections: [SectionType] = [.gameImages, .gameInfos, .description, .gameVideos]
        snapshot.appendSections(sections)

        for section in sections {

            switch section {
            case .gameImages:
                let gameImages = gameImages.map { gameImageResponse in
                    ItemType.gameImages(gameImageResponse)
                }
                snapshot.appendItems(gameImages, toSection: section)
            case .gameInfos:


                let gameInfoDetail = GameInfoType.allCases(with: gameDetail).map({ gameInfoDetail in
                    ItemType.gameInfo(gameInfoDetail)
                })

//                let gameInfoDetail = gameDetail.map { gameDetailResponse in
//                    ItemType.gameInfo(gameDetailResponse)
//                }
                snapshot.appendItems(gameInfoDetail.compactMap { $0 }, toSection: section)


            case .description:
                let gameDetail = gameDetailDescriptionModel.map { gameDetailResponse in
                    ItemType.gameDescription(gameDetailResponse)
                }
                snapshot.appendItems([gameDetail].compactMap { $0 }, toSection: section)
            case .gameVideos:
                let gameVideos = gameVideos.map { gameVideoResponse in
                    ItemType.gameVideos(gameVideoResponse)
                }
                snapshot.appendItems(gameVideos, toSection: section)
            }
        }

        dataSource?.apply(snapshot)
    }
}

// MARK: - UICollectionViewDelegate

extension DetailViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let section = SectionType(rawValue: indexPath.section) else { return }

        switch section {
        case .description:
            print("selected description")
            if gameDetailDescriptionModel.isDescriptionExpanded == false {
                gameDetailDescriptionModel.isDescriptionExpanded = true
            } else {
                gameDetailDescriptionModel.isDescriptionExpanded = false
            }
            reloadData()
        case .gameVideos:
            if let url = URL(string: gameVideos[indexPath.item].url) {
                if UIApplication.shared.canOpenURL(url) {
                    let safariVC = SFSafariViewController(url: url)
                    present(safariVC, animated: true, completion: nil)
                } else {
                    Alert.showBasics(title: "Invalid url", message: "", vc: self)
                }
            } else {
                Alert.showBasics(title: "Failed to show video", message: "", vc: self)
            }
        case .gameImages:
            break
        case .gameInfos:
            break
        }
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
                    self.fetchVideos()
                }
                print("Load Game Images Sucessfully")
            case .failure(let error):
                print(error)
            }
        }
    }

    func fetchVideos() {
        apiService.loadGameVideos(limitItems: 5, gameId: gameDetail.id) { result in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    self.gameVideos = data.videos
                    self.reloadData()
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.isHidden = true
                    self.collectionView.isHidden = false
                }
                print("Load Game Videos Sucessfully")
            case .failure(let error):
                print(error)
            }
        }
    }
}
