import UIKit

class ExploreViewController: UIViewController {
    private typealias DataSource = UICollectionViewDiffableDataSource<SectionType, ItemType>

    enum ComplexityLevel: String, CaseIterable {
        case veryEasy = "very easy"
        case easy = "easy"
        case moderate = "moderate"
        case difficult = "difficult"
        case veryDifficult = "very difficult"

    }

    enum NumberOfPlayers: String, CaseIterable {
        case onePlayer = "1 player"
        case twoPlayers = "2 players"
        case threePlayers = "3 players"
        case fourPlayers = "4 players"
        case fivePlusPlayers = "5+ players"
    }

    enum SectionType: Int {
        case trendingGames = 0
        case popularGames
        case complexityLevel
        case topRated
        case numberOfPlayers

        var title: String {
            switch self {
            case .trendingGames:
                return "Trending Games"
            case .popularGames:
                return "Popular Games"
            case .complexityLevel:
                return "Complexity Level"
            case .topRated:
                return "Top Rated"
            case .numberOfPlayers:
                return "Number Of Players"
            }
        }
    }

    enum ItemType: Hashable {
        case game(GameResponse)
        case complexity(String)
        case numberOfPlayers(String)

        func cell(in collectionView: UICollectionView, at indexPath: IndexPath) -> UICollectionViewCell {
            switch self {
            case let .game(gameResponse):
                return ImageGameCell.dequeue(in: collectionView, indexPath: indexPath, model: gameResponse)
            case let .complexity(complexity):
                return TypeFilterCell.dequeue(in: collectionView, indexPath: indexPath, model: complexity)
            case let .numberOfPlayers(numberOfPlayers):
                return  TypeFilterCell.dequeue(in: collectionView, indexPath: indexPath, model: numberOfPlayers)
            }
        }
    }

    private var games: [SectionType: [GameResponse]] = [:]
    private let apiService = APIService()
    private var dataSource: DataSource?

    private lazy var searchBar:UISearchBar = UISearchBar(frame: CGRectMake(0, 0, 300, 20))

    @IBOutlet weak var collectionView: UICollectionView!

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavBar()
        navigationItem.largeTitleDisplayMode = .never
        tabBarController?.tabBar.isHidden = false
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        fetchTrendingGames()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
    }

    func setupCollectionView() {
        collectionView.delegate = self
        collectionView.collectionViewLayout = createLayout()
        collectionView.allowsMultipleSelection = true
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 30, right: 0)

        collectionView.register(
            SectionHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: SectionHeaderView.reuseIdentifier
        )

        collectionView.register(
            ImageGameCell.self,
            forCellWithReuseIdentifier: ImageGameCell.reuseIdentifier)

        collectionView.register(
            TypeFilterCell.self,
            forCellWithReuseIdentifier: TypeFilterCell.reuseIdentifier
        )
        createDataSource()
    }

    func setupNavBar() {
        searchBar.placeholder = "Search game"
        let leftNavBarButton = UIBarButtonItem(customView: searchBar)

        let rightNavBarButton = UIBarButtonItem(image: UIImage(systemName: "slider.horizontal.3"), style: .plain, target: self, action: #selector(rightNavBarButtonPressed))
        rightNavBarButton.tintColor = DSColor.darkGray

        navigationItem.rightBarButtonItems = [rightNavBarButton, leftNavBarButton]

    }

    @objc func rightNavBarButtonPressed() {
        //
    }

    // MARK: - DataSource

    func createDataSource() {
        dataSource = DataSource(collectionView: collectionView) { collectionView, indexPath, item in
            return item.cell(in: collectionView, at: indexPath)
        }

        dataSource?.supplementaryViewProvider = { [weak self] collectionView, kind, indexPath -> UICollectionReusableView? in

            guard kind == UICollectionView.elementKindSectionHeader else {
                return nil
            }

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

        let sections: [SectionType] = [.trendingGames, .popularGames, .complexityLevel, .topRated, .numberOfPlayers]
        snapshot.appendSections(sections)

        for section in sections {

            if let sectionGames = games[section] {
                let games = sectionGames.map { gameResponse in
                    ItemType.game(gameResponse)
                }
                snapshot.appendItems(games, toSection: section)
            }

            if section == .complexityLevel {
                let complexityLevels = ComplexityLevel.allCases.map { complexity in
                    ItemType.complexity(complexity.rawValue)
                }
                snapshot.appendItems(complexityLevels, toSection: section)
            }

            if section == .numberOfPlayers {
                let numberOfPlayers = NumberOfPlayers.allCases.map { numberOfPlayer in
                    ItemType.numberOfPlayers(numberOfPlayer.rawValue)
                }
                snapshot.appendItems(numberOfPlayers, toSection: section)
            }
        }
        dataSource?.apply(snapshot)
    }
}

    //MARK: - UICollectionViewDelegate

   extension ExploreViewController: UICollectionViewDelegate {

       func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

           guard let section = SectionType(rawValue: indexPath.section) else { return }

           var detailViewController = storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController

           if let games = games[section] {
               detailViewController.gameDetail = GameDetail(gameResponse: games[indexPath.item])
               self.navigationController?.pushViewController(detailViewController, animated: true)
           } else {
               presentErrorAlert("Error gameSelected is nil")
           }
       }
   }

    // MARK: - Layout

extension ExploreViewController {

    func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment in
            let section = SectionType(rawValue: sectionIndex)

            switch section {
            case .trendingGames:
                return SectionLayoutBuilder.mediumSizeTableSection()
            case .popularGames:
                return SectionLayoutBuilder.bigSizeTableSection()
            case .complexityLevel:
                return SectionLayoutBuilder.smallSizeTableSection()
            case .topRated:
                return SectionLayoutBuilder.mediumSizeTableSection()
            case .numberOfPlayers:
                return SectionLayoutBuilder.smallSizeTableSection()
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

// MARK: - APIRequests

extension ExploreViewController {

    func fetchTrendingGames() {
        apiService.loadGameList(limitItems: 30, orderedBy: .trending) { result in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    self.games[.trendingGames] = data.games
                    self.fetchPopularGames()
                }
                print("Load TrendingGames sucessfully")
            case .failure(let error):
                print(error)
            }
        }
    }

    func fetchPopularGames() {
        apiService.loadGameList(limitItems: 30, orderedBy: .rank) { result in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    self.games[.popularGames] = data.games
                    self.fetchTopRatedGames()
                }
                print(data)
                print("Load PopularGames sucessfully")
            case .failure(let error):
                print(error)
            }
        }
    }

    func fetchTopRatedGames() {
        apiService.loadGameList(limitItems: 30, orderedBy: .average_user_rating) { result in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    self.games[.topRated] = data.games
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

// MARK: - Alerts

extension ExploreViewController {

    func presentErrorAlert(_ error: String) {
        let alert = UIAlertController(title: "Error", message: "\(error)", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default)
        alert.addAction(okAction)
        self.present(alert, animated: true)
    }
}
