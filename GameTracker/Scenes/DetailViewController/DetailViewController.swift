//
//  DetailViewController.swift
//  GameTracker
//
//  Created by Marina Aguiar on 9/26/22.
//

import UIKit

class DetailViewController: UIViewController {
    private typealias DataSource = UICollectionViewDiffableDataSource<SectionType, GameDetail>

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

    static let reuseIdentifier = "DetailViewController"
    private var dataSource: DataSource?
    var collectionView: UICollectionView!
    var gameDetail: GameDetail!

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupCollectionView()
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
        collectionView.backgroundColor = .cyan
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
            DescriptionCell.self,
            forCellWithReuseIdentifier: DescriptionCell.reuseIdentifier)

        createDataSource()
        reloadData()
    }

    func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment in
            let section = SectionType(rawValue: sectionIndex)

            switch section {
            case .gameImages:
                return SectionLayoutBuilder.createSmallSizeTableSection()
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

            let section = SectionType(rawValue: indexPath.section)

            switch section {
            case .description:
                return DescriptionCell.dequeue(in: collectionView, indexPath: indexPath, model: self.gameDetail)
            default:
                return DescriptionCell.dequeue(in: collectionView, indexPath: indexPath, model: self.gameDetail)
            }
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
        var snapshot = NSDiffableDataSourceSnapshot<SectionType, GameDetail>()

        let sections: [SectionType] = SectionType.allCases
        snapshot.appendSections(sections)

        snapshot.appendItems([gameDetail], toSection: .description)

        dataSource?.apply(snapshot)
    }
}
