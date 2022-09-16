import UIKit

class ExplorerViewController: UIViewController {

    var dataSource: UICollectionViewDiffableDataSource<Section, Section>?
    private let apiService = APIService()


    enum Section: Int, CaseIterable {
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

    @IBOutlet weak var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        apiService.loadGameList(limitItems: 5, orderedBy: .trending) { result in
            switch result {
            case .success(let data):
                print(data)
            case .failure(let error):
                print(error)
            }
        }
    }

    func setupCollectionView() {
        collectionView.register(
            ExplorerCollectionViewCell.self, forCellWithReuseIdentifier: ExplorerCollectionViewCell.identifier
        )
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.collectionViewLayout = createLayout()
        collectionView.allowsMultipleSelection = true

//        configureDataSource()
    }

//    func configureDataSource() {
////      dataSource = UICollectionViewDiffableDataSource
////        <Section, Section>(collectionView: collectionView) {
////          (collectionView: UICollectionView, indexPath: IndexPath, sectionItem: Section) -> UICollectionViewCell? in
////
////            let sectionTitle = Section.allCases[indexPath.section]
////
////          switch sectionTitle {
////          case .topRanked:
////              break
////          case .popularGames:
////              break
////          case .levelOfComplexity:
////              break
////          case .mechanics:
////              break
////          case .numberOfPlayers:
////              break
////          }
////      }
//
//        dataSource?.supplementaryViewProvider = { [weak self] collectionView, kind, indexPath in
//            guard let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionHeaderView.reuseIdentifier, for: indexPath) as? SectionHeaderView else {
//                return nil
//            }
//
//            guard let firstItem = self?.dataSource?.itemIdentifier(for: indexPath) else { return nil }
//            guard let section = self?.dataSource?.snapshot().sectionIdentifier(containingItem: firstItem) else { return nil }
//            if section.title.isEmpty { return nil }
//
//            sectionHeader.title.text = section.title
//            sectionHeader.subtitle.text = section.subtitle
//            return sectionHeader
//        }
//    }

//    func configureDataSource() {
//        //      dataSource = UICollectionViewDiffableDataSource
//        //        <Section, Section>(collectionView: collectionView) {
//        //          (collectionView: UICollectionView, indexPath: IndexPath, sectionItem: Section) -> UICollectionViewCell? in
//        //
//        //            let sectionTitle = Section.allCases[indexPath.section]
//        //
//        //          switch sectionTitle {
//        //          case .topRanked:
//        //              break
//        //          case .popularGames:
//        //              break
//        //          case .levelOfComplexity:
//        //              break
//        //          case .mechanics:
//        //              break
//        //          case .numberOfPlayers:
//        //              break
//        //          }
//        //      }
//
//        dataSource?.supplementaryViewProvider = { (
//            collectionView: UICollectionView,
//            kind: String,
//            indexPath: IndexPath) -> UICollectionReusableView? in
//
//            guard let supplementaryView = collectionView.dequeueReusableSupplementaryView(
//                ofKind: kind,
//                withReuseIdentifier: SectionHeaderView.reuseIdentifier,
//                for: indexPath) as? SectionHeaderView else { fatalError("Cannot create header view") }
//
//            supplementaryView.label.text = Section.allCases[indexPath.section].sectionTitle
//            return supplementaryView
//        }
//    }


    

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
            width: .fractionalWidth(2/3),
            height: .fractionalHeight(1/5),
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

//    func createDataSource() {
//
//    }
}

//MARK: - UICollectionViewDataSource

extension ExplorerViewController: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return Section.allCases.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        let numberOfItemsInSection = Section(rawValue: section)

        switch numberOfItemsInSection {
        case .topRanked:
            return 3
        case .popularGames:
            return 4
        case .levelOfComplexity:
            return 5
        case .mechanics:
            return 10
        case .numberOfPlayers:
            return 6
        case .none:
            return 0
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let explorerCell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ExplorerCollectionViewCell.identifier,
            for: indexPath
        )
        return explorerCell
    }

}

extension ExplorerViewController: UICollectionViewDelegate {

}
