import UIKit

class ExplorerViewController: UIViewController {

    enum Section: Int, CaseIterable, Hashable {
        case topRanked = 0
        case popularGames = 1
        case levelOfComplexity = 2
        case mechanics = 3
        case numberOfPlayers = 4

        var sectionTitle: String {
            switch self {
            case .topRanked:
                return "Top Ranked"
            case .popularGames:
                return "Popular Games"
            case .levelOfComplexity:
                return "LevelOfComplexity"
            case .mechanics:
                return "Mechanics"
            case .numberOfPlayers:
                return "Number Of Players"
            }
        }
    }

    private let apiService = APIService()
    private var gamesReponse: [GameResponse]?
    private var dataSource: UICollectionViewDiffableDataSource<Section, GameResponse>?
    let sections = Section.allCases

    @IBOutlet weak var collectionView: UICollectionView!

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        apiService.loadGameList(limitItems: 30, orderedBy: .trending) { result in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    self.gamesReponse = data.games
                    self.createDataSource()
                    self.reloadData()
                }
                print(data)
                print("Load data sucessfully")
            case .failure(let error):
                print(error)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
    }

    func setupCollectionView() {
        collectionView.delegate = self
        collectionView.collectionViewLayout = createLayout()
        collectionView.allowsMultipleSelection = true

//        collectionView.register(SectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeaderView.reuseIdentifier)
        collectionView.register(PopularGamesCell.self, forCellWithReuseIdentifier: PopularGamesCell.reuseIdentifier)
        collectionView.register(TopRankedCell.self, forCellWithReuseIdentifier: TopRankedCell.reuseIdentifier)

//        createDataSource()
//        reloadData()
    }

    func configure<T: SelfConfiguringCell>(_ cellType: T.Type, with item: GameResponse, for indexPath: IndexPath) -> T {

        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellType.reuseIdentifier, for: indexPath) as? T else {
            fatalError("Unable to deque \(cellType)")
        }
        cell.configure(with: item)
        return cell
    }

    func createDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, GameResponse>(collectionView: collectionView) { collectionView, indexPath, item in

            let section = Section(rawValue: indexPath.section)

            switch section {
            case .topRanked:
                return self.configure(TopRankedCell.self, with: item, for: indexPath)
            case .popularGames:
                return self.configure(PopularGamesCell.self, with: item, for: indexPath)
            default:
                return UICollectionViewCell()
            }
        }
//        dataSource?.supplementaryViewProvider = { [weak self] collectionView, kind, indexPath -> UICollectionReusableView? in
//            let dequeuedCell =  collectionView.dequeueReusableSupplementaryView(
//                ofKind: kind,
//                withReuseIdentifier: SectionHeaderView.reuseIdentifier,
//                for: indexPath
//            )
//
//            guard let sectionHeader = dequeuedCell as? SectionHeaderView else {
//                return nil
//            }
//
//            guard let topRankedGame = self?.dataSource?.itemIdentifier(for: indexPath) else { return nil }
//            guard let section = self?.dataSource?.snapshot().sectionIdentifier(containingItem: topRankedGame) else { return nil }
////            if section.sectionTitle.isEmpty { return nil }
//
////            sectionHeader.label = section.sectionTitle
//            return sectionHeader
//        }
    }

    func reloadData() {
        guard let gamesReponse = gamesReponse else { return }

        var snapshot = NSDiffableDataSourceSnapshot<Section, GameResponse>()
        let sections: [Section] = [.topRanked]
        snapshot.appendSections(sections)

        for section in sections {
            snapshot.appendItems(gamesReponse, toSection: section)
        }
        
        dataSource?.apply(snapshot)
    }

    func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment in
            let section = Section(rawValue: sectionIndex)

            switch section {
            case .topRanked:
                return self.createMediumSizeTableSection()
            case .popularGames:
                return self.createBigSizeTableSection()
            case .levelOfComplexity:
                return self.createSmallSizeTableSection()
            case .mechanics:
                return self.createMediumSizeTableSection()
            case .numberOfPlayers:
                return self.createSmallSizeTableSection()
            case .none:
                return self.createMediumSizeTableSection()
            }
        }

        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 5
        layout.configuration = config
        return layout
    }

    func createBigSizeTableSection() -> NSCollectionLayoutSection {
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

//        let sectionHeader = createSectionHeader()
//        section.boundarySupplementaryItems = [sectionHeader]

        return section
    }

    func createMediumSizeTableSection() -> NSCollectionLayoutSection {
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

//        let sectionHeader = createSectionHeader()
//        section.boundarySupplementaryItems = [sectionHeader]

        return section
    }

    func createSmallSizeTableSection() -> NSCollectionLayoutSection {
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

//        let sectionHeader = createSectionHeader()
//        section.boundarySupplementaryItems = [sectionHeader]

        return section
    }

//    func createSectionHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
//        let sectionHeaderSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.93), heightDimension: .estimated(30))
//        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: sectionHeaderSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
//        return sectionHeader
//    }

}

//MARK: - UICollectionViewDataSource

//extension ExplorerViewController: UICollectionViewDataSource {
//
//    func numberOfSections(in collectionView: UICollectionView) -> Int {
//        return Section.allCases.count
//    }
//
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//
//        let numberOfItemsInSection = Section(rawValue: section)
//
//        switch numberOfItemsInSection {
//        case .topRanked:
//            return 3
//        case .popularGames:
//            return 4
//        case .levelOfComplexity:
//            return 5
//        case .mechanics:
//            return 10
//        case .numberOfPlayers:
//            return 6
//        case .none:
//            return 0
//        }
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let explorerCell = collectionView.dequeueReusableCell(
//            withReuseIdentifier: ExplorerCollectionViewCell.identifier,
//            for: indexPath
//        )
//        return explorerCell
//    }
//
//}

extension ExplorerViewController: UICollectionViewDelegate {

}
