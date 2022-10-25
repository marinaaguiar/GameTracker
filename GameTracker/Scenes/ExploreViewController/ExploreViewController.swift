import UIKit
import Lottie

class ExploreViewController: UIViewController {
    private typealias DataSource = UICollectionViewDiffableDataSource<SectionType, ItemType>

    enum SectionType: Int {
        case trendingGames = 0
        case popularGames
        case playingTime
        case topRated
        case numberOfPlayers

        var title: String {
            switch self {
            case .trendingGames:
                return "Trending Games"
            case .popularGames:
                return "Popular Games"
            case .playingTime:
                return "Playtime"
            case .topRated:
                return "Top Rated"
            case .numberOfPlayers:
                return "Number Of Players"
            }
        }
    }

    enum ItemType: Hashable {
        case game(GameResponse)
        case playingTime(String)
        case numberOfPlayers(String)

        func cell(in collectionView: UICollectionView, at indexPath: IndexPath) -> UICollectionViewCell {
            switch self {
            case let .game(gameResponse):
                return ImageGameCell.dequeue(in: collectionView, indexPath: indexPath, model: gameResponse)
            case let .playingTime(playingTime):
                return TypeFilterCell.dequeue(in: collectionView, indexPath: indexPath, model: playingTime)
            case let .numberOfPlayers(numberOfPlayers):
                return  TypeFilterCell.dequeue(in: collectionView, indexPath: indexPath, model: numberOfPlayers)
            }
        }
    }
    private let apiService = APIService()
    private var games: [SectionType: [GameResponse]] = [:]
    private var dataSource: DataSource?

    private var collectionView: UICollectionView!
    private var animationView: LottieAnimationView?
    private lazy var searchBar: UISearchBar = UISearchBar()

    private var errorView = UIView()
    private var errorLabel = UILabel()
    private var reloadButton = UIButton(type: .system)

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
        navigationItem.largeTitleDisplayMode = .never
        searchBar.resignFirstResponder()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tabBarController?.tabBar.isUserInteractionEnabled = false
        presentAnimation(.entryLoader)
        setupNavBar()
        setupCollectionView()
        collectionView.isHidden = true
        fetchTrendingGames()
        searchBar.delegate = self
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
    }

    func setupCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 30, right: 0)
        collectionView.backgroundColor = DSColor.backgroundColor
        collectionView.allowsMultipleSelection = true
        collectionView.translatesAutoresizingMaskIntoConstraints = false
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

    func registerCells() {
        collectionView.register(
            SectionHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: SectionHeaderView.reuseIdentifier
        )
        collectionView.register(
            ImageGameCell.self,
            forCellWithReuseIdentifier: ImageGameCell.reuseIdentifier
        )
        collectionView.register(
            TypeFilterCell.self,
            forCellWithReuseIdentifier: TypeFilterCell.reuseIdentifier
        )
    }

    enum LoaderAnimation: String {
        case entryLoader = "DiceRollingLottie"
        case reloadLoader = "DiceLoader"
    }

    func presentAnimation(_ loaderAnimation: LoaderAnimation) {
        searchBar.isHidden = true
        tabBarController?.tabBar.isHidden = true
        animationView?.isHidden = false

        animationView = .init(name: loaderAnimation.rawValue)

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

    func setupNavBar() {
        searchBar.placeholder = "Search game"
        searchBar.sizeToFit()
        navigationItem.titleView = searchBar
    }

    func presentErrorView() {
        tabBarController?.tabBar.isHidden = true
        collectionView.isHidden = true
        errorLabel.isHidden = false
        reloadButton.isHidden = false
        reloadButton.isEnabled = true

        view.addSubview(errorView)
        errorView.translatesAutoresizingMaskIntoConstraints = false
        errorView.backgroundColor = DSColor.backgroundColor

        errorView.addSubview(errorLabel)
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        errorLabel.text = "Sorry! \n Unable to connect the server. \n Please, try connecting again later."
        errorLabel.numberOfLines = 0
        errorLabel.textAlignment = .center
        errorLabel.textColor = DSColor.darkGray

        errorView.addSubview(reloadButton)
        reloadButton.translatesAutoresizingMaskIntoConstraints = false
        reloadButton.setTitle("Try Again", for: .normal)
        reloadButton.setTitleColor(.systemBlue, for: .normal)
        reloadButton.backgroundColor = .white
        reloadButton.layer.cornerRadius = 20
        reloadButton.addTarget(self, action: #selector(reloadButtonPressed), for: .touchUpInside)

        NSLayoutConstraint.activate([
            errorView.topAnchor.constraint(equalTo: view.topAnchor),
            errorView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            errorView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            errorView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            errorLabel.centerYAnchor.constraint(equalTo: errorView.centerYAnchor),
            errorLabel.centerXAnchor.constraint(equalTo: errorView.centerXAnchor),
            errorLabel.leadingAnchor.constraint(equalTo: errorView.leadingAnchor),
            errorLabel.trailingAnchor.constraint(equalTo: errorView.trailingAnchor),
            errorLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: CGFloat(30)),

            reloadButton.bottomAnchor.constraint(equalTo: errorView.bottomAnchor, constant: CGFloat(-80)),
            reloadButton.centerXAnchor.constraint(equalTo: errorView.centerXAnchor),
            reloadButton.widthAnchor.constraint(equalToConstant: CGFloat(200)),
            reloadButton.heightAnchor.constraint(equalToConstant: CGFloat(40))
        ])
    }

    @objc func reloadButtonPressed() {
        presentAnimation(.reloadLoader)
        errorLabel.isHidden = true
        reloadButton.isHidden = true
        reloadButton.isEnabled = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.fetchTrendingGames()
        }
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

        let sections: [SectionType] = [.trendingGames, .popularGames, .playingTime, .topRated, .numberOfPlayers]
        snapshot.appendSections(sections)

        for section in sections {

            if let sectionGames = games[section] {
                let games = sectionGames.map { gameResponse in
                    ItemType.game(gameResponse)
                }
                snapshot.appendItems(games, toSection: section)
            }

            if section == .playingTime {
                let playingTime = Playtime.allCases.map { playTime in
                    ItemType.playingTime(playTime.string)
                }
                snapshot.appendItems(playingTime, toSection: section)
            }

            if section == .numberOfPlayers {
                let numberOfPlayers = NumberOfPlayers.allCases.map { numberOfPlayers in
                    ItemType.numberOfPlayers(numberOfPlayers.string)
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

           let detailViewController = storyboard?.instantiateViewController(withIdentifier: DetailViewController.reuseIdentifier) as! DetailViewController

           let filteredViewController = storyboard?.instantiateViewController(withIdentifier: FilteredListViewController.reuseIdentifier) as! FilteredListViewController

           switch section {
           case .playingTime:
               if let maxPlayTime = Playtime(rawValue: indexPath.item) {
                   filteredViewController.fetchFilteredList(by: .maxPlaytime, with: maxPlayTime.number)
                   filteredViewController.sectionTitle = "Max Playtime: \(maxPlayTime.number)min"
                   self.navigationController?.pushViewController(filteredViewController, animated: true)
               }
           case .numberOfPlayers:
               if let numberOfPlayers = NumberOfPlayers(rawValue: indexPath.item) {
                   filteredViewController.fetchFilteredList(by: .minPlayers, with: numberOfPlayers.number)
                   filteredViewController.sectionTitle = "Min Players: \(numberOfPlayers.number)"
                   self.navigationController?.pushViewController(filteredViewController, animated: true)
               }

               print("selected numberOfPlayers")
           case .topRated, .popularGames, .trendingGames:
               if let games = games[section] {
                   detailViewController.gameDetail = GameDetail(gameResponse: games[indexPath.item])
                   self.navigationController?.pushViewController(detailViewController, animated: true)
               } else {
                   presentErrorAlert("Error. There is no game selected.")
               }
           }
       }
   }

    // MARK: - SearchBar

extension ExploreViewController: UISearchBarDelegate {

    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {

        let searchViewController = storyboard?.instantiateViewController(withIdentifier: SearchViewController.reuseIdentifier) as! SearchViewController

        self.navigationController?.pushViewController(searchViewController, animated: true)

        print("should begin editing")
        return true
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
            case .playingTime:
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
                DispatchQueue.main.async {
                    self.animationView?.stop()
                    self.animationView?.isHidden = true
                    self.presentErrorView()
                }
                print("Server out of Service")
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
                    self.animationView?.stop()
                    self.animationView?.isHidden == true
                    self.collectionView.isHidden = false
                    self.collectionView.allowsSelection = true
                    self.searchBar.isHidden = false
                    self.errorView.isHidden = true
                    self.tabBarController?.tabBar.isUserInteractionEnabled = true
                    self.tabBarController?.tabBar.isHidden = false
                    self.reloadData()
                }
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
