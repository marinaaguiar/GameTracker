import UIKit

class ExplorerViewController: UIViewController {
    struct State: Hashable {
        enum SectionType: Int {
            case topRanked = 0
            case popularGames
            case complexityLevel
            case mechanics
            case numberOfPlayers

            var title: String {
                switch self {
                case .topRanked:
                    return "Top Ranked"
                case .popularGames:
                    return "Popular Games"
                case .complexityLevel:
                    return "ComplexityLevel"
                case .mechanics:
                    return "Mechanics"
                case .numberOfPlayers:
                    return "Number Of Players"
                }
            }
        }
        var complexityLevels: [String] = []
        var games: [SectionType: [GameResponse]] = [:]
    }

    private let apiService = APIService()

    private var state = State()
    private var dataSource: UICollectionViewDiffableDataSource<State.SectionType, GameResponse>?

    @IBOutlet weak var collectionView: UICollectionView!

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchTopRankedGames()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
    }

    func setupCollectionView() {
        collectionView.delegate = self
        collectionView.collectionViewLayout = createLayout()
        collectionView.allowsMultipleSelection = true

        collectionView.register(
            SectionHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: SectionHeaderView.reuseIdentifier
        )
        collectionView.register(
            TopRankedCell.self,
            forCellWithReuseIdentifier: TopRankedCell.reuseIdentifier
        )
        collectionView.register(
            PopularGamesCell.self,
            forCellWithReuseIdentifier: PopularGamesCell.reuseIdentifier
        )
        collectionView.register(
            ComplexityLevelCell.self,
            forCellWithReuseIdentifier: ComplexityLevelCell.reuseIdentifier
        )

        createDataSource()
    }

    func configure<T: SelfConfiguringCell>(_ cellType: T.Type, with item: GameResponse, for indexPath: IndexPath) -> T {

        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellType.reuseIdentifier, for: indexPath) as? T else {
            fatalError("Unable to deque \(cellType)")
        }
        cell.configure(with: item)
        return cell
    }

    func configure<T: StandardConfiguringCell>(_ cellType: T.Type, for indexPath: IndexPath) -> T {

        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellType.reuseIdentifier, for: indexPath) as? T else {
            fatalError("Unable to deque \(cellType)")
        }
        cell.configure()
        return cell
    }

    func createDataSource() {
        dataSource = UICollectionViewDiffableDataSource<State.SectionType, GameResponse>(collectionView: collectionView) { collectionView, indexPath, item in
            let section = State.SectionType(rawValue: indexPath.section)

            switch section {
            case .topRanked:
                return self.configure(TopRankedCell.self, with: item, for: indexPath)
            case .popularGames:
                return self.configure(PopularGamesCell.self, with: item, for: indexPath)
            case .complexityLevel:
                return self.configure(ComplexityLevelCell.self, for: indexPath)
            default:
                return UICollectionViewCell()
            }
        }

        dataSource?.supplementaryViewProvider = { [weak self] collectionView, kind, indexPath -> UICollectionReusableView? in

            // 2
            guard kind == UICollectionView.elementKindSectionHeader else {
                return nil
            }
            // 3
            let view = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: SectionHeaderView.reuseIdentifier,
                for: indexPath) as? SectionHeaderView
            // 4
            let section = self?.dataSource?.snapshot()
                .sectionIdentifiers[indexPath.section]
            view?.label.text = section?.title
            return view
        }

    }

    func reloadData() {

        var snapshot = NSDiffableDataSourceSnapshot<State.SectionType, GameResponse>()

        let sections: [State.SectionType] = [.topRanked, .popularGames]
        snapshot.appendSections(sections)

        for section in sections {
            snapshot.appendItems(state.games[section]!, toSection: section)
        }
        
        dataSource?.apply(snapshot)
    }

    func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment in
            let section = State.SectionType(rawValue: sectionIndex)

            switch section {
            case .topRanked:
                return self.createMediumSizeTableSection()
            case .popularGames:
                return self.createBigSizeTableSection()
            case .complexityLevel:
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

        let sectionHeader = createSectionHeader()
        section.boundarySupplementaryItems = [sectionHeader]

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

        let sectionHeader = createSectionHeader()
        section.boundarySupplementaryItems = [sectionHeader]

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

        let sectionHeader = createSectionHeader()
        section.boundarySupplementaryItems = [sectionHeader]

        return section
    }

    func createSectionHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
        let sectionHeaderSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.93), heightDimension: .estimated(30))
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: sectionHeaderSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        return sectionHeader
    }

}

extension ExplorerViewController: UICollectionViewDelegate {

}

extension ExplorerViewController {

    func fetchTopRankedGames() {
        apiService.loadGameList(limitItems: 30, orderedBy: .rank) { result in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    self.state.games[.topRanked] = data.games
                    self.fetchPopularGames()
                }
                print("Load TopRankedGames sucessfully")
            case .failure(let error):
                print(error)
            }
        }
    }

    func fetchPopularGames() {
        apiService.loadGameList(limitItems: 30, orderedBy: .trending) { result in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    self.state.games[.popularGames] = data.games
                    self.reloadData()
                }
                print(data)
                print("Load PopularGames sucessfully")
            case .failure(let error):
                print(error)
            }
        }
    }

}
