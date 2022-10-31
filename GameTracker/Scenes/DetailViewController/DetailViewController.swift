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
    static let reuseIdentifier = "DetailViewController"

    private typealias DataSource = UICollectionViewDiffableDataSource<SectionType, ItemType>
    private var dataSource: DataSource?

    private var collectionView: UICollectionView!
    private let apiService = APIService()
    private lazy var activityIndicator = UIActivityIndicatorView(style: .medium)
    private var gameImages: [GameImageResponse] = []
    private var gameVideos: [GameVideoResponse] = []
    private var wishlistGames: [String] = []
    let realm = try! Realm()

    var gameDetail: GameDetail! {
        didSet {
            gameDetailDescriptionModel = .init(gameDetail: gameDetail)
        }
    }
    var gameDetailDescriptionModel: GameDetailDescriptionModel!

    enum SectionType: Int, CaseIterable {
        case gameTitle = 0
        case gameImages
        case gameInfos
        case description
        case gameLinks
        case gameVideos

        var title: String {
            switch self {
            case .gameTitle:
                return ""
            case .gameImages:
                return ""
            case .gameInfos:
                return ""
            case .description:
                return "Description"
            case .gameLinks:
                return ""
            case .gameVideos:
                return "Videos"
            }
        }
    }

    enum ItemType: Hashable {
        case gameTitle(GameDetailDescriptionModel)
        case gameImages(GameImageResponse)
        case gameInfo(GameInfoType)
        case gameDescription(GameDetailDescriptionModel)
        case gameLinks(GameLinkType)
        case gameVideos(GameVideoResponse)

        func cell(in collectionView: UICollectionView, at indexPath: IndexPath) -> UICollectionViewCell {
            switch self {
            case let .gameTitle(gameDetail):
                return GameDetailTitleCell.dequeue(in: collectionView, indexPath: indexPath, model: gameDetail)
            case let .gameImages(gameImageResponse):
                return GameDetailImagesCell.dequeue(in: collectionView, indexPath: indexPath, model: gameImageResponse)
            case let .gameInfo(gameInfoDetail):
                return GameDetailInfosCell.dequeue(in: collectionView, indexPath: indexPath, model: gameInfoDetail)
            case let .gameDescription(gameDetail):
                return GameDetailDescriptionCell.dequeue(in: collectionView, indexPath: indexPath, model: gameDetail)
            case let .gameLinks(gameDetail):
                return GameDetailLinksCell.dequeue(in: collectionView, indexPath: indexPath, model: gameDetail)
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
        title = (gameDetail.name).components(separatedBy: ":").first
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
        collectionView.contentInset = UIEdgeInsets(top: -12, left: 0, bottom: 30, right: 0)
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
        collectionView.register(
            SectionHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: SectionHeaderView.reuseIdentifier
        )
        collectionView.register(
            GameDetailTitleCell.self,
            forCellWithReuseIdentifier: GameDetailTitleCell.reuseIdentifier
        )
        collectionView.register(
            GameDetailImagesCell.self,
            forCellWithReuseIdentifier: GameDetailImagesCell.reuseIdentifier
        )
        collectionView.register(
            GameDetailLinksCell.self,
            forCellWithReuseIdentifier: GameDetailLinksCell.reuseIdentifier
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
    }

    func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment in
            let section = SectionType(rawValue: sectionIndex)

            switch section {
            case .gameTitle:
                return SectionLayoutBuilder.titleLayoutSection()
            case .gameImages:
                return SectionLayoutBuilder.imagesLayoutSection()
            case .gameInfos:
                return SectionLayoutBuilder.infoLayoutSection()
            case .description:
                return SectionLayoutBuilder.descriptionLayoutSection()
            case .gameLinks:
                return SectionLayoutBuilder.buttonsLayoutSection()
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

        var sections: [SectionType] = SectionType.allCases

        snapshot.appendSections(sections)

        if gameVideos.isEmpty {
            snapshot.deleteSections([.gameVideos])
        }

        for section in sections {
            switch section {
            case .gameTitle:
                let gameDetail = gameDetailDescriptionModel.map { gameDetailResponse in
                    ItemType.gameTitle(gameDetailResponse)
                }
                snapshot.appendItems([gameDetail].compactMap { $0 }, toSection: section)
            case .gameImages:
                let gameImages = gameImages.map { gameImageResponse in
                    ItemType.gameImages(gameImageResponse)
                }
                snapshot.appendItems(gameImages, toSection: section)
            case .gameInfos:
                let gameInfoDetail = GameInfoType.allCases(with: gameDetail).map({ gameInfoDetail in
                    ItemType.gameInfo(gameInfoDetail)
                })
                snapshot.appendItems(gameInfoDetail.compactMap { $0 }, toSection: section)
            case .gameLinks:
                let gameDetail = GameLinkType.allCases().map({ gameDetail in
                    ItemType.gameLinks(gameDetail)
                })
                snapshot.appendItems(gameDetail.compactMap { $0 }, toSection: section)
            case .description:
                let gameDetail = gameDetailDescriptionModel.map { gameDetailResponse in
                    ItemType.gameDescription(gameDetailResponse)
                }
                snapshot.appendItems([gameDetail].compactMap { $0 }, toSection: section)
            case .gameVideos where gameVideos.isEmpty:
                snapshot.deleteSections([.gameVideos])

            case .gameVideos where !gameVideos.isEmpty:
                let gameVideos = gameVideos.map { gameVideoResponse in
                    ItemType.gameVideos(gameVideoResponse)
                }
                snapshot.appendItems(gameVideos, toSection: section)
            default:
                break
            }
            dataSource?.apply(snapshot)
        }
    }
}

// MARK: - UICollectionViewDelegate

extension DetailViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let section = SectionType(rawValue: indexPath.section) else { return }

        switch section {
        case .gameTitle:
            break
        case .gameLinks:
            if indexPath.item == 0 {
                if let url = URL(string: gameDetail.rulesUrl) {
                    if UIApplication.shared.canOpenURL(url) {
                        let safariVC = SFSafariViewController(url: url)
                        present(safariVC, animated: true, completion: nil)
                    } else {
                        Alert.showBasics(title: "Invalid url", message: "", vc: self)
                    }
                } else {
                    Alert.showBasics(title: "Sorry! \n Link not available.", message: "", vc: self)
                }
            } else {
                if let url = URL(string: gameDetail.officialUrl) {
                    if UIApplication.shared.canOpenURL(url) {
                        let safariVC = SFSafariViewController(url: url)
                        present(safariVC, animated: true, completion: nil)
                    } else {
                        Alert.showBasics(title: "Invalid url", message: "", vc: self)
                    }
                } else {
                    Alert.showBasics(title: "Sorry! \n Link not available.", message: "", vc: self)
                }
            }
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
